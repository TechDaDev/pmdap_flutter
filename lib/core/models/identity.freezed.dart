// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'identity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$IdentityDocumentSummary {

 String get uuid;@JsonKey(fromJson: identityDocumentTypeFromJson) IdentityDocumentType get documentType; String get issuingCountry; DateTime? get issueDate; DateTime? get expiryDate;@JsonKey(fromJson: verificationStatusFromJson) VerificationStatus get verificationStatus;@JsonKey(fromJson: identityLifecycleFromJson) IdentityDocumentLifecycleStatus get status; DateTime? get createdAt; DateTime? get updatedAt;
/// Create a copy of IdentityDocumentSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IdentityDocumentSummaryCopyWith<IdentityDocumentSummary> get copyWith => _$IdentityDocumentSummaryCopyWithImpl<IdentityDocumentSummary>(this as IdentityDocumentSummary, _$identity);

  /// Serializes this IdentityDocumentSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is IdentityDocumentSummary&&(identical(other.uuid, uuid) || other.uuid == uuid)&&(identical(other.documentType, documentType) || other.documentType == documentType)&&(identical(other.issuingCountry, issuingCountry) || other.issuingCountry == issuingCountry)&&(identical(other.issueDate, issueDate) || other.issueDate == issueDate)&&(identical(other.expiryDate, expiryDate) || other.expiryDate == expiryDate)&&(identical(other.verificationStatus, verificationStatus) || other.verificationStatus == verificationStatus)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uuid,documentType,issuingCountry,issueDate,expiryDate,verificationStatus,status,createdAt,updatedAt);

