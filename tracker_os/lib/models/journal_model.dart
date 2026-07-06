class JournalEntryModel {
  final String id;
  final String text;
  final List<String> photoPaths;
  final DateTime timestamp;

  JournalEntryModel({
    required this.id,
    required this.text,
    this.photoPaths = const [],
    required this.timestamp,
  });

  factory JournalEntryModel.fromJson(Map<String, dynamic> json) {
    List<String> paths = [];
    if (json['photoPaths'] != null) {
      paths = List<String>.from(json['photoPaths']);
    } else if (json['photoPath'] != null) {
      paths = [json['photoPath']];
    }

    return JournalEntryModel(
      id: json['id'],
      text: json['text'],
      photoPaths: paths,
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'photoPaths': photoPaths,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
