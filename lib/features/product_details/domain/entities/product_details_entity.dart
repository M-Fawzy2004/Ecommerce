import 'package:ecommerce_app/features/home/domain/entities/product_entity.dart';
import 'package:flutter/material.dart';

class ProductDetailsEntity extends ProductEntity {
  final List<String> images;
  final List<ProductColorEntity> colors;
  final String? sku;
  final int? stockQty;
  final Map<String, dynamic>? specs;
  final double? weight;
  final String? weightUnit;
  final double? length;
  final double? width;
  final double? height;
  final String? dimensionUnit;

  const ProductDetailsEntity({
    required super.id,
    required super.name,
    super.description,
    required super.image,
    required super.price,
    super.oldPrice,
    super.hasFreeShipping,
    super.rating,
    super.reviewCount,
    required this.images,
    required this.colors,
    this.sku,
    this.stockQty,
    this.specs,
    this.weight,
    this.weightUnit,
    this.length,
    this.width,
    this.height,
    this.dimensionUnit,
  });

  @override
  List<Object?> get props => [
        ...super.props,
        images,
        colors,
        sku,
        stockQty,
        specs,
        weight,
        weightUnit,
        length,
        width,
        height,
        dimensionUnit,
      ];
}

class ProductColorEntity {
  final String name;
  final Color color;
  final String? image;
  final int quantity;

  const ProductColorEntity({
    required this.name,
    required this.color,
    this.image,
    required this.quantity,
  });
}
