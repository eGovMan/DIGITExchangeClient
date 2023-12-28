import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

class FiscalMessage {
  String id;
  String schemaVersion;
  String fiscalMessageType;
  String accountCode;
  String functionCode;
  String administrationCode;
  String locationCode;
  String programCode;
  String recipientSegmentCode;
  String economicSegmentCode;
  String sourceOfFundCode;
  String targetSegmentCode;
  DateTime startDate;
  DateTime endDate;
  double netAmount;
  double grossAmount;
  String currencyCode;
  String localeCode;

  FiscalMessage({
    String? id,
    this.schemaVersion = '1.0.0',
    this.fiscalMessageType = '',
    this.accountCode = '',
    this.functionCode = '',
    this.administrationCode = '',
    this.locationCode = '',
    this.programCode = '',
    this.recipientSegmentCode = '',
    this.economicSegmentCode = '',
    this.sourceOfFundCode = '',
    this.targetSegmentCode = '',
    DateTime? startDate,
    DateTime? endDate,
    double? netAmount,
    double? grossAmount,
    this.currencyCode = '',
    this.localeCode = '',
  })  : id = id ?? const Uuid().v4(),
        startDate = startDate ?? DateTime.now(),
        endDate = endDate ?? DateTime.now(),
        netAmount = netAmount ?? 0.0,
        grossAmount = grossAmount ?? 0.0;

  static DateTime? _parseDate(String? dateString) {
    if (dateString == null) return null;
    try {
      return DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").parse(dateString, true);
    } catch (e) {
      if (e is FormatException) {
        // Handle the format exception
        throw Exception('Date format is invalid: ${e.message}');
      }
      return null; // or set a default date if needed
    }
  }

  factory FiscalMessage.fromJson(Map<String, dynamic> json) => FiscalMessage(
        id: json['id'] ?? '',
        schemaVersion: json['schema_version'] ?? '',
        fiscalMessageType: json['fiscal_message_type'] ?? '',
        accountCode: json['account_code'] ?? '',
        functionCode: json['function_code'] ?? '',
        administrationCode: json['administration_code'] ?? '',
        locationCode: json['location_code'] ?? '',
        programCode: json['program_code'] ?? '',
        recipientSegmentCode: json['recipient_segment_code'] ?? '',
        economicSegmentCode: json['economic_segment_code'] ?? '',
        sourceOfFundCode: json['source_of_found_code'] ?? '',
        targetSegmentCode: json['target_segment_code'] ?? '',
        startDate: _parseDate(json['start_date']),
        endDate: _parseDate(json['end_date']),
        netAmount: double.tryParse(json['net_amount'].toString()) ?? 0.0,
        grossAmount: double.tryParse(json['gross_amount'].toString()) ?? 0.0,
        currencyCode: json['currency_code'] ?? '',
        localeCode: json['locale_code'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'schema_version': schemaVersion,
        'fiscalMessageType': fiscalMessageType,
        'account_code': accountCode,
        'functionCode': functionCode,
        'administrationCode': administrationCode,
        'locationCode': locationCode,
        'programCode': programCode,
        'recipient_segmentCode': recipientSegmentCode,
        'economic_segmentCode': economicSegmentCode,
        'source_of_foundCode': sourceOfFundCode,
        'target_segmentCode': targetSegmentCode,
        // 'start_date': DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(startDate),
        // 'end_date': DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(endDate),
        'net_amount': netAmount,
        'gross_amount': grossAmount,
        'currencyCode': currencyCode,
        'localeCode': localeCode,
      };
}
