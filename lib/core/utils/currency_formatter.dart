import 'package:intl/intl.dart';

class CurrencyFormatter {
  static String formatPrice(double price) {
    // Using NumberFormat for proper currency formatting
    // You can customize the currency symbol, decimal digits etc. based on your requirements
    final formatter = NumberFormat.currency(
      symbol: '€', // Change to your currency symbol
      decimalDigits: 2,
    );

    return formatter.format(price);
  }
}
