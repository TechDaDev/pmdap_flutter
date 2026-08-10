import 'package:freezed_annotation/freezed_annotation.dart';

part 'claim.freezed.dart';
part 'claim.g.dart';

/// Receipt returned by public account-claim submission.
@freezed
abstract class ClaimReceipt with _$ClaimReceipt {
  const factory ClaimReceipt({
    required String claimId,
    @Default('') String status,
  }) = _ClaimReceipt;

  factory ClaimReceipt.fromJson(Map<String, dynamic> json) =>
      _$ClaimReceiptFromJson(json);
}
