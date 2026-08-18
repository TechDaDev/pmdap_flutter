// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lab_results.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LabResultItem {

 String get uuid; int get pageNumber; int get rowIndex; String get testNameRaw; String get testNameNormalized; String get resultRaw; String? get resultNumeric; String get resultText; String get unitRaw; String get unitNormalized; String get referenceRangeRaw; String? get referenceLow; String? get referenceHigh; String get flagRaw; double get extractionConfidence;
/// Create a copy of LabResultItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LabResultItemCopyWith<LabResultItem> get copyWith => _$LabResultItemCopyWithImpl<LabResultItem>(this as LabResultItem, _$identity);

  /// Serializes this LabResultItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LabResultItem&&(identical(other.uuid, uuid) || other.uuid == uuid)&&(identical(other.pageNumber, pageNumber) || other.pageNumber == pageNumber)&&(identical(other.rowIndex, rowIndex) || other.rowIndex == rowIndex)&&(identical(other.testNameRaw, testNameRaw) || other.testNameRaw == testNameRaw)&&(identical(other.testNameNormalized, testNameNormalized) || other.testNameNormalized == testNameNormalized)&&(identical(other.resultRaw, resultRaw) || other.resultRaw == resultRaw)&&(identical(other.resultNumeric, resultNumeric) || other.resultNumeric == resultNumeric)&&(identical(other.resultText, resultText) || other.resultText == resultText)&&(identical(other.unitRaw, unitRaw) || other.unitRaw == unitRaw)&&(identical(other.unitNormalized, unitNormalized) || other.unitNormalized == unitNormalized)&&(identical(other.referenceRangeRaw, referenceRangeRaw) || other.referenceRangeRaw == referenceRangeRaw)&&(identical(other.referenceLow, referenceLow) || other.referenceLow == referenceLow)&&(identical(other.referenceHigh, referenceHigh) || other.referenceHigh == referenceHigh)&&(identical(other.flagRaw, flagRaw) || other.flagRaw == flagRaw)&&(identical(other.extractionConfidence, extractionConfidence) || other.extractionConfidence == extractionConfidence));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uuid,pageNumber,rowIndex,testNameRaw,testNameNormalized,resultRaw,resultNumeric,resultText,unitRaw,unitNormalized,referenceRangeRaw,referenceLow,referenceHigh,flagRaw,extractionConfidence);

@override
String toString() {
  return 'LabResultItem(uuid: $uuid, pageNumber: $pageNumber, rowIndex: $rowIndex, testNameRaw: $testNameRaw, testNameNormalized: $testNameNormalized, resultRaw: $resultRaw, resultNumeric: $resultNumeric, resultText: $resultText, unitRaw: $unitRaw, unitNormalized: $unitNormalized, referenceRangeRaw: $referenceRangeRaw, referenceLow: $referenceLow, referenceHigh: $referenceHigh, flagRaw: $flagRaw, extractionConfidence: $extractionConfidence)';
}


}

