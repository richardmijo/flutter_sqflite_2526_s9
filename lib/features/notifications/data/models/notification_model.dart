class NotificationModel {
  final int? id;
  final String title;
  final String body;
  final String date;

  NotificationModel({
    this.id,
    required this.title,
    required this.body,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {'id': id, 'title': title, 'body': body, 'date': date};
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['id'],
      title: map['title'],
      body: map['body'],
      date: map['date'],
    );
  }
}