@override
String toString() {
  return 'IdentityDocumentSummary(uuid: $uuid, documentType: $documentType, issuingCountry: $issuingCountry, issueDate: $issueDate, expiryDate: $expiryDate, verificationStatus: $verificationStatus, status: $status, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $IdentityDocumentSummaryCopyWith<$Res>  {
  factory $IdentityDocumentSummaryCopyWith(IdentityDocumentSummary value, $Res Function(IdentityDocumentSummary) _then) = _$IdentityDocumentSummaryCopyWithImpl;
@useResult
$Res call({
 String uuid,@JsonKey(fromJson: identityDocumentTypeFromJson) IdentityDocumentType documentType, String issuingCountry, DateTime? issueDate, DateTime? expiryDate,@JsonKey(fromJson: verificationStatusFromJson) VerificationStatus verificationStatus,@JsonKey(fromJson: identityLifecycleFromJson) IdentityDocumentLifecycleStatus status, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class _$IdentityDocumentSummaryCopyWithImpl<$Res>
    implements $IdentityDocumentSummaryCopyWith<$Res> {
  _$IdentityDocumentSummaryCopyWithImpl(this._self, this._then);

  final IdentityDocumentSummary _self;
  final $Res Function(IdentityDocumentSummary) _then;

/// Create a copy of IdentityDocumentSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? uuid = null,Object? documentType = null,Object? issuingCountry = null,Object? issueDate = freezed,Object? expiryDate = freezed,Object? verificationStatus = null,Object? status = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
uuid: null == uuid ? _self.uuid : uuid // ignore: cast_nullable_to_non_nullable
as String,documentType: null == documentType ? _self.documentType : documentType // ignore: cast_nullable_to_non_nullable
as IdentityDocumentType,issuingCountry: null == issuingCountry ? _self.issuingCountry : issuingCountry // ignore: cast_nullable_to_non_nullable
as String,issueDate: freezed == issueDate ? _self.issueDate : issueDate // ignore: cast_nullable_to_non_nullable
as DateTime?,expiryDate: freezed == expiryDate ? _self.expiryDate : expiryDate // ignore: cast_nullable_to_non_nullable
as DateTime?,verificationStatus: null == verificationStatus ? _self.verificationStatus : verificationStatus // ignore: cast_nullable_to_non_nullable
as VerificationStatus,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as IdentityDocumentLifecycleStatus,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [IdentityDocumentSummary].
extension IdentityDocumentSummaryPatterns on IdentityDocumentSummary {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _IdentityDocumentSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _IdentityDocumentSummary() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _IdentityDocumentSummary value)  $default,){
final _that = this;
switch (_that) {
case _IdentityDocumentSummary():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _IdentityDocumentSummary value)?  $default,){
final _that = this;
switch (_that) {
case _IdentityDocumentSummary() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String uuid, @JsonKey(fromJson: identityDocumentTypeFromJson)  IdentityDocumentType documentType,  String issuingCountry,  DateTime? issueDate,  DateTime? expiryDate, @JsonKey(fromJson: verificationStatusFromJson)  VerificationStatus verificationStatus, @JsonKey(fromJson: identityLifecycleFromJson)  IdentityDocumentLifecycleStatus status,  DateTime? createdAt,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _IdentityDocumentSummary() when $default != null:
return $default(_that.uuid,_that.documentType,_that.issuingCountry,_that.issueDate,_that.expiryDate,_that.verificationStatus,_that.status,_that.createdAt,_that.updatedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String uuid, @JsonKey(fromJson: identityDocumentTypeFromJson)  IdentityDocumentType documentType,  String issuingCountry,  DateTime? issueDate,  DateTime? expiryDate, @JsonKey(fromJson: verificationStatusFromJson)  VerificationStatus verificationStatus, @JsonKey(fromJson: identityLifecycleFromJson)  IdentityDocumentLifecycleStatus status,  DateTime? createdAt,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _IdentityDocumentSummary():
return $default(_that.uuid,_that.documentType,_that.issuingCountry,_that.issueDate,_that.expiryDate,_that.verificationStatus,_that.status,_that.createdAt,_that.updatedAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String uuid, @JsonKey(fromJson: identityDocumentTypeFromJson)  IdentityDocumentType documentType,  String issuingCountry,  DateTime? issueDate,  DateTime? expiryDate, @JsonKey(fromJson: verificationStatusFromJson)  VerificationStatus verificationStatus, @JsonKey(fromJson: identityLifecycleFromJson)  IdentityDocumentLifecycleStatus status,  DateTime? createdAt,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _IdentityDocumentSummary() when $default != null:
return $default(_that.uuid,_that.documentType,_that.issuingCountry,_that.issueDate,_that.expiryDate,_that.verificationStatus,_that.status,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _IdentityDocumentSummary implements IdentityDocumentSummary {
  const _IdentityDocumentSummary({required this.uuid, @JsonKey(fromJson: identityDocumentTypeFromJson) this.documentType = IdentityDocumentType.unknown, this.issuingCountry = '', this.issueDate, this.expiryDate, @JsonKey(fromJson: verificationStatusFromJson) this.verificationStatus = VerificationStatus.unknown, @JsonKey(fromJson: identityLifecycleFromJson) this.status = IdentityDocumentLifecycleStatus.unknown, this.createdAt, this.updatedAt});
  factory _IdentityDocumentSummary.fromJson(Map<String, dynamic> json) => _$IdentityDocumentSummaryFromJson(json);

@override final  String uuid;
@override@JsonKey(fromJson: identityDocumentTypeFromJson) final  IdentityDocumentType documentType;
@override@JsonKey() final  String issuingCountry;
@override final  DateTime? issueDate;
@override final  DateTime? expiryDate;
@override@JsonKey(fromJson: verificationStatusFromJson) final  VerificationStatus verificationStatus;
@override@JsonKey(fromJson: identityLifecycleFromJson) final  IdentityDocumentLifecycleStatus status;
@override final  DateTime? createdAt;
@override final  DateTime? updatedAt;

/// Create a copy of IdentityDocumentSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$IdentityDocumentSummaryCopyWith<_IdentityDocumentSummary> get copyWith => __$IdentityDocumentSummaryCopyWithImpl<_IdentityDocumentSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$IdentityDocumentSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _IdentityDocumentSummary&&(identical(other.uuid, uuid) || other.uuid == uuid)&&(identical(other.documentType, documentType) || other.documentType == documentType)&&(identical(other.issuingCountry, issuingCountry) || other.issuingCountry == issuingCountry)&&(identical(other.issueDate, issueDate) || other.issueDate == issueDate)&&(identical(other.expiryDate, expiryDate) || other.expiryDate == expiryDate)&&(identical(other.verificationStatus, verificationStatus) || other.verificationStatus == verificationStatus)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uuid,documentType,issuingCountry,issueDate,expiryDate,verificationStatus,status,createdAt,updatedAt);

@override
String toString() {
  return 'IdentityDocumentSummary(uuid: $uuid, documentType: $documentType, issuingCountry: $issuingCountry, issueDate: $issueDate, expiryDate: $expiryDate, verificationStatus: $verificationStatus, status: $status, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$IdentityDocumentSummaryCopyWith<$Res> implements $IdentityDocumentSummaryCopyWith<$Res> {
  factory _$IdentityDocumentSummaryCopyWith(_IdentityDocumentSummary value, $Res Function(_IdentityDocumentSummary) _then) = __$IdentityDocumentSummaryCopyWithImpl;
@override @useResult
$Res call({
 String uuid,@JsonKey(fromJson: identityDocumentTypeFromJson) IdentityDocumentType documentType, String issuingCountry, DateTime? issueDate, DateTime? expiryDate,@JsonKey(fromJson: verificationStatusFromJson) VerificationStatus verificationStatus,@JsonKey(fromJson: identityLifecycleFromJson) IdentityDocumentLifecycleStatus status, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class __$IdentityDocumentSummaryCopyWithImpl<$Res>
    implements _$IdentityDocumentSummaryCopyWith<$Res> {
  __$IdentityDocumentSummaryCopyWithImpl(this._self, this._then);

  final _IdentityDocumentSummary _self;
  final $Res Function(_IdentityDocumentSummary) _then;

/// Create a copy of IdentityDocumentSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? uuid = null,Object? documentType = null,Object? issuingCountry = null,Object? issueDate = freezed,Object? expiryDate = freezed,Object? verificationStatus = null,Object? status = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_IdentityDocumentSummary(
uuid: null == uuid ? _self.uuid : uuid // ignore: cast_nullable_to_non_nullable
as String,documentType: null == documentType ? _self.documentType : documentType // ignore: cast_nullable_to_non_nullable
as IdentityDocumentType,issuingCountry: null == issuingCountry ? _self.issuingCountry : issuingCountry // ignore: cast_nullable_to_non_nullable
as String,issueDate: freezed == issueDate ? _self.issueDate : issueDate // ignore: cast_nullable_to_non_nullable
as DateTime?,expiryDate: freezed == expiryDate ? _self.expiryDate : expiryDate // ignore: cast_nullable_to_non_nullable
as DateTime?,verificationStatus: null == verificationStatus ? _self.verificationStatus : verificationStatus // ignore: cast_nullable_to_non_nullable
as VerificationStatus,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as IdentityDocumentLifecycleStatus,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$IdentityDocumentDetail {

 String get uuid;@JsonKey(fromJson: identityDocumentTypeFromJson) IdentityDocumentType get documentType; String get issuingCountry; DateTime? get issueDate; DateTime? get expiryDate;@JsonKey(fromJson: verificationStatusFromJson) VerificationStatus get verificationStatus;@JsonKey(fromJson: identityLifecycleFromJson) IdentityDocumentLifecycleStatus get status; DateTime? get createdAt; DateTime? get updatedAt; String get documentNumber; String get nationalNumber; String get familyNumber; DateTime? get verifiedAt; String get rejectionReason; List<String> get availableImages; String? get replaces;
/// Create a copy of IdentityDocumentDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IdentityDocumentDetailCopyWith<IdentityDocumentDetail> get copyWith => _$IdentityDocumentDetailCopyWithImpl<IdentityDocumentDetail>(this as IdentityDocumentDetail, _$identity);

  /// Serializes this IdentityDocumentDetail to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is IdentityDocumentDetail&&(identical(other.uuid, uuid) || other.uuid == uuid)&&(identical(other.documentType, documentType) || other.documentType == documentType)&&(identical(other.issuingCountry, issuingCountry) || other.issuingCountry == issuingCountry)&&(identical(other.issueDate, issueDate) || other.issueDate == issueDate)&&(identical(other.expiryDate, expiryDate) || other.expiryDate == expiryDate)&&(identical(other.verificationStatus, verificationStatus) || other.verificationStatus == verificationStatus)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.documentNumber, documentNumber) || other.documentNumber == documentNumber)&&(identical(other.nationalNumber, nationalNumber) || other.nationalNumber == nationalNumber)&&(identical(other.familyNumber, familyNumber) || other.familyNumber == familyNumber)&&(identical(other.verifiedAt, verifiedAt) || other.verifiedAt == verifiedAt)&&(identical(other.rejectionReason, rejectionReason) || other.rejectionReason == rejectionReason)&&const DeepCollectionEquality().equals(other.availableImages, availableImages)&&(identical(other.replaces, replaces) || other.replaces == replaces));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uuid,documentType,issuingCountry,issueDate,expiryDate,verificationStatus,status,createdAt,updatedAt,documentNumber,nationalNumber,familyNumber,verifiedAt,rejectionReason,const DeepCollectionEquality().hash(availableImages),replaces);

@override
String toString() {
  return 'IdentityDocumentDetail(uuid: $uuid, documentType: $documentType, issuingCountry: $issuingCountry, issueDate: $issueDate, expiryDate: $expiryDate, verificationStatus: $verificationStatus, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, documentNumber: $documentNumber, nationalNumber: $nationalNumber, familyNumber: $familyNumber, verifiedAt: $verifiedAt, rejectionReason: $rejectionReason, availableImages: $availableImages, replaces: $replaces)';
}


}

/// @nodoc
abstract mixin class $IdentityDocumentDetailCopyWith<$Res>  {
  factory $IdentityDocumentDetailCopyWith(IdentityDocumentDetail value, $Res Function(IdentityDocumentDetail) _then) = _$IdentityDocumentDetailCopyWithImpl;
@useResult
$Res call({
 String uuid,@JsonKey(fromJson: identityDocumentTypeFromJson) IdentityDocumentType documentType, String issuingCountry, DateTime? issueDate, DateTime? expiryDate,@JsonKey(fromJson: verificationStatusFromJson) VerificationStatus verificationStatus,@JsonKey(fromJson: identityLifecycleFromJson) IdentityDocumentLifecycleStatus status, DateTime? createdAt, DateTime? updatedAt, String documentNumber, String nationalNumber, String familyNumber, DateTime? verifiedAt, String rejectionReason, List<String> availableImages, String? replaces
});




}
/// @nodoc
class _$IdentityDocumentDetailCopyWithImpl<$Res>
    implements $IdentityDocumentDetailCopyWith<$Res> {
  _$IdentityDocumentDetailCopyWithImpl(this._self, this._then);

  final IdentityDocumentDetail _self;
  final $Res Function(IdentityDocumentDetail) _then;

/// Create a copy of IdentityDocumentDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? uuid = null,Object? documentType = null,Object? issuingCountry = null,Object? issueDate = freezed,Object? expiryDate = freezed,Object? verificationStatus = null,Object? status = null,Object? createdAt = freezed,Object? updatedAt = freezed,Object? documentNumber = null,Object? nationalNumber = null,Object? familyNumber = null,Object? verifiedAt = freezed,Object? rejectionReason = null,Object? availableImages = null,Object? replaces = freezed,}) {
  return _then(_self.copyWith(
uuid: null == uuid ? _self.uuid : uuid // ignore: cast_nullable_to_non_nullable
as String,documentType: null == documentType ? _self.documentType : documentType // ignore: cast_nullable_to_non_nullable
as IdentityDocumentType,issuingCountry: null == issuingCountry ? _self.issuingCountry : issuingCountry // ignore: cast_nullable_to_non_nullable
as String,issueDate: freezed == issueDate ? _self.issueDate : issueDate // ignore: cast_nullable_to_non_nullable
as DateTime?,expiryDate: freezed == expiryDate ? _self.expiryDate : expiryDate // ignore: cast_nullable_to_non_nullable
as DateTime?,verificationStatus: null == verificationStatus ? _self.verificationStatus : verificationStatus // ignore: cast_nullable_to_non_nullable
as VerificationStatus,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as IdentityDocumentLifecycleStatus,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,documentNumber: null == documentNumber ? _self.documentNumber : documentNumber // ignore: cast_nullable_to_non_nullable
as String,nationalNumber: null == nationalNumber ? _self.nationalNumber : nationalNumber // ignore: cast_nullable_to_non_nullable
as String,familyNumber: null == familyNumber ? _self.familyNumber : familyNumber // ignore: cast_nullable_to_non_nullable
as String,verifiedAt: freezed == verifiedAt ? _self.verifiedAt : verifiedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,rejectionReason: null == rejectionReason ? _self.rejectionReason : rejectionReason // ignore: cast_nullable_to_non_nullable
as String,availableImages: null == availableImages ? _self.availableImages : availableImages // ignore: cast_nullable_to_non_nullable
as List<String>,replaces: freezed == replaces ? _self.replaces : replaces // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [IdentityDocumentDetail].
extension IdentityDocumentDetailPatterns on IdentityDocumentDetail {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _IdentityDocumentDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _IdentityDocumentDetail() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _IdentityDocumentDetail value)  $default,){
final _that = this;
switch (_that) {
case _IdentityDocumentDetail():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _IdentityDocumentDetail value)?  $default,){
final _that = this;
switch (_that) {
case _IdentityDocumentDetail() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String uuid, @JsonKey(fromJson: identityDocumentTypeFromJson)  IdentityDocumentType documentType,  String issuingCountry,  DateTime? issueDate,  DateTime? expiryDate, @JsonKey(fromJson: verificationStatusFromJson)  VerificationStatus verificationStatus, @JsonKey(fromJson: identityLifecycleFromJson)  IdentityDocumentLifecycleStatus status,  DateTime? createdAt,  DateTime? updatedAt,  String documentNumber,  String nationalNumber,  String familyNumber,  DateTime? verifiedAt,  String rejectionReason,  List<String> availableImages,  String? replaces)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _IdentityDocumentDetail() when $default != null:
return $default(_that.uuid,_that.documentType,_that.issuingCountry,_that.issueDate,_that.expiryDate,_that.verificationStatus,_that.status,_that.createdAt,_that.updatedAt,_that.documentNumber,_that.nationalNumber,_that.familyNumber,_that.verifiedAt,_that.rejectionReason,_that.availableImages,_that.replaces);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String uuid, @JsonKey(fromJson: identityDocumentTypeFromJson)  IdentityDocumentType documentType,  String issuingCountry,  DateTime? issueDate,  DateTime? expiryDate, @JsonKey(fromJson: verificationStatusFromJson)  VerificationStatus verificationStatus, @JsonKey(fromJson: identityLifecycleFromJson)  IdentityDocumentLifecycleStatus status,  DateTime? createdAt,  DateTime? updatedAt,  String documentNumber,  String nationalNumber,  String familyNumber,  DateTime? verifiedAt,  String rejectionReason,  List<String> availableImages,  String? replaces)  $default,) {final _that = this;
switch (_that) {
case _IdentityDocumentDetail():
return $default(_that.uuid,_that.documentType,_that.issuingCountry,_that.issueDate,_that.expiryDate,_that.verificationStatus,_that.status,_that.createdAt,_that.updatedAt,_that.documentNumber,_that.nationalNumber,_that.familyNumber,_that.verifiedAt,_that.rejectionReason,_that.availableImages,_that.replaces);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String uuid, @JsonKey(fromJson: identityDocumentTypeFromJson)  IdentityDocumentType documentType,  String issuingCountry,  DateTime? issueDate,  DateTime? expiryDate, @JsonKey(fromJson: verificationStatusFromJson)  VerificationStatus verificationStatus, @JsonKey(fromJson: identityLifecycleFromJson)  IdentityDocumentLifecycleStatus status,  DateTime? createdAt,  DateTime? updatedAt,  String documentNumber,  String nationalNumber,  String familyNumber,  DateTime? verifiedAt,  String rejectionReason,  List<String> availableImages,  String? replaces)?  $default,) {final _that = this;
switch (_that) {
case _IdentityDocumentDetail() when $default != null:
return $default(_that.uuid,_that.documentType,_that.issuingCountry,_that.issueDate,_that.expiryDate,_that.verificationStatus,_that.status,_that.createdAt,_that.updatedAt,_that.documentNumber,_that.nationalNumber,_that.familyNumber,_that.verifiedAt,_that.rejectionReason,_that.availableImages,_that.replaces);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _IdentityDocumentDetail implements IdentityDocumentDetail {
  const _IdentityDocumentDetail({required this.uuid, @JsonKey(fromJson: identityDocumentTypeFromJson) this.documentType = IdentityDocumentType.unknown, this.issuingCountry = '', this.issueDate, this.expiryDate, @JsonKey(fromJson: verificationStatusFromJson) this.verificationStatus = VerificationStatus.unknown, @JsonKey(fromJson: identityLifecycleFromJson) this.status = IdentityDocumentLifecycleStatus.unknown, this.createdAt, this.updatedAt, this.documentNumber = '', this.nationalNumber = '', this.familyNumber = '', this.verifiedAt, this.rejectionReason = '', final  List<String> availableImages = const <String>[], this.replaces}): _availableImages = availableImages;
  factory _IdentityDocumentDetail.fromJson(Map<String, dynamic> json) => _$IdentityDocumentDetailFromJson(json);

@override final  String uuid;
@override@JsonKey(fromJson: identityDocumentTypeFromJson) final  IdentityDocumentType documentType;
@override@JsonKey() final  String issuingCountry;
@override final  DateTime? issueDate;
@override final  DateTime? expiryDate;
@override@JsonKey(fromJson: verificationStatusFromJson) final  VerificationStatus verificationStatus;
@override@JsonKey(fromJson: identityLifecycleFromJson) final  IdentityDocumentLifecycleStatus status;
@override final  DateTime? createdAt;
@override final  DateTime? updatedAt;
@override@JsonKey() final  String documentNumber;
@override@JsonKey() final  String nationalNumber;
@override@JsonKey() final  String familyNumber;
@override final  DateTime? verifiedAt;
@override@JsonKey() final  String rejectionReason;
 final  List<String> _availableImages;
@override@JsonKey() List<String> get availableImages {
  if (_availableImages is EqualUnmodifiableListView) return _availableImages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_availableImages);
}

@override final  String? replaces;

/// Create a copy of IdentityDocumentDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$IdentityDocumentDetailCopyWith<_IdentityDocumentDetail> get copyWith => __$IdentityDocumentDetailCopyWithImpl<_IdentityDocumentDetail>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$IdentityDocumentDetailToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _IdentityDocumentDetail&&(identical(other.uuid, uuid) || other.uuid == uuid)&&(identical(other.documentType, documentType) || other.documentType == documentType)&&(identical(other.issuingCountry, issuingCountry) || other.issuingCountry == issuingCountry)&&(identical(other.issueDate, issueDate) || other.issueDate == issueDate)&&(identical(other.expiryDate, expiryDate) || other.expiryDate == expiryDate)&&(identical(other.verificationStatus, verificationStatus) || other.verificationStatus == verificationStatus)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.documentNumber, documentNumber) || other.documentNumber == documentNumber)&&(identical(other.nationalNumber, nationalNumber) || other.nationalNumber == nationalNumber)&&(identical(other.familyNumber, familyNumber) || other.familyNumber == familyNumber)&&(identical(other.verifiedAt, verifiedAt) || other.verifiedAt == verifiedAt)&&(identical(other.rejectionReason, rejectionReason) || other.rejectionReason == rejectionReason)&&const DeepCollectionEquality().equals(other._availableImages, _availableImages)&&(identical(other.replaces, replaces) || other.replaces == replaces));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uuid,documentType,issuingCountry,issueDate,expiryDate,verificationStatus,status,createdAt,updatedAt,documentNumber,nationalNumber,familyNumber,verifiedAt,rejectionReason,const DeepCollectionEquality().hash(_availableImages),replaces);

@override
String toString() {
  return 'IdentityDocumentDetail(uuid: $uuid, documentType: $documentType, issuingCountry: $issuingCountry, issueDate: $issueDate, expiryDate: $expiryDate, verificationStatus: $verificationStatus, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, documentNumber: $documentNumber, nationalNumber: $nationalNumber, familyNumber: $familyNumber, verifiedAt: $verifiedAt, rejectionReason: $rejectionReason, availableImages: $availableImages, replaces: $replaces)';
}


}

/// @nodoc
abstract mixin class _$IdentityDocumentDetailCopyWith<$Res> implements $IdentityDocumentDetailCopyWith<$Res> {
  factory _$IdentityDocumentDetailCopyWith(_IdentityDocumentDetail value, $Res Function(_IdentityDocumentDetail) _then) = __$IdentityDocumentDetailCopyWithImpl;
@override @useResult
$Res call({
 String uuid,@JsonKey(fromJson: identityDocumentTypeFromJson) IdentityDocumentType documentType, String issuingCountry, DateTime? issueDate, DateTime? expiryDate,@JsonKey(fromJson: verificationStatusFromJson) VerificationStatus verificationStatus,@JsonKey(fromJson: identityLifecycleFromJson) IdentityDocumentLifecycleStatus status, DateTime? createdAt, DateTime? updatedAt, String documentNumber, String nationalNumber, String familyNumber, DateTime? verifiedAt, String rejectionReason, List<String> availableImages, String? replaces
});




}
/// @nodoc
class __$IdentityDocumentDetailCopyWithImpl<$Res>
    implements _$IdentityDocumentDetailCopyWith<$Res> {
  __$IdentityDocumentDetailCopyWithImpl(this._self, this._then);

  final _IdentityDocumentDetail _self;
  final $Res Function(_IdentityDocumentDetail) _then;

/// Create a copy of IdentityDocumentDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? uuid = null,Object? documentType = null,Object? issuingCountry = null,Object? issueDate = freezed,Object? expiryDate = freezed,Object? verificationStatus = null,Object? status = null,Object? createdAt = freezed,Object? updatedAt = freezed,Object? documentNumber = null,Object? nationalNumber = null,Object? familyNumber = null,Object? verifiedAt = freezed,Object? rejectionReason = null,Object? availableImages = null,Object? replaces = freezed,}) {
  return _then(_IdentityDocumentDetail(
uuid: null == uuid ? _self.uuid : uuid // ignore: cast_nullable_to_non_nullable
as String,documentType: null == documentType ? _self.documentType : documentType // ignore: cast_nullable_to_non_nullable
as IdentityDocumentType,issuingCountry: null == issuingCountry ? _self.issuingCountry : issuingCountry // ignore: cast_nullable_to_non_nullable
as String,issueDate: freezed == issueDate ? _self.issueDate : issueDate // ignore: cast_nullable_to_non_nullable
as DateTime?,expiryDate: freezed == expiryDate ? _self.expiryDate : expiryDate // ignore: cast_nullable_to_non_nullable
as DateTime?,verificationStatus: null == verificationStatus ? _self.verificationStatus : verificationStatus // ignore: cast_nullable_to_non_nullable
as VerificationStatus,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as IdentityDocumentLifecycleStatus,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,documentNumber: null == documentNumber ? _self.documentNumber : documentNumber // ignore: cast_nullable_to_non_nullable
as String,nationalNumber: null == nationalNumber ? _self.nationalNumber : nationalNumber // ignore: cast_nullable_to_non_nullable
as String,familyNumber: null == familyNumber ? _self.familyNumber : familyNumber // ignore: cast_nullable_to_non_nullable
as String,verifiedAt: freezed == verifiedAt ? _self.verifiedAt : verifiedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,rejectionReason: null == rejectionReason ? _self.rejectionReason : rejectionReason // ignore: cast_nullable_to_non_nullable
as String,availableImages: null == availableImages ? _self._availableImages : availableImages // ignore: cast_nullable_to_non_nullable
as List<String>,replaces: freezed == replaces ? _self.replaces : replaces // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
