import 'package:flutter/material.dart';

import '../../../../app/app_scope.dart';
import '../../../../app/app_theme.dart';
import '../../../../app/app_translations.dart';
import '../../../../app/language_controller.dart';
import '../../../../app/role_controller.dart';
import '../../../../core/storage/app_storage.dart';
import 'controllers/offers_controller.dart';
import 'widgets/offer_card.dart';

class OffersScreen extends StatefulWidget {
  const OffersScreen({
    super.key,
    this.storage,
    this.roleController,
    this.languageController,
  });

  final AppStorage? storage;
  final RoleController? roleController;
  final AppLanguageController? languageController;

  @override
  State<OffersScreen> createState() => _OffersScreenState();
}

class _OffersScreenState extends State<OffersScreen> {
  OffersController? _controller;
  AppLanguageController? _languageController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final appScope = AppScope.of(context);
    _languageController ??=
        widget.languageController ?? appScope.languageController;

    if (_controller == null) {
      final storage = widget.storage ?? appScope.storage;
      final role = widget.roleController ?? appScope.roleController;

      _controller = OffersController(
        offerRepository: storage.offers,
        productRepository: storage.products,
        roleController: role,
      );
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _handleStatusChange(String offerId, String newStatus, String actionName,
      AppTranslations tr) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(tr.offerDialogTitle(actionName)),
        content: Text(tr.offerDialogContent(actionName)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(tr.cancel),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              await _controller?.updateOfferStatus(offerId, newStatus);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(tr.offerUpdatedSnackbar(actionName)),
                    backgroundColor: newStatus == 'accepted'
                        ? FarmColors.forest
                        : FarmColors.alert,
                  ),
                );
              }
            },
            child: Text(tr.confirm),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final listenables = <Listenable>[_controller!];
    if (_languageController != null) {
      listenables.add(_languageController!);
    }

    return ListenableBuilder(
      listenable: Listenable.merge(listenables),
      builder: (context, _) {
        final tr = AppTranslations.of(context);
        final isProducer = _controller!.isProducer;
        final offers = _controller!.filteredOffers;
        final selectedFilter = _controller!.selectedStatusFilter;

        return Scaffold(
          appBar: AppBar(
            title: Text(
              isProducer ? tr.offersProducerTitle : tr.offersConsumerTitle,
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
            ),
          ),
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Rol bilgilendirme şeridi
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isProducer
                        ? const Color(0xFFF1F6F2)
                        : const Color(0xFFFDF7EA),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isProducer
                          ? FarmColors.forest.withAlpha(60)
                          : FarmColors.gold.withAlpha(90),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isProducer
                            ? Icons.storefront_rounded
                            : Icons.shopping_bag_outlined,
                        color: isProducer ? FarmColors.forest : FarmColors.gold,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          isProducer
                              ? tr.offersProducerInfo
                              : tr.offersConsumerInfo,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: FarmColors.ink.withAlpha(210),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Durum filtreleme çipleri
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: Row(
                    children: [
                      _buildFilterChip(
                          'all',
                          '${tr.offerFilterAll} (${_controller!.roleSpecificOffers.length})',
                          selectedFilter),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                          'pending',
                          '${tr.offerFilterPending} (${_controller!.pendingCount})',
                          selectedFilter),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                          'accepted',
                          '${tr.offerFilterAccepted} (${_controller!.acceptedCount})',
                          selectedFilter),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                          'rejected',
                          '${tr.offerFilterRejected} (${_controller!.rejectedCount})',
                          selectedFilter),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                // Liste
                Expanded(
                  child: offers.isEmpty
                      ? Center(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.all(28),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(18),
                                  decoration: BoxDecoration(
                                    color: FarmColors.gold.withAlpha(25),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.inbox_rounded,
                                    size: 48,
                                    color: FarmColors.gold,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  tr.offerNoOffers,
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w800,
                                    color: FarmColors.ink,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  isProducer
                                      ? tr.offerNoProducerOffersDesc
                                      : tr.offerNoConsumerOffersDesc,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: FarmColors.ink.withAlpha(160),
                                    height: 1.4,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                if (selectedFilter != 'all' &&
                                    _controller!.roleSpecificOffers.isNotEmpty)
                                  FilledButton.icon(
                                    onPressed: () =>
                                        _controller!.setStatusFilter('all'),
                                    icon: const Icon(
                                        Icons.filter_alt_off_rounded),
                                    label: Text(
                                      tr.offerShowAll(
                                          _controller!.roleSpecificOffers.length),
                                    ),
                                    style: FilledButton.styleFrom(
                                      backgroundColor: FarmColors.forest,
                                    ),
                                  ),
                                if (_controller!.allOffers.isEmpty) ...[
                                  FilledButton.icon(
                                    onPressed: () =>
                                        _controller!.reloadDemoOffers(),
                                    icon: const Icon(Icons.refresh_rounded),
                                    label: Text(tr.offerLoadDemo),
                                    style: FilledButton.styleFrom(
                                      backgroundColor: FarmColors.forest,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                ],
                                const SizedBox(height: 8),
                                OutlinedButton.icon(
                                  onPressed: () => Navigator.pushNamed(
                                      context, '/marketplace'),
                                  icon: const Icon(Icons.storefront_rounded),
                                  label: Text(tr.offerGoToMarketplace),
                                ),
                              ],
                            ),
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                          itemCount: offers.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final offer = offers[index];
                            final product =
                                _controller!.findProduct(offer.productId);

                            return OfferCard(
                              offer: offer,
                              product: product,
                              isProducer: isProducer,
                              onAccept: () => _handleStatusChange(
                                  offer.id,
                                  'accepted',
                                  tr.offerActionAccept,
                                  tr),
                              onReject: () => _handleStatusChange(
                                  offer.id,
                                  'rejected',
                                  tr.offerActionReject,
                                  tr),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFilterChip(String key, String label, String selectedKey) {
    final isSelected = key.toLowerCase() == selectedKey.toLowerCase();
    return FilterChip(
      selected: isSelected,
      label: Text(label),
      selectedColor: FarmColors.forest,
      backgroundColor: FarmColors.milk,
      labelStyle: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: isSelected ? Colors.white : FarmColors.ink,
      ),
      side: BorderSide(
        color: isSelected ? FarmColors.forest : const Color(0xFFD4CEC1),
      ),
      onSelected: (_) => _controller!.setStatusFilter(key),
    );
  }
}
