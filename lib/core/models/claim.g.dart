// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'claim.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ClaimReceipt _$ClaimReceiptFromJson(Map<String, dynamic> json) =>
    _ClaimReceipt(
      claimId: json['claimId'] as String,
      status: json['status'] as String? ?? '',
    );

Map<String, dynamic> _$ClaimReceiptToJson(_ClaimReceipt instance) =>
    <String, dynamic>{'claimId': instance.claimId, 'status': instance.status};
