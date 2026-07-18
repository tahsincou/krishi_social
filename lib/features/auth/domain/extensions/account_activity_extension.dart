import 'package:flutter/material.dart';
import 'package:krishi_social/core/locale/locale_extension.dart';
import 'package:krishi_social/features/auth/domain/entities/account_activity.dart';

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
}
