class UserProfileModel {
  final String name;
  final String classGrade;
  final String age;
  final String height;
  final String weight;
  final double budgetMilestone;

  UserProfileModel({
    required this.name,
    required this.classGrade,
    required this.age,
    required this.height,
    required this.weight,
    required this.budgetMilestone,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      name: json['name'] ?? '',
      classGrade: json['classGrade'] ?? '',
      age: json['age'] ?? '',
      height: json['height'] ?? '',
      weight: json['weight'] ?? '',
      budgetMilestone: (json['budgetMilestone'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'classGrade': classGrade,
      'age': age,
      'height': height,
      'weight': weight,
      'budgetMilestone': budgetMilestone,
    };
  }
}
