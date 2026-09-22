import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String formatRubles(BuildContext context, double value) =>
    NumberFormat.currency(
      locale: Localizations.localeOf(context).toLanguageTag(),
      symbol: '₽',
      decimalDigits: value % 1 == 0 ? 0 : 2,
    ).format(value);

IconData impulseIcon(String key) => switch (key) {
  'coffee' => Icons.local_cafe_outlined,
  'restaurant' => Icons.restaurant_outlined,
  'delivery' => Icons.delivery_dining_outlined,
  'smoking' => Icons.smoke_free_outlined,
  'taxi' => Icons.local_taxi_outlined,
  'shopping' => Icons.shopping_bag_outlined,
  'subscription' => Icons.subscriptions_outlined,
  _ => Icons.savings_outlined,
};

const impulseIconKeys = <String>[
  'coffee',
  'restaurant',
  'delivery',
  'smoking',
  'taxi',
  'shopping',
  'subscription',
  'other',
];
