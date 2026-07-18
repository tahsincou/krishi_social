import 'package:flutter/material.dart';
import 'package:krishi_social/core/locale/locale_extension.dart';
import 'package:krishi_social/features/feed/domain/entities/post_type.dart';
import 'package:krishi_social/features/feed/domain/entities/product_category.dart';
import 'package:krishi_social/features/feed/domain/entities/quantity_unit.dart';

extension PostTypeExtension on PostType {
  String get displayName {
    switch (this) {
      case PostType.buy:
        return 'Buy';
      case PostType.sell:
        return 'Sell';
    }
  }
}

extension ProductCategoryExtension on ProductCategory {
  String displayName(BuildContext context) {
    switch (this) {
      case ProductCategory.vegetables:
        return context.l10n.vegetables;
      case ProductCategory.fruits:
        return context.l10n.fruits;
      case ProductCategory.crops:
        return context.l10n.crops;
      case ProductCategory.poultry:
        return context.l10n.poultry;
      case ProductCategory.eggs:
        return context.l10n.eggs;
      case ProductCategory.dairy:
        return context.l10n.dairy;
      case ProductCategory.fish:
        return context.l10n.fish;
      case ProductCategory.livestock:
        return context.l10n.livestock;
      case ProductCategory.honey:
        return context.l10n.honey;
      case ProductCategory.nursery:
        return context.l10n.nursery;
      case ProductCategory.other:
        return context.l10n.other;
    }
  }

  List<String> get suggestedProducts {
    switch (this) {
      case ProductCategory.vegetables:
        return [
          'Potato',
          'Tomato',
          'Onion',
          'Brinjal',
          'Cucumber',
          'Cauliflower',
          'Cabbage',
          'Chilli',
        ];

      case ProductCategory.fruits:
        return ['Mango', 'Banana', 'Guava', 'Litchi', 'Jackfruit', 'Pineapple'];

      case ProductCategory.crops:
        return ['Rice', 'Paddy', 'Wheat', 'Maize', 'Mustard', 'Jute', 'Lentil'];

      case ProductCategory.poultry:
        return ['Broiler Chicken', 'Sonali Chicken', 'Layer Chicken', 'Duck'];

      case ProductCategory.eggs:
        return ['Chicken Eggs', 'Duck Eggs', 'Quail Eggs'];

      case ProductCategory.dairy:
        return ['Raw Milk', 'Cow Milk', 'Goat Milk'];

      case ProductCategory.fish:
        return ['Rui', 'Catla', 'Tilapia', 'Pangas', 'Shrimp', 'Koi'];

      case ProductCategory.livestock:
        return ['Cow', 'Goat', 'Sheep', 'Buffalo'];

      case ProductCategory.honey:
        return ['Mustard Honey', 'Litchi Honey', 'Sundarban Honey'];

      case ProductCategory.nursery:
        return ['Fruit Plants', 'Flower Plants', 'Vegetable Seedlings'];

      case ProductCategory.other:
        return [];
    }
  }
}

extension QuantityUnitExtension on QuantityUnit {
  String get displayName {
    switch (this) {
      case QuantityUnit.kg:
        return 'kg';
      case QuantityUnit.ton:
        return 'ton';
      case QuantityUnit.piece:
        return 'piece';
      case QuantityUnit.liter:
        return 'liter';
      case QuantityUnit.crate:
        return 'crate';
      case QuantityUnit.bird:
        return 'bird';
    }
  }
}
