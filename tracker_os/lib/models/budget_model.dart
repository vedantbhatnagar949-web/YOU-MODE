class BudgetSettings {
  double monthlyBudget;
  double dailyLimit;
  double monthlyLimit;
  String currencySymbol;

  BudgetSettings({
    this.monthlyBudget = 5000.0,
    this.dailyLimit = 150.0,
    this.monthlyLimit = 5000.0,
    this.currencySymbol = '₹',
  });

  factory BudgetSettings.fromJson(Map<String, dynamic> json) {
    return BudgetSettings(
      monthlyBudget: json['monthlyBudget'] ?? 5000.0,
      dailyLimit: json['dailyLimit'] ?? 150.0,
      monthlyLimit: json['monthlyLimit'] ?? 5000.0,
      currencySymbol: json['currencySymbol'] ?? '₹',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'monthlyBudget': monthlyBudget,
      'dailyLimit': dailyLimit,
      'monthlyLimit': monthlyLimit,
      'currencySymbol': currencySymbol,
    };
  }
}

class TransactionModel {
  final String id;
  final double amount;
  final bool isExpense; // true for expense, false for income
  final String note;
  final DateTime timestamp;
  final String? photoPath;

  TransactionModel({
    required this.id,
    required this.amount,
    required this.isExpense,
    required this.note,
    required this.timestamp,
    this.photoPath,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'],
      amount: json['amount'],
      isExpense: json['isExpense'],
      note: json['note'],
      timestamp: DateTime.parse(json['timestamp']),
      photoPath: json['photoPath'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'isExpense': isExpense,
      'note': note,
      'timestamp': timestamp.toIso8601String(),
      'photoPath': photoPath,
    };
  }
}
