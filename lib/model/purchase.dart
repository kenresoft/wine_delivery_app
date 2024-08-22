import 'product.dart';

class Purchase {
  final String purchaseId;
  final Product wine;
  final int quantity;
  final DateTime purchaseDate;

  Purchase({
    required this.purchaseId,
    required this.wine,
    required this.quantity,
    required this.purchaseDate,
  });

  factory Purchase.empty() => Purchase(
    purchaseId: '',
    wine: Product.empty(), // Assuming Wine class has an empty factory constructor
    quantity: 0,
    purchaseDate: DateTime.now(),
  );
}

// Extension to compare DateTime objects by date only
extension DateTimeComparison on DateTime {
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}
