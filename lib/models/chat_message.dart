class ChatMessage {
  final String id;  // unique id of the message
  final String content;  // content of the message
  final DateTime timestamp;  // when the message was sent or received
  final bool isSent;  // if the message is sent by us or received

  ChatMessage({required this.id, required this.content, required this.timestamp, required this.isSent});
}