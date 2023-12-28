import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

import 'fiscal_message.dart';
import 'action.dart';

class RequestHeader {
  String id;
  String version;
  String messageId;
  DateTime messageTs;
  String senderId;
  String senderUri;
  String receiverId;
  Action action;
  int totalCount;
  bool isMsgEncrypted;
  FiscalMessage fiscalMessage;

  RequestHeader({
    String? id,
    String? version,
    String? messageId,
    DateTime? messageTs,
    String? senderId,
    String? senderUri,
    String? receiverId,
    this.totalCount = 0,
    this.action = Action.create,
    this.isMsgEncrypted = false,
    required this.fiscalMessage,
  })  : id = id ?? const Uuid().v4(),
        version = version ?? '',
        messageId = messageId ?? const Uuid().v4(),
        messageTs = messageTs ?? DateTime.now(),
        senderId = senderId ?? '',
        senderUri = senderUri ?? '',
        receiverId = receiverId ?? '';

  factory RequestHeader.fromJson(Map<String, dynamic> json) {
    // final dateTimeStr = _stripTimeZoneName(json['message_ts']);
    return RequestHeader(
      id: json['id'] ?? '',
      version: json['version'] ?? '',
      messageId: json['message_id'] ?? '',
      // messageTs: DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(dateTimeStr, true),
      senderId: json['sender_id'] ?? '',
      senderUri: json['senderUri'] ?? '',
      receiverId: json['receiver_id'] ?? '',
      totalCount: json['total_count'] ?? 0,
      action: parseAction(json['action']) ?? Action.create,
      isMsgEncrypted: json['is_msg_encrypted'] ?? 'false',
      fiscalMessage: FiscalMessage.fromJson(json['meta']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'version': version,
        'message_id': messageId,
        // 'message_ts': DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(messageTs) +
        // _formatTimeZoneOffset(messageTs),
        'sender_id': senderId,
        'senderUri': senderUri,
        'receiver_id': receiverId,
        'total_count': totalCount,
        'is_msg_encrypted': isMsgEncrypted,
        'meta': fiscalMessage.toJson(),
      };

  // static String _stripTimeZoneName(String dateTimeStr) {
  //   final timeZoneNameStart = dateTimeStr.indexOf('[');
  //   return (timeZoneNameStart != -1)
  //       ? dateTimeStr.substring(0, timeZoneNameStart)
  //       : dateTimeStr;
  // }

  // static String _formatTimeZoneOffset(DateTime dateTime) {
  //   String offset = DateFormat("Z").format(dateTime);
  //   return "${offset.substring(0, 3)}:${offset.substring(3)}";
  // }
}
