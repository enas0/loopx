class MessageModel {
  final String senderId;
  final String text;
  final DateTime createdAt;

  MessageModel({
    required this.senderId,
    required this.text,
    required this.createdAt,
  });

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      senderId: map['senderId'],
      text: map['text'],
      createdAt: map['createdAt'].toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {'senderId': senderId, 'text': text, 'createdAt': createdAt};
  }
}