/// @nodoc
abstract mixin class $LabResultItemCopyWith<$Res>  {
  factory $LabResultItemCopyWith(LabResultItem value, $Res Function(LabResultItem) _then) = _$LabResultItemCopyWithImpl;
@useResult
$Res call({
 String uuid, int pageNumber, int rowIndex, String testNameRaw, String testNameNormalized, String resultRaw, String? resultNumeric, String resultText, String unitRaw, String unitNormalized, String referenceRangeRaw, String? referenceLow, String? referenceHigh, String flagRaw, double extractionConfidence
});




}
/// @nodoc
class _$LabResultItemCopyWithImpl<$Res>
    implements $LabResultItemCopyWith<$Res> {
  _$LabResultItemCopyWithImpl(this._self, this._then);

  final LabResultItem _self;
  final $Res Function(LabResultItem) _then;

/// Create a copy of LabResultItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? uuid = null,Object? pageNumber = null,Object? rowIndex = null,Object? testNameRaw = null,Object? testNameNormalized = null,Object? resultRaw = null,Object? resultNumeric = freezed,Object? resultText = null,Object? unitRaw = null,Object? unitNormalized = null,Object? referenceRangeRaw = null,Object? referenceLow = freezed,Object? referenceHigh = freezed,Object? flagRaw = null,Object? extractionConfidence = null,}) {
  return _then(_self.copyWith(
uuid: null == uuid ? _self.uuid : uuid // ignore: cast_nullable_to_non_nullable
as String,pageNumber: null == pageNumber ? _self.pageNumber : pageNumber // ignore: cast_nullable_to_non_nullable
as int,rowIndex: null == rowIndex ? _self.rowIndex : rowIndex // ignore: cast_nullable_to_non_nullable
as int,testNameRaw: null == testNameRaw ? _self.testNameRaw : testNameRaw // ignore: cast_nullable_to_non_nullable
as String,testNameNormalized: null == testNameNormalized ? _self.testNameNormalized : testNameNormalized // ignore: cast_nullable_to_non_nullable
as String,resultRaw: null == resultRaw ? _self.resultRaw : resultRaw // ignore: cast_nullable_to_non_nullable
as String,resultNumeric: freezed == resultNumeric ? _self.resultNumeric : resultNumeric // ignore: cast_nullable_to_non_nullable
as String?,resultText: null == resultText ? _self.resultText : resultText // ignore: cast_nullable_to_non_nullable
as String,unitRaw: null == unitRaw ? _self.unitRaw : unitRaw // ignore: cast_nullable_to_non_nullable
as String,unitNormalized: null == unitNormalized ? _self.unitNormalized : unitNormalized // ignore: cast_nullable_to_non_nullable
as String,referenceRangeRaw: null == referenceRangeRaw ? _self.referenceRangeRaw : referenceRangeRaw // ignore: cast_nullable_to_non_nullable
as String,referenceLow: freezed == referenceLow ? _self.referenceLow : referenceLow // ignore: cast_nullable_to_non_nullable
as String?,referenceHigh: freezed == referenceHigh ? _self.referenceHigh : referenceHigh // ignore: cast_nullable_to_non_nullable
as String?,flagRaw: null == flagRaw ? _self.flagRaw : flagRaw // ignore: cast_nullable_to_non_nullable
as String,extractionConfidence: null == extractionConfidence ? _self.extractionConfidence : extractionConfidence // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [LabResultItem].
extension LabResultItemPatterns on LabResultItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LabResultItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LabResultItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LabResultItem value)  $default,){
final _that = this;
switch (_that) {
case _LabResultItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LabResultItem value)?  $default,){
final _that = this;
switch (_that) {
case _LabResultItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String uuid,  int pageNumber,  int rowIndex,  String testNameRaw,  String testNameNormalized,  String resultRaw,  String? resultNumeric,  String resultText,  String unitRaw,  String unitNormalized,  String referenceRangeRaw,  String? referenceLow,  String? referenceHigh,  String flagRaw,  double extractionConfidence)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LabResultItem() when $default != null:
return $default(_that.uuid,_that.pageNumber,_that.rowIndex,_that.testNameRaw,_that.testNameNormalized,_that.resultRaw,_that.resultNumeric,_that.resultText,_that.unitRaw,_that.unitNormalized,_that.referenceRangeRaw,_that.referenceLow,_that.referenceHigh,_that.flagRaw,_that.extractionConfidence);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String uuid,  int pageNumber,  int rowIndex,  String testNameRaw,  String testNameNormalized,  String resultRaw,  String? resultNumeric,  String resultText,  String unitRaw,  String unitNormalized,  String referenceRangeRaw,  String? referenceLow,  String? referenceHigh,  String flagRaw,  double extractionConfidence)  $default,) {final _that = this;
switch (_that) {
case _LabResultItem():
return $default(_that.uuid,_that.pageNumber,_that.rowIndex,_that.testNameRaw,_that.testNameNormalized,_that.resultRaw,_that.resultNumeric,_that.resultText,_that.unitRaw,_that.unitNormalized,_that.referenceRangeRaw,_that.referenceLow,_that.referenceHigh,_that.flagRaw,_that.extractionConfidence);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String uuid,  int pageNumber,  int rowIndex,  String testNameRaw,  String testNameNormalized,  String resultRaw,  String? resultNumeric,  String resultText,  String unitRaw,  String unitNormalized,  String referenceRangeRaw,  String? referenceLow,  String? referenceHigh,  String flagRaw,  double extractionConfidence)?  $default,) {final _that = this;
switch (_that) {
case _LabResultItem() when $default != null:
return $default(_that.uuid,_that.pageNumber,_that.rowIndex,_that.testNameRaw,_that.testNameNormalized,_that.resultRaw,_that.resultNumeric,_that.resultText,_that.unitRaw,_that.unitNormalized,_that.referenceRangeRaw,_that.referenceLow,_that.referenceHigh,_that.flagRaw,_that.extractionConfidence);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _LabResultItem implements LabResultItem {
  const _LabResultItem({required this.uuid, this.pageNumber = 1, this.rowIndex = 0, this.testNameRaw = '', this.testNameNormalized = '', this.resultRaw = '', this.resultNumeric, this.resultText = '', this.unitRaw = '', this.unitNormalized = '', this.referenceRangeRaw = '', this.referenceLow, this.referenceHigh, this.flagRaw = '', this.extractionConfidence = 0.0});
  factory _LabResultItem.fromJson(Map<String, dynamic> json) => _$LabResultItemFromJson(json);

@override final  String uuid;
@override@JsonKey() final  int pageNumber;
@override@JsonKey() final  int rowIndex;
@override@JsonKey() final  String testNameRaw;
@override@JsonKey() final  String testNameNormalized;
@override@JsonKey() final  String resultRaw;
@override final  String? resultNumeric;
@override@JsonKey() final  String resultText;
@override@JsonKey() final  String unitRaw;
@override@JsonKey() final  String unitNormalized;
@override@JsonKey() final  String referenceRangeRaw;
@override final  String? referenceLow;
@override final  String? referenceHigh;
@override@JsonKey() final  String flagRaw;
@override@JsonKey() final  double extractionConfidence;

/// Create a copy of LabResultItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LabResultItemCopyWith<_LabResultItem> get copyWith => __$LabResultItemCopyWithImpl<_LabResultItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LabResultItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LabResultItem&&(identical(other.uuid, uuid) || other.uuid == uuid)&&(identical(other.pageNumber, pageNumber) || other.pageNumber == pageNumber)&&(identical(other.rowIndex, rowIndex) || other.rowIndex == rowIndex)&&(identical(other.testNameRaw, testNameRaw) || other.testNameRaw == testNameRaw)&&(identical(other.testNameNormalized, testNameNormalized) || other.testNameNormalized == testNameNormalized)&&(identical(other.resultRaw, resultRaw) || other.resultRaw == resultRaw)&&(identical(other.resultNumeric, resultNumeric) || other.resultNumeric == resultNumeric)&&(identical(other.resultText, resultText) || other.resultText == resultText)&&(identical(other.unitRaw, unitRaw) || other.unitRaw == unitRaw)&&(identical(other.unitNormalized, unitNormalized) || other.unitNormalized == unitNormalized)&&(identical(other.referenceRangeRaw, referenceRangeRaw) || other.referenceRangeRaw == referenceRangeRaw)&&(identical(other.referenceLow, referenceLow) || other.referenceLow == referenceLow)&&(identical(other.referenceHigh, referenceHigh) || other.referenceHigh == referenceHigh)&&(identical(other.flagRaw, flagRaw) || other.flagRaw == flagRaw)&&(identical(other.extractionConfidence, extractionConfidence) || other.extractionConfidence == extractionConfidence));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uuid,pageNumber,rowIndex,testNameRaw,testNameNormalized,resultRaw,resultNumeric,resultText,unitRaw,unitNormalized,referenceRangeRaw,referenceLow,referenceHigh,flagRaw,extractionConfidence);

@override
String toString() {
  return 'LabResultItem(uuid: $uuid, pageNumber: $pageNumber, rowIndex: $rowIndex, testNameRaw: $testNameRaw, testNameNormalized: $testNameNormalized, resultRaw: $resultRaw, resultNumeric: $resultNumeric, resultText: $resultText, unitRaw: $unitRaw, unitNormalized: $unitNormalized, referenceRangeRaw: $referenceRangeRaw, referenceLow: $referenceLow, referenceHigh: $referenceHigh, flagRaw: $flagRaw, extractionConfidence: $extractionConfidence)';
}


}

/// @nodoc
abstract mixin class _$LabResultItemCopyWith<$Res> implements $LabResultItemCopyWith<$Res> {
  factory _$LabResultItemCopyWith(_LabResultItem value, $Res Function(_LabResultItem) _then) = __$LabResultItemCopyWithImpl;
@override @useResult
$Res call({
 String uuid, int pageNumber, int rowIndex, String testNameRaw, String testNameNormalized, String resultRaw, String? resultNumeric, String resultText, String unitRaw, String unitNormalized, String referenceRangeRaw, String? referenceLow, String? referenceHigh, String flagRaw, double extractionConfidence
});




}
/// @nodoc
class __$LabResultItemCopyWithImpl<$Res>
    implements _$LabResultItemCopyWith<$Res> {
  __$LabResultItemCopyWithImpl(this._self, this._then);

  final _LabResultItem _self;
  final $Res Function(_LabResultItem) _then;

/// Create a copy of LabResultItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? uuid = null,Object? pageNumber = null,Object? rowIndex = null,Object? testNameRaw = null,Object? testNameNormalized = null,Object? resultRaw = null,Object? resultNumeric = freezed,Object? resultText = null,Object? unitRaw = null,Object? unitNormalized = null,Object? referenceRangeRaw = null,Object? referenceLow = freezed,Object? referenceHigh = freezed,Object? flagRaw = null,Object? extractionConfidence = null,}) {
  return _then(_LabResultItem(
uuid: null == uuid ? _self.uuid : uuid // ignore: cast_nullable_to_non_nullable
as String,pageNumber: null == pageNumber ? _self.pageNumber : pageNumber // ignore: cast_nullable_to_non_nullable
as int,rowIndex: null == rowIndex ? _self.rowIndex : rowIndex // ignore: cast_nullable_to_non_nullable
as int,testNameRaw: null == testNameRaw ? _self.testNameRaw : testNameRaw // ignore: cast_nullable_to_non_nullable
as String,testNameNormalized: null == testNameNormalized ? _self.testNameNormalized : testNameNormalized // ignore: cast_nullable_to_non_nullable
as String,resultRaw: null == resultRaw ? _self.resultRaw : resultRaw // ignore: cast_nullable_to_non_nullable
as String,resultNumeric: freezed == resultNumeric ? _self.resultNumeric : resultNumeric // ignore: cast_nullable_to_non_nullable
as String?,resultText: null == resultText ? _self.resultText : resultText // ignore: cast_nullable_to_non_nullable
as String,unitRaw: null == unitRaw ? _self.unitRaw : unitRaw // ignore: cast_nullable_to_non_nullable
as String,unitNormalized: null == unitNormalized ? _self.unitNormalized : unitNormalized // ignore: cast_nullable_to_non_nullable
as String,referenceRangeRaw: null == referenceRangeRaw ? _self.referenceRangeRaw : referenceRangeRaw // ignore: cast_nullable_to_non_nullable
as String,referenceLow: freezed == referenceLow ? _self.referenceLow : referenceLow // ignore: cast_nullable_to_non_nullable
as String?,referenceHigh: freezed == referenceHigh ? _self.referenceHigh : referenceHigh // ignore: cast_nullable_to_non_nullable
as String?,flagRaw: null == flagRaw ? _self.flagRaw : flagRaw // ignore: cast_nullable_to_non_nullable
as String,extractionConfidence: null == extractionConfidence ? _self.extractionConfidence : extractionConfidence // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$LabResultsResponse {

 String get documentUuid; String get documentType; String get extractionStatus; String? get pipelineVersion; int get resultCount; List<LabResultItem> get results;
/// Create a copy of LabResultsResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LabResultsResponseCopyWith<LabResultsResponse> get copyWith => _$LabResultsResponseCopyWithImpl<LabResultsResponse>(this as LabResultsResponse, _$identity);

  /// Serializes this LabResultsResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LabResultsResponse&&(identical(other.documentUuid, documentUuid) || other.documentUuid == documentUuid)&&(identical(other.documentType, documentType) || other.documentType == documentType)&&(identical(other.extractionStatus, extractionStatus) || other.extractionStatus == extractionStatus)&&(identical(other.pipelineVersion, pipelineVersion) || other.pipelineVersion == pipelineVersion)&&(identical(other.resultCount, resultCount) || other.resultCount == resultCount)&&const DeepCollectionEquality().equals(other.results, results));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,documentUuid,documentType,extractionStatus,pipelineVersion,resultCount,const DeepCollectionEquality().hash(results));

@override
String toString() {
  return 'LabResultsResponse(documentUuid: $documentUuid, documentType: $documentType, extractionStatus: $extractionStatus, pipelineVersion: $pipelineVersion, resultCount: $resultCount, results: $results)';
}


}

/// @nodoc
abstract mixin class $LabResultsResponseCopyWith<$Res>  {
  factory $LabResultsResponseCopyWith(LabResultsResponse value, $Res Function(LabResultsResponse) _then) = _$LabResultsResponseCopyWithImpl;
@useResult
$Res call({
 String documentUuid, String documentType, String extractionStatus, String? pipelineVersion, int resultCount, List<LabResultItem> results
});




}
/// @nodoc
class _$LabResultsResponseCopyWithImpl<$Res>
    implements $LabResultsResponseCopyWith<$Res> {
  _$LabResultsResponseCopyWithImpl(this._self, this._then);

  final LabResultsResponse _self;
  final $Res Function(LabResultsResponse) _then;

/// Create a copy of LabResultsResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? documentUuid = null,Object? documentType = null,Object? extractionStatus = null,Object? pipelineVersion = freezed,Object? resultCount = null,Object? results = null,}) {
  return _then(_self.copyWith(
documentUuid: null == documentUuid ? _self.documentUuid : documentUuid // ignore: cast_nullable_to_non_nullable
as String,documentType: null == documentType ? _self.documentType : documentType // ignore: cast_nullable_to_non_nullable
as String,extractionStatus: null == extractionStatus ? _self.extractionStatus : extractionStatus // ignore: cast_nullable_to_non_nullable
as String,pipelineVersion: freezed == pipelineVersion ? _self.pipelineVersion : pipelineVersion // ignore: cast_nullable_to_non_nullable
as String?,resultCount: null == resultCount ? _self.resultCount : resultCount // ignore: cast_nullable_to_non_nullable
as int,results: null == results ? _self.results : results // ignore: cast_nullable_to_non_nullable
as List<LabResultItem>,
  ));
}

}


/// Adds pattern-matching-related methods to [LabResultsResponse].
extension LabResultsResponsePatterns on LabResultsResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LabResultsResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LabResultsResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LabResultsResponse value)  $default,){
final _that = this;
switch (_that) {
case _LabResultsResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LabResultsResponse value)?  $default,){
final _that = this;
switch (_that) {
case _LabResultsResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String documentUuid,  String documentType,  String extractionStatus,  String? pipelineVersion,  int resultCount,  List<LabResultItem> results)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LabResultsResponse() when $default != null:
return $default(_that.documentUuid,_that.documentType,_that.extractionStatus,_that.pipelineVersion,_that.resultCount,_that.results);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String documentUuid,  String documentType,  String extractionStatus,  String? pipelineVersion,  int resultCount,  List<LabResultItem> results)  $default,) {final _that = this;
switch (_that) {
case _LabResultsResponse():
return $default(_that.documentUuid,_that.documentType,_that.extractionStatus,_that.pipelineVersion,_that.resultCount,_that.results);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String documentUuid,  String documentType,  String extractionStatus,  String? pipelineVersion,  int resultCount,  List<LabResultItem> results)?  $default,) {final _that = this;
switch (_that) {
case _LabResultsResponse() when $default != null:
return $default(_that.documentUuid,_that.documentType,_that.extractionStatus,_that.pipelineVersion,_that.resultCount,_that.results);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _LabResultsResponse implements LabResultsResponse {
  const _LabResultsResponse({required this.documentUuid, this.documentType = '', this.extractionStatus = '', this.pipelineVersion, this.resultCount = 0, final  List<LabResultItem> results = const <LabResultItem>[]}): _results = results;
  factory _LabResultsResponse.fromJson(Map<String, dynamic> json) => _$LabResultsResponseFromJson(json);

@override final  String documentUuid;
@override@JsonKey() final  String documentType;
@override@JsonKey() final  String extractionStatus;
@override final  String? pipelineVersion;
@override@JsonKey() final  int resultCount;
 final  List<LabResultItem> _results;
@override@JsonKey() List<LabResultItem> get results {
  if (_results is EqualUnmodifiableListView) return _results;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_results);
}


/// Create a copy of LabResultsResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LabResultsResponseCopyWith<_LabResultsResponse> get copyWith => __$LabResultsResponseCopyWithImpl<_LabResultsResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LabResultsResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LabResultsResponse&&(identical(other.documentUuid, documentUuid) || other.documentUuid == documentUuid)&&(identical(other.documentType, documentType) || other.documentType == documentType)&&(identical(other.extractionStatus, extractionStatus) || other.extractionStatus == extractionStatus)&&(identical(other.pipelineVersion, pipelineVersion) || other.pipelineVersion == pipelineVersion)&&(identical(other.resultCount, resultCount) || other.resultCount == resultCount)&&const DeepCollectionEquality().equals(other._results, _results));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,documentUuid,documentType,extractionStatus,pipelineVersion,resultCount,const DeepCollectionEquality().hash(_results));

@override
String toString() {
  return 'LabResultsResponse(documentUuid: $documentUuid, documentType: $documentType, extractionStatus: $extractionStatus, pipelineVersion: $pipelineVersion, resultCount: $resultCount, results: $results)';
}


}

/// @nodoc
abstract mixin class _$LabResultsResponseCopyWith<$Res> implements $LabResultsResponseCopyWith<$Res> {
  factory _$LabResultsResponseCopyWith(_LabResultsResponse value, $Res Function(_LabResultsResponse) _then) = __$LabResultsResponseCopyWithImpl;
@override @useResult
$Res call({
 String documentUuid, String documentType, String extractionStatus, String? pipelineVersion, int resultCount, List<LabResultItem> results
});




}
/// @nodoc
class __$LabResultsResponseCopyWithImpl<$Res>
    implements _$LabResultsResponseCopyWith<$Res> {
  __$LabResultsResponseCopyWithImpl(this._self, this._then);

  final _LabResultsResponse _self;
  final $Res Function(_LabResultsResponse) _then;

/// Create a copy of LabResultsResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? documentUuid = null,Object? documentType = null,Object? extractionStatus = null,Object? pipelineVersion = freezed,Object? resultCount = null,Object? results = null,}) {
  return _then(_LabResultsResponse(
documentUuid: null == documentUuid ? _self.documentUuid : documentUuid // ignore: cast_nullable_to_non_nullable
as String,documentType: null == documentType ? _self.documentType : documentType // ignore: cast_nullable_to_non_nullable
as String,extractionStatus: null == extractionStatus ? _self.extractionStatus : extractionStatus // ignore: cast_nullable_to_non_nullable
as String,pipelineVersion: freezed == pipelineVersion ? _self.pipelineVersion : pipelineVersion // ignore: cast_nullable_to_non_nullable
as String?,resultCount: null == resultCount ? _self.resultCount : resultCount // ignore: cast_nullable_to_non_nullable
as int,results: null == results ? _self._results : results // ignore: cast_nullable_to_non_nullable
as List<LabResultItem>,
  ));
}


}

// dart format on
