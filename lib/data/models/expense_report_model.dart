class ExpenseReportModel {
  final int? income;
  final int? expense;
  final int? profit;
  final String? daily_date;
  final String? start_of_week;
  final String? end_of_week;
  final String? current_month;
  // final String? past_month;


  ExpenseReportModel({
    this.expense,
    this.profit,
    this.income,
    this.daily_date,
    this.current_month,
    this.start_of_week,
    this.end_of_week,
  });

  factory ExpenseReportModel.fromMap(Map<String, dynamic> map) {
    return ExpenseReportModel(
      income: map["income"] ?? 0,
      expense: map["expense"] ?? 0,
      profit: map["profit"] ?? 0,
      daily_date: map["daily_date"] ?? "",
      current_month: map["current_month"] ?? "",
      end_of_week: map["end_of_week"] ?? "",
      start_of_week: map["start_of_week"] ?? "",
    );
  }
}
