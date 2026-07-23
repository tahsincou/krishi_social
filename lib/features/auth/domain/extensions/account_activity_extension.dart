import 'package:flutter/material.dart';
import 'package:krishi_social/core/locale/locale_extension.dart';
import 'package:krishi_social/features/auth/domain/entities/account_activity.dart';
import 'package:krishi_social/features/feed/domain/entities/post_type.dart';

extension AccountActivityExtension on AccountActivity {
  String displayName(BuildContext context) {
    switch (this) {
      case AccountActivity.buy:
        return context.l10n.wantToBuy;

      case AccountActivity.sell:
        return context.l10n.wantToSell;

      case AccountActivity.both:
        return context.l10n.wantToBuyAndSell;
    }
  }

  bool get canBuy {
    return this == AccountActivity.buy || this == AccountActivity.both;
  }

  bool get canSell {
    return this == AccountActivity.sell || this == AccountActivity.both;
  }

  bool get canChoosePostType {
    return this == AccountActivity.both;
  }

  PostType get defaultCreatePostType {
    switch (this) {
      case AccountActivity.buy:
        return PostType.buy;

      case AccountActivity.sell:
        return PostType.sell;

      case AccountActivity.both:
        return PostType.buy;
    }
  }

  List<PostType> get allowedCreatePostTypes {
    switch (this) {
      case AccountActivity.buy:
        return const [PostType.buy];

      case AccountActivity.sell:
        return const [PostType.sell];

      case AccountActivity.both:
        return PostType.values;
    }
  }
}
