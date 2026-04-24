import 'package:ecommerce_app/features/product_details/domain/entities/product_details_entity.dart';
import 'package:flutter/material.dart';

class ProductDetailsModel extends ProductDetailsEntity {
  const ProductDetailsModel({
    required super.id,
    required super.name,
    super.description,
    required super.image,
    required super.price,
    super.oldPrice,
    super.hasFreeShipping,
    super.rating,
    super.reviewCount,
    required super.images,
    required super.colors,
    super.sku,
    super.stockQty,
    super.specs,
    super.weight,
    super.weightUnit,
    super.length,
    super.width,
    super.height,
    super.dimensionUnit,
  });

  factory ProductDetailsModel.fromJson(Map<String, dynamic> json) {
    final double originalPrice = (json['price'] as num?)?.toDouble() ?? 0.0;
    final double? salePrice = (json['sale_price'] as num?)?.toDouble();

    // Map images from product_images join
    final List<dynamic> imagesJson =
        json['product_images'] as List<dynamic>? ?? [];
    List<String> images = imagesJson
        .map((img) => img['image_url'] as String)
        .toList();
    if (images.isEmpty && json['main_image_url'] != null) {
      images = [json['main_image_url'] as String];
    }

    // Map colors from product_color_stocks join
    final List<dynamic> colorsJson =
        json['product_color_stocks'] as List<dynamic>? ?? [];
    final List<ProductColorEntity> colors = colorsJson.map((c) {
      final String hex = (c['color_hex'] as String? ?? '0xFF000000').replaceAll(
        '#',
        '0xFF',
      );
      return ProductColorEntity(
        name: c['color_name'] as String,
        color: Color(int.parse(hex)),
        quantity: c['quantity'] as int? ?? 0,
        image: c['image_url'] as String?,
      );
    }).toList();

    return ProductDetailsModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      image: json['main_image_url'] as String? ?? '',
      price: salePrice ?? originalPrice,
      oldPrice: salePrice != null ? originalPrice : null,
      hasFreeShipping: json['unlimited_stock'] as bool? ?? false,
      rating: (json['rating'] as num?)?.toDouble(),
      reviewCount: (json['review_count'] as num?)?.toInt(),
      images: images,
      colors: colors,
      sku: json['sku'] as String?,
      stockQty: json['stock_qty'] as int?,
      specs: json['specs'] as Map<String, dynamic>?,
      weight: (json['weight_kg'] as num?)?.toDouble(),
      weightUnit: json['weight_unit'] as String?,
      length: (json['length_cm'] as num?)?.toDouble(),
      width: (json['width_cm'] as num?)?.toDouble(),
      height: (json['height_cm'] as num?)?.toDouble(),
      dimensionUnit: json['dimension_unit'] as String?,
    );
  }
}
