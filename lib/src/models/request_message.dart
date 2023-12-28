import 'request_header.dart';

class RequestMessage {
  String id;
  String? signature;
  RequestHeader header;
  String message;

  RequestMessage({
    required this.id,
    this.signature,
    required this.header,
    required this.message,
  });

  factory RequestMessage.fromJson(Map<String, dynamic> json) {
    return RequestMessage(
      id: json['id'] ?? 'default-id', // Provide a default value if id is null
      signature: json['signature'] ?? '',
      header: RequestHeader.fromJson(json['header'] as Map<String, dynamic>),
      message:
          json['message'] ?? '', // Provide a default value if message is null
    );
  }
}
