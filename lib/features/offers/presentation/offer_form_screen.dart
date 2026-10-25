import 'package:flutter/material.dart';

import '../../../../app/app_scope.dart';
import '../../../../app/app_theme.dart';
import '../../../../app/app_translations.dart';
import '../../../../app/widgets/farm_card.dart';
import '../../../../core/storage/app_storage.dart';
import 'controllers/offer_form_controller.dart';

class OfferFormScreen extends StatefulWidget {
  const OfferFormScreen({
    super.key,
    required this.productId,
    this.storage,
  });

  final String productId;
  final AppStorage? storage;

  @override
  State<OfferFormScreen> createState() => _OfferFormScreenState();
}

class _OfferFormScreenState extends State<OfferFormScreen> {
  OfferFormController? _controller;
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _quantityController = TextEditingController();
  final _noteController = TextEditingController();

  String? _errorMessage;
  bool _isSubmitting = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_controller == null) {
      final appScope = AppScope.of(context);
      final storage = widget.storage ?? appScope.storage;

      if (_nameController.text.isEmpty) {
        _nameController.text = 'Demo User';
      }
      if (_phoneController.text.isEmpty) {
        _phoneController.text = '05550123456';
      }

      _controller = OfferFormController(
        productId: widget.productId,
        productRepository: storage.products,
        offerRepository: storage.offers,
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _quantityController.dispose();
    _noteController.dispose();
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_controller == null) return;

    setState(() {
      _errorMessage = null;
      _isSubmitting = true;
    });

    final result = await _controller!.submitOffer(
      buyerName: _nameController.text,
      buyerPhone: _phoneController.text,
      rawQuantity: _quantityController.text,
      note: _noteController.text,
    );

    if (!mounted) return;

    if (result.isSuccess) {
      final tr = AppTranslations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(tr.offerSubmittedSuccess),
          backgroundColor: FarmColors.forest,
        ),
      );
      Navigator.of(context).pop(true);
    } else {
      setState(() {
        _errorMessage = result.errorMessage;
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final tr = AppTranslations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final product = _controller!.product;

    if (product == null) {
      return Scaffold(
        appBar: AppBar(title: Text(tr.createOfferTitle)),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.remove_shopping_cart_outlined,
                    size: 54, color: FarmColors.alert),
                const SizedBox(height: 16),
                Text(
                  tr.productNotFoundTitle,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: isDark ? FarmDarkColors.ink : FarmColors.ink),
                ),
                const SizedBox(height: 8),
                Text(
                  tr.productNotFoundDesc,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: isDark ? FarmDarkColors.inkMuted : FarmColors.ink),
                ),
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(tr.backToMarketBtn),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Tahmini tutar hesaplama
    final double? enteredQty =
        double.tryParse(_quantityController.text.replaceAll(',', '.').trim());
    final double? estimatedTotal =
        enteredQty != null ? (enteredQty * product.unitPrice) : null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          tr.sendOfferTitle,
          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Ürün Özeti Kartı
              FarmCard(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: (isDark ? FarmDarkColors.forest : FarmColors.forest).withAlpha(isDark ? 40 : 25),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(Icons.inventory_2_outlined,
                          color: isDark ? FarmDarkColors.forest : FarmColors.forest, size: 28),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.title,
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                              color: isDark ? FarmDarkColors.ink : FarmColors.ink,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${tr.availableStockLabel} ${product.quantity.toStringAsFixed(1)} ${tr.translateUnit(product.unit)} · ₺${product.unitPrice.toStringAsFixed(2)}/${tr.translateUnit(product.unit)}',
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? FarmDarkColors.inkMuted : FarmColors.earth,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              if (_errorMessage != null) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark
                        ? FarmColors.alert.withAlpha(40)
                        : const Color(0xFFFFECE5),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: FarmColors.alert),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline_rounded,
                          color: FarmColors.alert, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          tr.translateValidationError(_errorMessage!),
                          style: const TextStyle(
                            color: FarmColors.alert,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
              Text(
                tr.buyerNameLabel,
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: isDark ? FarmDarkColors.ink : FarmColors.ink),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _nameController,
                onChanged: (_) {
                  if (_errorMessage != null) {
                    setState(() => _errorMessage = null);
                  }
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person_outline_rounded,
                      color: isDark ? FarmDarkColors.forest : FarmColors.forest),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                tr.buyerPhoneLabel,
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: isDark ? FarmDarkColors.ink : FarmColors.ink),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                onChanged: (_) {
                  if (_errorMessage != null) {
                    setState(() => _errorMessage = null);
                  }
                },
                decoration: InputDecoration(
                  prefixIcon:
                      Icon(Icons.phone_outlined,
                          color: isDark ? FarmDarkColors.forest : FarmColors.forest),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                '${tr.offerQtyLabel} (${tr.translateUnit(product.unit)})',
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: isDark ? FarmDarkColors.ink : FarmColors.ink),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _quantityController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                onChanged: (_) {
                  setState(() {
                    if (_errorMessage != null) _errorMessage = null;
                  });
                },
                decoration: InputDecoration(
                  hintText:
                      'max. ${product.quantity.toStringAsFixed(1)} ${tr.translateUnit(product.unit)}',
                  prefixIcon:
                      Icon(Icons.scale_rounded,
                          color: isDark ? FarmDarkColors.forest : FarmColors.forest),
                ),
              ),
              if (estimatedTotal != null && estimatedTotal > 0) ...[
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Text(
                    '${tr.estimatedTotalLabel}: ₺${estimatedTotal.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: isDark ? FarmDarkColors.gold : FarmColors.gold,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 14),
              Text(
                tr.offerNoteLabel,
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: isDark ? FarmDarkColors.ink : FarmColors.ink),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _noteController,
                maxLines: 3,
                decoration: const InputDecoration(),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _isSubmitting ? null : _submit,
                  child: _isSubmitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                      : Text(tr.submitOfferBtn),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
