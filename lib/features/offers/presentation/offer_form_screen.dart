import 'package:flutter/material.dart';

import '../../../../app/app_scope.dart';
import '../../../../app/app_theme.dart';
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
      final storage = widget.storage ?? AppScope.of(context).storage;
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Teklifiniz başarıyla üreticiye iletildi.'),
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

    final product = _controller!.product;

    if (product == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Teklif Oluştur')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.remove_shopping_cart_outlined,
                    size: 54, color: FarmColors.alert),
                const SizedBox(height: 16),
                const Text(
                  'Ürün Bulunamadı',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: FarmColors.ink),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Teklif vermek istediğiniz ürün satıştan kaldırılmış veya sistemde kayıtlı değil.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: FarmColors.ink),
                ),
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Pazara Geri Dön'),
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
        title: const Text(
          'Alım Teklifi Gönder',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
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
                        color: FarmColors.forest.withAlpha(25),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(Icons.inventory_2_outlined,
                          color: FarmColors.forest, size: 28),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.title,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                              color: FarmColors.ink,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Mevcut Stok: ${product.quantity.toStringAsFixed(1)} ${product.unit} · ₺${product.unitPrice.toStringAsFixed(2)}/${product.unit}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: FarmColors.earth,
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
                    color: const Color(0xFFFFECE5),
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
                          _errorMessage!,
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
              const Text(
                'Adınız / Ticari Unvanınız *',
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: FarmColors.ink),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  hintText: 'Örn: Anadolu Gurme Gıda Ltd.',
                  prefixIcon: Icon(Icons.person_outline_rounded,
                      color: FarmColors.forest),
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'İletişim Telefonu',
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: FarmColors.ink),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  hintText: 'Örn: 0532 000 00 00',
                  prefixIcon:
                      Icon(Icons.phone_outlined, color: FarmColors.forest),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'Talep Edilen Miktar (${product.unit}) *',
                style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: FarmColors.ink),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _quantityController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText:
                      'En fazla ${product.quantity.toStringAsFixed(1)} ${product.unit}',
                  prefixIcon:
                      const Icon(Icons.scale_rounded, color: FarmColors.forest),
                ),
              ),
              if (estimatedTotal != null && estimatedTotal > 0) ...[
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Text(
                    'Tahmini Toplam Bedel: ₺${estimatedTotal.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: FarmColors.gold,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 14),
              const Text(
                'Teklif / Talep Notu',
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: FarmColors.ink),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _noteController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText:
                      'Örn: Nakliye bize aittir, ürünleri haftaya cuma günü teslim alabiliriz.',
                ),
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
                      : const Text('Teklifi Üreticiye İlet'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
