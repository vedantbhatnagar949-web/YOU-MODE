class TaskModel {
  final String id;
  final String title;
  final String time;
  final String difficulty;
  final String category;
  final bool isDaily;
  bool isCompleted;
  String? completionNote;

  TaskModel({
    required this.id,
    required this.title,
    required this.time,
    required this.difficulty,
    required this.category,
    this.isDaily = false,
    this.isCompleted = false,
    this.completionNote,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      title: json['title'],
      time: json['time'],
      difficulty: json['difficulty'],
      category: json['category'],
      isDaily: json['isDaily'] ?? false,
      isCompleted: json['isCompleted'] ?? false,
      completionNote: json['completionNote'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'time': time,
      'difficulty': difficulty,
      'category': category,
      'isDaily': isDaily,
      'isCompleted': isCompleted,
      'completionNote': completionNote,
    };
  }
}
