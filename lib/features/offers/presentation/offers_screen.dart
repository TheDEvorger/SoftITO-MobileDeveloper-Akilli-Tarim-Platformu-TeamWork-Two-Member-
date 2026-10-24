import 'package:flutter/material.dart';

import '../../../../app/app_scope.dart';
import '../../../../app/app_theme.dart';
import '../../../../app/role_controller.dart';
import '../../../../core/storage/app_storage.dart';
import 'controllers/offers_controller.dart';
import 'widgets/offer_card.dart';

class OffersScreen extends StatefulWidget {
  const OffersScreen({
    super.key,
    this.storage,
    this.roleController,
  });

  final AppStorage? storage;
  final RoleController? roleController;

  @override
  State<OffersScreen> createState() => _OffersScreenState();
}

class _OffersScreenState extends State<OffersScreen> {
  OffersController? _controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_controller == null) {
      final appScope = AppScope.of(context);
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

  void _handleStatusChange(
      String offerId, String newStatus, String actionName) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Teklifi $actionName'),
        content: Text(
          'Bu teklif yerel olarak "$actionName" durumuna alınacaktır. Bu işlem gerçek bir ödeme veya sipariş tamamlama değildir.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Vazgeç'),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              await _controller?.updateOfferStatus(offerId, newStatus);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Teklif $actionName durumuna güncellendi.'),
                    backgroundColor: newStatus == 'accepted'
                        ? FarmColors.forest
                        : FarmColors.alert,
                  ),
                );
              }
            },
            child: const Text('Onayla'),
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

    return ListenableBuilder(
      listenable: _controller!,
      builder: (context, _) {
        final isProducer = _controller!.isProducer;
        final offers = _controller!.filteredOffers;
        final selectedFilter = _controller!.selectedStatusFilter;

        return Scaffold(
          appBar: AppBar(
            title: Text(
              isProducer ? 'Gelen Ürün Teklifleri' : 'Verilen Tekliflerim',
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
                              ? 'Üretici Modu: Bereket Ovası (demo_producer_001) ilanlarınıza alıcılardan gelen talepler.'
                              : 'Tüketici Modu: Üreticilere ilettiğiniz ürün alım talepleri.',
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
                          'Tümü (${_controller!.roleSpecificOffers.length})',
                          selectedFilter),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                          'pending',
                          'Bekleyen (${_controller!.pendingCount})',
                          selectedFilter),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                          'accepted',
                          'Kabul Edilen (${_controller!.acceptedCount})',
                          selectedFilter),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                          'rejected',
                          'Reddedilen (${_controller!.rejectedCount})',
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
                                const Text(
                                  'Kayıtlı Teklif Bulunamadı',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w800,
                                    color: FarmColors.ink,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  isProducer
                                      ? 'İlanlarınıza henüz bu filtrede bir teklif gelmedi. Pazar yeri vitrininden ilanlarınızı kontrol edebilirsiniz.'
                                      : 'Henüz bir üretici ilanına teklif vermediniz. Pazar yerinden ürün seçip teklif gönderebilirsiniz.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: FarmColors.ink.withAlpha(160),
                                    height: 1.4,
                                  ),
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
                                  offer.id, 'accepted', 'Kabul Et'),
                              onReject: () => _handleStatusChange(
                                  offer.id, 'rejected', 'Reddet'),
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
