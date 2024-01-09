import 'header.dart';

class Message {
  String? signature;
  Header header;
  String message;

  Message({
    this.signature,
    required this.header,
    required this.message,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      signature: json['signature'] ?? '',
      header: Header.fromJson(json['header'] as Map<String, dynamic>),
      message:
          json['message'] ?? '', // Provide a default value if message is null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'signature': signature,
      'header': header.toJson(),
      'message': message,
    };
  }
}
