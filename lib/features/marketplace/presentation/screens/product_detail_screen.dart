import 'package:flutter/material.dart';

import 'package:akilli_tarim_platformu/app/app_scope.dart';
import 'package:akilli_tarim_platformu/app/app_theme.dart';
import 'package:akilli_tarim_platformu/app/app_translations.dart';
import 'package:akilli_tarim_platformu/app/widgets/farm_card.dart';
import '../widgets/product_detail_action_bar.dart';
import '../widgets/product_detail_hero.dart';
import '../../../../core/models/product.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key, required this.productId});

  final String productId;

  void _showStockDialog(BuildContext context, Product product) {
    final qtyController =
        TextEditingController(text: product.quantity.toStringAsFixed(0));
    final scope = AppScope.of(context);
    final tr = AppTranslations.of(context);

    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(tr.stockUpdateTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(product.title),
            const SizedBox(height: 12),
            TextField(
              controller: qtyController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: tr.newQuantityLabel(product.unit),
                suffixText: product.unit,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(tr.cancel),
          ),
          FilledButton(
            onPressed: () async {
              final newQty = double.tryParse(qtyController.text.trim());
              if (newQty != null && newQty >= 0) {
                final updated = product.copyWith(quantity: newQty);
                await scope.storage.products.put(updated);
                if (ctx.mounted) Navigator.pop(ctx);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: FarmColors.forest,
                      content: Text(
                        tr.stockUpdatedMsg(newQty, product.unit),
                      ),
                    ),
                  );
                }
              }
            },
            child: Text(tr.save),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scope = AppScope.of(context);
    final tr = AppTranslations.of(context);

    return ValueListenableBuilder<dynamic>(
      valueListenable: scope.storage.products.changes,
      builder: (context, _, __) {
        final product = scope.storage.products.find(productId);

        if (product == null) {
          return Scaffold(
            appBar: AppBar(title: Text(tr.marketProducerTitle)),
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline,
                      size: 50, color: FarmColors.alert),
                  const SizedBox(height: 12),
                  Text(tr.productNotFound),
                  const SizedBox(height: 16),
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(tr.back),
                  ),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          body: AnimatedBuilder(
            animation: scope.roleController,
            builder: (context, _) {
              final isDark = Theme.of(context).brightness == Brightness.dark;
              final isProducer = scope.roleController.isProducer;
              final isOwnProduct = product.sellerId == 'demo_producer_001';

              return Column(
                children: [
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        ProductDetailHero(
                          product: product,
                          onBack: () => Navigator.pop(context),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (isProducer && isOwnProduct) ...[
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 14, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? FarmDarkColors.surfaceElevated
                                        : const Color(0xFFEDF5EE),
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                      color: (isDark
                                              ? FarmDarkColors.forest
                                              : FarmColors.forest)
                                          .withAlpha(60),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.verified_user_rounded,
                                          color: isDark
                                              ? FarmDarkColors.forest
                                              : FarmColors.forest,
                                          size: 20),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          tr.productDetailOwnListingNotice,
                                          style: TextStyle(
                                            fontSize: 12.5,
                                            fontWeight: FontWeight.w700,
                                            color: isDark
                                                ? FarmDarkColors.forest
                                                : FarmColors.forest,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 12),
                              ],
                              Text(
                                product.title,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.w800,
                                      color: isDark
                                          ? FarmDarkColors.ink
                                          : FarmColors.ink,
                                    ),
                              ),
                              const SizedBox(height: 12),
                              FarmCard(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          tr.productDetailUnitPrice,
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: isDark
                                                  ? FarmDarkColors.inkMuted
                                                  : FarmColors.earth),
                                        ),
                                        const SizedBox(height: 4),
                                        FittedBox(
                                          fit: BoxFit.scaleDown,
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            '${product.unitPrice.toStringAsFixed(2)} ₺ / ${tr.translateUnit(product.unit)}',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w900,
                                              color: isDark
                                                  ? FarmDarkColors.forest
                                                  : FarmColors.forest,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          tr.productDetailAvailableQty,
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: isDark
                                                  ? FarmDarkColors.inkMuted
                                                  : FarmColors.earth),
                                        ),
                                        const SizedBox(height: 4),
                                        FittedBox(
                                          fit: BoxFit.scaleDown,
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            '${product.quantity.toStringAsFixed(0)} ${tr.translateUnit(product.unit)}',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w800,
                                              color: isDark
                                                  ? FarmDarkColors.gold
                                                  : FarmColors.olive,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                tr.productDetailLocationSellerTitle,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                              const SizedBox(height: 8),
                              FarmCard(
                                child: Column(
                                  children: [
                                    ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      leading: CircleAvatar(
                                        backgroundColor: isDark
                                            ? FarmDarkColors.surfaceElevated
                                            : const Color(0xFFE8EFE5),
                                        child: Icon(Icons.location_on,
                                            color: isDark
                                                ? FarmDarkColors.forest
                                                : FarmColors.forest),
                                      ),
                                      title: Text(tr.productDetailLocationTitle),
                                      subtitle: Text(
                                          '${tr.translateCity(product.city)} / ${product.district}'),
                                    ),
                                    const Divider(height: 16),
                                    ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      leading: CircleAvatar(
                                        backgroundColor: isDark
                                            ? FarmDarkColors.surfaceElevated
                                            : const Color(0xFFF7EBD3),
                                        child: Icon(Icons.badge_outlined,
                                            color: isDark
                                                ? FarmDarkColors.gold
                                                : FarmColors.gold),
                                      ),
                                      title: Text(tr.productDetailProducerCodeTitle),
                                      subtitle: Text(
                                        (isProducer && isOwnProduct)
                                            ? '${product.sellerId} (${tr.youParenthesis})'
                                            : product.sellerId,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                tr.descriptionLabel,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                              const SizedBox(height: 8),
                              FarmCard(
                                child: Text(
                                  product.description.isEmpty
                                      ? tr.productDetailNoDesc
                                      : product.description,
                                  style: const TextStyle(height: 1.5),
                                ),
                              ),
                              const SizedBox(height: 24),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  ProductDetailActionBar(
                    product: product,
                    role: scope.roleController.role,
                    onMakeOffer: () => Navigator.pushNamed(
                      context,
                      '/offer-form',
                      arguments: product.id,
                    ),
                    onViewOffers: () => Navigator.pushNamed(context, '/offers'),
                    onManageStock: () => _showStockDialog(context, product),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
