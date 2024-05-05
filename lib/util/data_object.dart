class DataObject {
  final String monthYear;
  final double unitPrice;

  DataObject({required this.monthYear, required this.unitPrice});

  factory DataObject.fromJson(Map<String, dynamic> json) {
    return DataObject(
      monthYear: json['month_year'],
      unitPrice: json['unit_price'],
    );
  }
}