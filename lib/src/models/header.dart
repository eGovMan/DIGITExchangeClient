import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class Header {
  String id;
  String version;
  String messageId;
  DateTime messageTs;
  String senderId;
  String senderUri;
  String receiverId;
  String messageType;
  int totalCount;
  bool isMsgEncrypted;
  // ExchangeMessage exchangeMessage;

  Header({
    String? id,
    String? version,
    String? messageId,
    DateTime? messageTs,
    String? senderId,
    String? senderUri,
    String? receiverId,
    this.totalCount = 0,
    String? messageType,
    this.isMsgEncrypted = false,
    // required this.exchangeMessage,
  })  : id = id ?? const Uuid().v4(),
        version = version ?? '',
        messageId = messageId ?? const Uuid().v4(),
        messageTs = messageTs ?? DateTime.now(),
        messageType = messageType ?? '',
        senderId = senderId ?? '',
        senderUri = senderUri ?? '',
        receiverId = receiverId ?? '';

  factory Header.fromJson(Map<String, dynamic> json) {
    final dateTimeStr = _stripTimeZoneName(json['message_ts']);
    return Header(
      id: json['id'] ?? '',
      version: json['version'] ?? '',
      messageId: json['message_id'] ?? '',
      messageTs: parseDateTime(dateTimeStr),
      messageType: json['message_type'] ?? '',
      senderId: json['sender_id'] ?? '',
      senderUri: json['senderUri'] ?? '',
      receiverId: json['receiver_id'] ?? '',
      totalCount: json['total_count'] ?? 0,
      isMsgEncrypted: json['is_msg_encrypted'] ?? 'false',
      // exchangeMessage: ExchangeMessage.fromJson(json['meta']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'version': version,
        'message_id': messageId,
        // 'message_ts': DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(messageTs) +
        // _formatTimeZoneOffset(messageTs),
        'message_type': messageType,
        'sender_id': senderId,
        'senderUri': senderUri,
        'receiver_id': receiverId,
        'total_count': totalCount,
        'is_msg_encrypted': isMsgEncrypted,
        // 'meta': exchangeMessage.toJson(),
      };

  static DateTime parseDateTime(String dateTimeString) {
    // Find the position of '+' or '-' to identify the start of the timezone offset
    int timezonePosition = dateTimeString.contains('+')
        ? dateTimeString.indexOf('+')
        : dateTimeString.indexOf('-');

    // Parse the date and time, ignoring the timezone offset
    DateTime parsedDateTime =
        DateTime.parse(dateTimeString.substring(0, timezonePosition));

    // Extract the timezone offset
    String offset = dateTimeString.substring(timezonePosition);
    int hoursOffset = int.parse(offset.substring(0, 3));
    int minutesOffset = int.parse(offset[0] + offset.substring(4));

    // // Adjust the DateTime object by the extracted offset
    // parsedDateTime = parsedDateTime
    //     .subtract(Duration(hours: hoursOffset, minutes: minutesOffset));

    var utcTime = parsedDateTime.toUtc();

    return parsedDateTime;
  }

  static String _stripTimeZoneName(String dateTimeStr) {
    final timeZoneNameStart = dateTimeStr.indexOf('[');
    return (timeZoneNameStart != -1)
        ? dateTimeStr.substring(0, timeZoneNameStart)
        : dateTimeStr;
  }

  static String _formatTimeZoneOffset(DateTime dateTime) {
    String offset = DateFormat("Z").format(dateTime);
    return "${offset.substring(0, 3)}:${offset.substring(3)}";
  }
}
