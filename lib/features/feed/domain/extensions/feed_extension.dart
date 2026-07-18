import 'package:krishi_social/features/feed/domain/entities/post_type.dart';
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
