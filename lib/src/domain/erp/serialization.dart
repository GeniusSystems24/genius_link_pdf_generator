
import 'models.dart';

/// T46 — boundary-only serialization.
///
/// Domain models deliberately do not implement toJson/fromJson themselves.
class ErpDomainSerialization {
  const ErpDomainSerialization._();

  static Map<String, Object?> documentIdentityToMap(
    ErpDocumentIdentity value,
  ) =>
      {
        'kind': value.kind.name,
        'number': value.number,
        'issueDate': value.issueDate.toIso8601String(),
        'status': value.status.name,
        if (value.id != null) 'id': value.id,
        if (value.uuid != null) 'uuid': value.uuid,
        if (value.series != null) 'series': value.series,
        if (value.externalId != null) 'externalId': value.externalId,
      };

  static ErpDocumentIdentity documentIdentityFromMap(
    Map<String, Object?> map,
  ) =>
      ErpDocumentIdentity(
        kind: ErpDocumentKind.values.firstWhere(
          (v) => v.name == map['kind'],
        ),
        number: map['number']! as String,
        issueDate: DateTime.parse(map['issueDate']! as String),
        status: ErpDocumentStatus.values.firstWhere(
          (v) => v.name == map['status'],
        ),
        id: map['id'] as String?,
        uuid: map['uuid'] as String?,
        series: map['series'] as String?,
        externalId: map['externalId'] as String?,
      );

  static Map<String, Object?> referenceToMap(
    ErpDocumentReference value,
  ) =>
      {
        'type': value.type,
        'number': value.number,
        if (value.date != null) 'date': value.date!.toIso8601String(),
        if (value.id != null) 'id': value.id,
        if (value.externalId != null) 'externalId': value.externalId,
      };

  static ErpDocumentReference referenceFromMap(
    Map<String, Object?> map,
  ) =>
      ErpDocumentReference(
        type: map['type']! as String,
        number: map['number']! as String,
        date: map['date'] == null
            ? null
            : DateTime.parse(map['date']! as String),
        id: map['id'] as String?,
        externalId: map['externalId'] as String?,
      );

  static Map<String, Object?> printMetadataToMap(
    ErpPrintMetadata value,
  ) =>
      {
        if (value.printedAt != null)
          'printedAt': value.printedAt!.toIso8601String(),
        if (value.printedBy != null) 'printedBy': value.printedBy,
        if (value.locale != null) 'locale': value.locale,
        if (value.copyLabel != null) 'copyLabel': value.copyLabel,
        if (value.copyNumber != null) 'copyNumber': value.copyNumber,
        if (value.profile != null) 'profile': value.profile,
        if (value.generatedBy != null) 'generatedBy': value.generatedBy,
      };

  static ErpPrintMetadata printMetadataFromMap(
    Map<String, Object?> map,
  ) =>
      ErpPrintMetadata(
        printedAt: map['printedAt'] == null
            ? null
            : DateTime.parse(map['printedAt']! as String),
        printedBy: map['printedBy'] as String?,
        locale: map['locale'] as String?,
        copyLabel: map['copyLabel'] as String?,
        copyNumber: map['copyNumber'] as int?,
        profile: map['profile'] as String?,
        generatedBy: map['generatedBy'] as String?,
      );
}
