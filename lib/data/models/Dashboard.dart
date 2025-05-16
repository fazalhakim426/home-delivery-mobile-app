class Dashboard {
  final int totalOrders;
  final String totalCompleteOrders;
  final int currentMonthTotal;
  final int currentMonthConfirm;
  final int currentDayTotal;
  final int currentDayConfirm;
  final int currentYearTotal;
  final String currentYearConfirm;
  final String monthName;
  final List<int> totalShippedCount;
  final List<int> totalOrderCount;
  final List<String> months;
  final String percentIncreaseThisMonth;
  final String percentIncreaseThisYear;
  final List<DoughnutData> doughnutData;

  Dashboard({
    required this.totalOrders,
    required this.totalCompleteOrders,
    required this.currentMonthTotal,
    required this.currentMonthConfirm,
    required this.currentDayTotal,
    required this.currentDayConfirm,
    required this.currentYearTotal,
    required this.currentYearConfirm,
    required this.monthName,
    required this.totalShippedCount,
    required this.totalOrderCount,
    required this.months,
    required this.percentIncreaseThisMonth,
    required this.percentIncreaseThisYear,
    required this.doughnutData,
  });

  factory Dashboard.fromJson(Map<String, dynamic> json) {
    return Dashboard(
      totalOrders: json['totalOrders'],
      totalCompleteOrders: json['totalCompleteOrders'],
      currentMonthTotal: json['currentMonthTotal'],
      currentMonthConfirm: json['currentMonthConfirm'],
      currentDayTotal: json['currentDayTotal'],
      currentDayConfirm: json['currentDayConfirm'],
      currentYearTotal: json['currentYearTotal'],
      currentYearConfirm: json['currentYearConfirm'],
      monthName: json['monthName'],
      totalShippedCount: List<int>.from(json['totalShippedCount']),
      totalOrderCount: List<int>.from(json['totalOrderCount']),
      months: List<String>.from(json['months']),
      percentIncreaseThisMonth: json['percentIncreaseThisMonth'],
      percentIncreaseThisYear: json['percentIncreaseThisYear'],
      doughnutData: (json['doughnutData'] as List)
          .map((e) => DoughnutData.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalOrders': totalOrders,
      'totalCompleteOrders': totalCompleteOrders,
      'currentMonthTotal': currentMonthTotal,
      'currentMonthConfirm': currentMonthConfirm,
      'currentDayTotal': currentDayTotal,
      'currentDayConfirm': currentDayConfirm,
      'currentYearTotal': currentYearTotal,
      'currentYearConfirm': currentYearConfirm,
      'monthName': monthName,
      'totalShippedCount': totalShippedCount,
      'totalOrderCount': totalOrderCount,
      'months': months,
      'percentIncreaseThisMonth': percentIncreaseThisMonth,
      'percentIncreaseThisYear': percentIncreaseThisYear,
      'doughnutData': doughnutData.map((e) => e.toJson()).toList(),
    };
  }
}

class DoughnutData {
  final String x;
  final dynamic value;

  DoughnutData({required this.x, required this.value});

  factory DoughnutData.fromJson(Map<String, dynamic> json) {
    return DoughnutData(
      x: json['x'],
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'x': x, 'value': value};
  }
}
