// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'document_page.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MedicalDocumentPageSummaryItem {

 int get pageNumber; String get reportSubtype; String get processingStatus; DateTime? get documentDate; bool get dateVerified; int get labResultCount; int get dateCandidateCount;
/// Create a copy of MedicalDocumentPageSummaryItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MedicalDocumentPageSummaryItemCopyWith<MedicalDocumentPageSummaryItem> get copyWith => _$MedicalDocumentPageSummaryItemCopyWithImpl<MedicalDocumentPageSummaryItem>(this as MedicalDocumentPageSummaryItem, _$identity);

  /// Serializes this MedicalDocumentPageSummaryItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MedicalDocumentPageSummaryItem&&(identical(other.pageNumber, pageNumber) || other.pageNumber == pageNumber)&&(identical(other.reportSubtype, reportSubtype) || other.reportSubtype == reportSubtype)&&(identical(other.processingStatus, processingStatus) || other.processingStatus == processingStatus)&&(identical(other.documentDate, documentDate) || other.documentDate == documentDate)&&(identical(other.dateVerified, dateVerified) || other.dateVerified == dateVerified)&&(identical(other.labResultCount, labResultCount) || other.labResultCount == labResultCount)&&(identical(other.dateCandidateCount, dateCandidateCount) || other.dateCandidateCount == dateCandidateCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,pageNumber,reportSubtype,processingStatus,documentDate,dateVerified,labResultCount,dateCandidateCount);

@override
String toString() {
  return 'MedicalDocumentPageSummaryItem(pageNumber: $pageNumber, reportSubtype: $reportSubtype, processingStatus: $processingStatus, documentDate: $documentDate, dateVerified: $dateVerified, labResultCount: $labResultCount, dateCandidateCount: $dateCandidateCount)';
}


}

/// @nodoc
abstract mixin class $MedicalDocumentPageSummaryItemCopyWith<$Res>  {
  factory $MedicalDocumentPageSummaryItemCopyWith(MedicalDocumentPageSummaryItem value, $Res Function(MedicalDocumentPageSummaryItem) _then) = _$MedicalDocumentPageSummaryItemCopyWithImpl;
@useResult
$Res call({
 int pageNumber, String reportSubtype, String processingStatus, DateTime? documentDate, bool dateVerified, int labResultCount, int dateCandidateCount
});




}
/// @nodoc
class _$MedicalDocumentPageSummaryItemCopyWithImpl<$Res>
    implements $MedicalDocumentPageSummaryItemCopyWith<$Res> {
  _$MedicalDocumentPageSummaryItemCopyWithImpl(this._self, this._then);

  final MedicalDocumentPageSummaryItem _self;
  final $Res Function(MedicalDocumentPageSummaryItem) _then;

/// Create a copy of MedicalDocumentPageSummaryItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? pageNumber = null,Object? reportSubtype = null,Object? processingStatus = null,Object? documentDate = freezed,Object? dateVerified = null,Object? labResultCount = null,Object? dateCandidateCount = null,}) {
  return _then(_self.copyWith(
pageNumber: null == pageNumber ? _self.pageNumber : pageNumber // ignore: cast_nullable_to_non_nullable
as int,reportSubtype: null == reportSubtype ? _self.reportSubtype : reportSubtype // ignore: cast_nullable_to_non_nullable
as String,processingStatus: null == processingStatus ? _self.processingStatus : processingStatus // ignore: cast_nullable_to_non_nullable
as String,documentDate: freezed == documentDate ? _self.documentDate : documentDate // ignore: cast_nullable_to_non_nullable
as DateTime?,dateVerified: null == dateVerified ? _self.dateVerified : dateVerified // ignore: cast_nullable_to_non_nullable
as bool,labResultCount: null == labResultCount ? _self.labResultCount : labResultCount // ignore: cast_nullable_to_non_nullable
as int,dateCandidateCount: null == dateCandidateCount ? _self.dateCandidateCount : dateCandidateCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [MedicalDocumentPageSummaryItem].
extension MedicalDocumentPageSummaryItemPatterns on MedicalDocumentPageSummaryItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MedicalDocumentPageSummaryItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MedicalDocumentPageSummaryItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MedicalDocumentPageSummaryItem value)  $default,){
final _that = this;
switch (_that) {
case _MedicalDocumentPageSummaryItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MedicalDocumentPageSummaryItem value)?  $default,){
final _that = this;
switch (_that) {
case _MedicalDocumentPageSummaryItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int pageNumber,  String reportSubtype,  String processingStatus,  DateTime? documentDate,  bool dateVerified,  int labResultCount,  int dateCandidateCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MedicalDocumentPageSummaryItem() when $default != null:
return $default(_that.pageNumber,_that.reportSubtype,_that.processingStatus,_that.documentDate,_that.dateVerified,_that.labResultCount,_that.dateCandidateCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int pageNumber,  String reportSubtype,  String processingStatus,  DateTime? documentDate,  bool dateVerified,  int labResultCount,  int dateCandidateCount)  $default,) {final _that = this;
switch (_that) {
case _MedicalDocumentPageSummaryItem():
return $default(_that.pageNumber,_that.reportSubtype,_that.processingStatus,_that.documentDate,_that.dateVerified,_that.labResultCount,_that.dateCandidateCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int pageNumber,  String reportSubtype,  String processingStatus,  DateTime? documentDate,  bool dateVerified,  int labResultCount,  int dateCandidateCount)?  $default,) {final _that = this;
switch (_that) {
case _MedicalDocumentPageSummaryItem() when $default != null:
return $default(_that.pageNumber,_that.reportSubtype,_that.processingStatus,_that.documentDate,_that.dateVerified,_that.labResultCount,_that.dateCandidateCount);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _MedicalDocumentPageSummaryItem implements MedicalDocumentPageSummaryItem {
  const _MedicalDocumentPageSummaryItem({required this.pageNumber, this.reportSubtype = ReportSubtype.unknown, this.processingStatus = '', this.documentDate, this.dateVerified = false, this.labResultCount = 0, this.dateCandidateCount = 0});
  factory _MedicalDocumentPageSummaryItem.fromJson(Map<String, dynamic> json) => _$MedicalDocumentPageSummaryItemFromJson(json);

@override final  int pageNumber;
@override@JsonKey() final  String reportSubtype;
@override@JsonKey() final  String processingStatus;
@override final  DateTime? documentDate;
@override@JsonKey() final  bool dateVerified;
@override@JsonKey() final  int labResultCount;
@override@JsonKey() final  int dateCandidateCount;

/// Create a copy of MedicalDocumentPageSummaryItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MedicalDocumentPageSummaryItemCopyWith<_MedicalDocumentPageSummaryItem> get copyWith => __$MedicalDocumentPageSummaryItemCopyWithImpl<_MedicalDocumentPageSummaryItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MedicalDocumentPageSummaryItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MedicalDocumentPageSummaryItem&&(identical(other.pageNumber, pageNumber) || other.pageNumber == pageNumber)&&(identical(other.reportSubtype, reportSubtype) || other.reportSubtype == reportSubtype)&&(identical(other.processingStatus, processingStatus) || other.processingStatus == processingStatus)&&(identical(other.documentDate, documentDate) || other.documentDate == documentDate)&&(identical(other.dateVerified, dateVerified) || other.dateVerified == dateVerified)&&(identical(other.labResultCount, labResultCount) || other.labResultCount == labResultCount)&&(identical(other.dateCandidateCount, dateCandidateCount) || other.dateCandidateCount == dateCandidateCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,pageNumber,reportSubtype,processingStatus,documentDate,dateVerified,labResultCount,dateCandidateCount);

@override
String toString() {
  return 'MedicalDocumentPageSummaryItem(pageNumber: $pageNumber, reportSubtype: $reportSubtype, processingStatus: $processingStatus, documentDate: $documentDate, dateVerified: $dateVerified, labResultCount: $labResultCount, dateCandidateCount: $dateCandidateCount)';
}


}

/// @nodoc
abstract mixin class _$MedicalDocumentPageSummaryItemCopyWith<$Res> implements $MedicalDocumentPageSummaryItemCopyWith<$Res> {
  factory _$MedicalDocumentPageSummaryItemCopyWith(_MedicalDocumentPageSummaryItem value, $Res Function(_MedicalDocumentPageSummaryItem) _then) = __$MedicalDocumentPageSummaryItemCopyWithImpl;
@override @useResult
$Res call({
 int pageNumber, String reportSubtype, String processingStatus, DateTime? documentDate, bool dateVerified, int labResultCount, int dateCandidateCount
});




}
/// @nodoc
class __$MedicalDocumentPageSummaryItemCopyWithImpl<$Res>
    implements _$MedicalDocumentPageSummaryItemCopyWith<$Res> {
  __$MedicalDocumentPageSummaryItemCopyWithImpl(this._self, this._then);

  final _MedicalDocumentPageSummaryItem _self;
  final $Res Function(_MedicalDocumentPageSummaryItem) _then;

/// Create a copy of MedicalDocumentPageSummaryItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? pageNumber = null,Object? reportSubtype = null,Object? processingStatus = null,Object? documentDate = freezed,Object? dateVerified = null,Object? labResultCount = null,Object? dateCandidateCount = null,}) {
  return _then(_MedicalDocumentPageSummaryItem(
pageNumber: null == pageNumber ? _self.pageNumber : pageNumber // ignore: cast_nullable_to_non_nullable
as int,reportSubtype: null == reportSubtype ? _self.reportSubtype : reportSubtype // ignore: cast_nullable_to_non_nullable
as String,processingStatus: null == processingStatus ? _self.processingStatus : processingStatus // ignore: cast_nullable_to_non_nullable
as String,documentDate: freezed == documentDate ? _self.documentDate : documentDate // ignore: cast_nullable_to_non_nullable
as DateTime?,dateVerified: null == dateVerified ? _self.dateVerified : dateVerified // ignore: cast_nullable_to_non_nullable
as bool,labResultCount: null == labResultCount ? _self.labResultCount : labResultCount // ignore: cast_nullable_to_non_nullable
as int,dateCandidateCount: null == dateCandidateCount ? _self.dateCandidateCount : dateCandidateCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$MedicalDocumentPageSummary {

 String get documentUuid; int get pageCount; List<MedicalDocumentPageSummaryItem> get pages;
/// Create a copy of MedicalDocumentPageSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MedicalDocumentPageSummaryCopyWith<MedicalDocumentPageSummary> get copyWith => _$MedicalDocumentPageSummaryCopyWithImpl<MedicalDocumentPageSummary>(this as MedicalDocumentPageSummary, _$identity);

  /// Serializes this MedicalDocumentPageSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MedicalDocumentPageSummary&&(identical(other.documentUuid, documentUuid) || other.documentUuid == documentUuid)&&(identical(other.pageCount, pageCount) || other.pageCount == pageCount)&&const DeepCollectionEquality().equals(other.pages, pages));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,documentUuid,pageCount,const DeepCollectionEquality().hash(pages));

@override
String toString() {
  return 'MedicalDocumentPageSummary(documentUuid: $documentUuid, pageCount: $pageCount, pages: $pages)';
}


}

/// @nodoc
abstract mixin class $MedicalDocumentPageSummaryCopyWith<$Res>  {
  factory $MedicalDocumentPageSummaryCopyWith(MedicalDocumentPageSummary value, $Res Function(MedicalDocumentPageSummary) _then) = _$MedicalDocumentPageSummaryCopyWithImpl;
@useResult
$Res call({
 String documentUuid, int pageCount, List<MedicalDocumentPageSummaryItem> pages
});




}
/// @nodoc
class _$MedicalDocumentPageSummaryCopyWithImpl<$Res>
    implements $MedicalDocumentPageSummaryCopyWith<$Res> {
  _$MedicalDocumentPageSummaryCopyWithImpl(this._self, this._then);

  final MedicalDocumentPageSummary _self;
  final $Res Function(MedicalDocumentPageSummary) _then;

/// Create a copy of MedicalDocumentPageSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? documentUuid = null,Object? pageCount = null,Object? pages = null,}) {
  return _then(_self.copyWith(
documentUuid: null == documentUuid ? _self.documentUuid : documentUuid // ignore: cast_nullable_to_non_nullable
as String,pageCount: null == pageCount ? _self.pageCount : pageCount // ignore: cast_nullable_to_non_nullable
as int,pages: null == pages ? _self.pages : pages // ignore: cast_nullable_to_non_nullable
as List<MedicalDocumentPageSummaryItem>,
  ));
}

}


/// Adds pattern-matching-related methods to [MedicalDocumentPageSummary].
extension MedicalDocumentPageSummaryPatterns on MedicalDocumentPageSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MedicalDocumentPageSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MedicalDocumentPageSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MedicalDocumentPageSummary value)  $default,){
final _that = this;
switch (_that) {
case _MedicalDocumentPageSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MedicalDocumentPageSummary value)?  $default,){
final _that = this;
switch (_that) {
case _MedicalDocumentPageSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String documentUuid,  int pageCount,  List<MedicalDocumentPageSummaryItem> pages)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MedicalDocumentPageSummary() when $default != null:
return $default(_that.documentUuid,_that.pageCount,_that.pages);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String documentUuid,  int pageCount,  List<MedicalDocumentPageSummaryItem> pages)  $default,) {final _that = this;
switch (_that) {
case _MedicalDocumentPageSummary():
return $default(_that.documentUuid,_that.pageCount,_that.pages);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String documentUuid,  int pageCount,  List<MedicalDocumentPageSummaryItem> pages)?  $default,) {final _that = this;
switch (_that) {
case _MedicalDocumentPageSummary() when $default != null:
return $default(_that.documentUuid,_that.pageCount,_that.pages);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _MedicalDocumentPageSummary implements MedicalDocumentPageSummary {
  const _MedicalDocumentPageSummary({required this.documentUuid, this.pageCount = 0, final  List<MedicalDocumentPageSummaryItem> pages = const <MedicalDocumentPageSummaryItem>[]}): _pages = pages;
  factory _MedicalDocumentPageSummary.fromJson(Map<String, dynamic> json) => _$MedicalDocumentPageSummaryFromJson(json);

@override final  String documentUuid;
@override@JsonKey() final  int pageCount;
 final  List<MedicalDocumentPageSummaryItem> _pages;
@override@JsonKey() List<MedicalDocumentPageSummaryItem> get pages {
  if (_pages is EqualUnmodifiableListView) return _pages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_pages);
}


/// Create a copy of MedicalDocumentPageSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MedicalDocumentPageSummaryCopyWith<_MedicalDocumentPageSummary> get copyWith => __$MedicalDocumentPageSummaryCopyWithImpl<_MedicalDocumentPageSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MedicalDocumentPageSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MedicalDocumentPageSummary&&(identical(other.documentUuid, documentUuid) || other.documentUuid == documentUuid)&&(identical(other.pageCount, pageCount) || other.pageCount == pageCount)&&const DeepCollectionEquality().equals(other._pages, _pages));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,documentUuid,pageCount,const DeepCollectionEquality().hash(_pages));

@override
String toString() {
  return 'MedicalDocumentPageSummary(documentUuid: $documentUuid, pageCount: $pageCount, pages: $pages)';
}


}

/// @nodoc
abstract mixin class _$MedicalDocumentPageSummaryCopyWith<$Res> implements $MedicalDocumentPageSummaryCopyWith<$Res> {
  factory _$MedicalDocumentPageSummaryCopyWith(_MedicalDocumentPageSummary value, $Res Function(_MedicalDocumentPageSummary) _then) = __$MedicalDocumentPageSummaryCopyWithImpl;
@override @useResult
$Res call({
 String documentUuid, int pageCount, List<MedicalDocumentPageSummaryItem> pages
});




}
/// @nodoc
class __$MedicalDocumentPageSummaryCopyWithImpl<$Res>
    implements _$MedicalDocumentPageSummaryCopyWith<$Res> {
  __$MedicalDocumentPageSummaryCopyWithImpl(this._self, this._then);

  final _MedicalDocumentPageSummary _self;
  final $Res Function(_MedicalDocumentPageSummary) _then;

/// Create a copy of MedicalDocumentPageSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? documentUuid = null,Object? pageCount = null,Object? pages = null,}) {
  return _then(_MedicalDocumentPageSummary(
documentUuid: null == documentUuid ? _self.documentUuid : documentUuid // ignore: cast_nullable_to_non_nullable
as String,pageCount: null == pageCount ? _self.pageCount : pageCount // ignore: cast_nullable_to_non_nullable
as int,pages: null == pages ? _self._pages : pages // ignore: cast_nullable_to_non_nullable
as List<MedicalDocumentPageSummaryItem>,
  ));
}


}


/// @nodoc
mixin _$MedicalDocumentPageDetail {

 String get documentUuid; int get pageNumber; int get pageCount; String get reportSubtype; String get processingStatus; String get processingFailureCode; DateTime? get documentDate; bool get dateVerified; String get dateSource; int get labResultCount; List<DateCandidate> get detectedCandidates; List<LabResultItem> get labResults;
/// Create a copy of MedicalDocumentPageDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MedicalDocumentPageDetailCopyWith<MedicalDocumentPageDetail> get copyWith => _$MedicalDocumentPageDetailCopyWithImpl<MedicalDocumentPageDetail>(this as MedicalDocumentPageDetail, _$identity);

  /// Serializes this MedicalDocumentPageDetail to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MedicalDocumentPageDetail&&(identical(other.documentUuid, documentUuid) || other.documentUuid == documentUuid)&&(identical(other.pageNumber, pageNumber) || other.pageNumber == pageNumber)&&(identical(other.pageCount, pageCount) || other.pageCount == pageCount)&&(identical(other.reportSubtype, reportSubtype) || other.reportSubtype == reportSubtype)&&(identical(other.processingStatus, processingStatus) || other.processingStatus == processingStatus)&&(identical(other.processingFailureCode, processingFailureCode) || other.processingFailureCode == processingFailureCode)&&(identical(other.documentDate, documentDate) || other.documentDate == documentDate)&&(identical(other.dateVerified, dateVerified) || other.dateVerified == dateVerified)&&(identical(other.dateSource, dateSource) || other.dateSource == dateSource)&&(identical(other.labResultCount, labResultCount) || other.labResultCount == labResultCount)&&const DeepCollectionEquality().equals(other.detectedCandidates, detectedCandidates)&&const DeepCollectionEquality().equals(other.labResults, labResults));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,documentUuid,pageNumber,pageCount,reportSubtype,processingStatus,processingFailureCode,documentDate,dateVerified,dateSource,labResultCount,const DeepCollectionEquality().hash(detectedCandidates),const DeepCollectionEquality().hash(labResults));

@override
String toString() {
  return 'MedicalDocumentPageDetail(documentUuid: $documentUuid, pageNumber: $pageNumber, pageCount: $pageCount, reportSubtype: $reportSubtype, processingStatus: $processingStatus, processingFailureCode: $processingFailureCode, documentDate: $documentDate, dateVerified: $dateVerified, dateSource: $dateSource, labResultCount: $labResultCount, detectedCandidates: $detectedCandidates, labResults: $labResults)';
}


}

/// @nodoc
abstract mixin class $MedicalDocumentPageDetailCopyWith<$Res>  {
  factory $MedicalDocumentPageDetailCopyWith(MedicalDocumentPageDetail value, $Res Function(MedicalDocumentPageDetail) _then) = _$MedicalDocumentPageDetailCopyWithImpl;
@useResult
$Res call({
 String documentUuid, int pageNumber, int pageCount, String reportSubtype, String processingStatus, String processingFailureCode, DateTime? documentDate, bool dateVerified, String dateSource, int labResultCount, List<DateCandidate> detectedCandidates, List<LabResultItem> labResults
});




}
/// @nodoc
class _$MedicalDocumentPageDetailCopyWithImpl<$Res>
    implements $MedicalDocumentPageDetailCopyWith<$Res> {
  _$MedicalDocumentPageDetailCopyWithImpl(this._self, this._then);

  final MedicalDocumentPageDetail _self;
  final $Res Function(MedicalDocumentPageDetail) _then;

/// Create a copy of MedicalDocumentPageDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? documentUuid = null,Object? pageNumber = null,Object? pageCount = null,Object? reportSubtype = null,Object? processingStatus = null,Object? processingFailureCode = null,Object? documentDate = freezed,Object? dateVerified = null,Object? dateSource = null,Object? labResultCount = null,Object? detectedCandidates = null,Object? labResults = null,}) {
  return _then(_self.copyWith(
documentUuid: null == documentUuid ? _self.documentUuid : documentUuid // ignore: cast_nullable_to_non_nullable
as String,pageNumber: null == pageNumber ? _self.pageNumber : pageNumber // ignore: cast_nullable_to_non_nullable
as int,pageCount: null == pageCount ? _self.pageCount : pageCount // ignore: cast_nullable_to_non_nullable
as int,reportSubtype: null == reportSubtype ? _self.reportSubtype : reportSubtype // ignore: cast_nullable_to_non_nullable
as String,processingStatus: null == processingStatus ? _self.processingStatus : processingStatus // ignore: cast_nullable_to_non_nullable
as String,processingFailureCode: null == processingFailureCode ? _self.processingFailureCode : processingFailureCode // ignore: cast_nullable_to_non_nullable
as String,documentDate: freezed == documentDate ? _self.documentDate : documentDate // ignore: cast_nullable_to_non_nullable
as DateTime?,dateVerified: null == dateVerified ? _self.dateVerified : dateVerified // ignore: cast_nullable_to_non_nullable
as bool,dateSource: null == dateSource ? _self.dateSource : dateSource // ignore: cast_nullable_to_non_nullable
as String,labResultCount: null == labResultCount ? _self.labResultCount : labResultCount // ignore: cast_nullable_to_non_nullable
as int,detectedCandidates: null == detectedCandidates ? _self.detectedCandidates : detectedCandidates // ignore: cast_nullable_to_non_nullable
as List<DateCandidate>,labResults: null == labResults ? _self.labResults : labResults // ignore: cast_nullable_to_non_nullable
as List<LabResultItem>,
  ));
}

}


/// Adds pattern-matching-related methods to [MedicalDocumentPageDetail].
extension MedicalDocumentPageDetailPatterns on MedicalDocumentPageDetail {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MedicalDocumentPageDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MedicalDocumentPageDetail() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MedicalDocumentPageDetail value)  $default,){
final _that = this;
switch (_that) {
case _MedicalDocumentPageDetail():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MedicalDocumentPageDetail value)?  $default,){
final _that = this;
switch (_that) {
case _MedicalDocumentPageDetail() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String documentUuid,  int pageNumber,  int pageCount,  String reportSubtype,  String processingStatus,  String processingFailureCode,  DateTime? documentDate,  bool dateVerified,  String dateSource,  int labResultCount,  List<DateCandidate> detectedCandidates,  List<LabResultItem> labResults)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MedicalDocumentPageDetail() when $default != null:
return $default(_that.documentUuid,_that.pageNumber,_that.pageCount,_that.reportSubtype,_that.processingStatus,_that.processingFailureCode,_that.documentDate,_that.dateVerified,_that.dateSource,_that.labResultCount,_that.detectedCandidates,_that.labResults);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String documentUuid,  int pageNumber,  int pageCount,  String reportSubtype,  String processingStatus,  String processingFailureCode,  DateTime? documentDate,  bool dateVerified,  String dateSource,  int labResultCount,  List<DateCandidate> detectedCandidates,  List<LabResultItem> labResults)  $default,) {final _that = this;
switch (_that) {
case _MedicalDocumentPageDetail():
return $default(_that.documentUuid,_that.pageNumber,_that.pageCount,_that.reportSubtype,_that.processingStatus,_that.processingFailureCode,_that.documentDate,_that.dateVerified,_that.dateSource,_that.labResultCount,_that.detectedCandidates,_that.labResults);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String documentUuid,  int pageNumber,  int pageCount,  String reportSubtype,  String processingStatus,  String processingFailureCode,  DateTime? documentDate,  bool dateVerified,  String dateSource,  int labResultCount,  List<DateCandidate> detectedCandidates,  List<LabResultItem> labResults)?  $default,) {final _that = this;
switch (_that) {
case _MedicalDocumentPageDetail() when $default != null:
return $default(_that.documentUuid,_that.pageNumber,_that.pageCount,_that.reportSubtype,_that.processingStatus,_that.processingFailureCode,_that.documentDate,_that.dateVerified,_that.dateSource,_that.labResultCount,_that.detectedCandidates,_that.labResults);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _MedicalDocumentPageDetail implements MedicalDocumentPageDetail {
  const _MedicalDocumentPageDetail({required this.documentUuid, required this.pageNumber, this.pageCount = 0, this.reportSubtype = ReportSubtype.unknown, this.processingStatus = '', this.processingFailureCode = '', this.documentDate, this.dateVerified = false, this.dateSource = '', this.labResultCount = 0, final  List<DateCandidate> detectedCandidates = const <DateCandidate>[], final  List<LabResultItem> labResults = const <LabResultItem>[]}): _detectedCandidates = detectedCandidates,_labResults = labResults;
  factory _MedicalDocumentPageDetail.fromJson(Map<String, dynamic> json) => _$MedicalDocumentPageDetailFromJson(json);

@override final  String documentUuid;
@override final  int pageNumber;
@override@JsonKey() final  int pageCount;
@override@JsonKey() final  String reportSubtype;
@override@JsonKey() final  String processingStatus;
@override@JsonKey() final  String processingFailureCode;
@override final  DateTime? documentDate;
@override@JsonKey() final  bool dateVerified;
@override@JsonKey() final  String dateSource;
@override@JsonKey() final  int labResultCount;
 final  List<DateCandidate> _detectedCandidates;
@override@JsonKey() List<DateCandidate> get detectedCandidates {
  if (_detectedCandidates is EqualUnmodifiableListView) return _detectedCandidates;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_detectedCandidates);
}

 final  List<LabResultItem> _labResults;
@override@JsonKey() List<LabResultItem> get labResults {
  if (_labResults is EqualUnmodifiableListView) return _labResults;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_labResults);
}


/// Create a copy of MedicalDocumentPageDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MedicalDocumentPageDetailCopyWith<_MedicalDocumentPageDetail> get copyWith => __$MedicalDocumentPageDetailCopyWithImpl<_MedicalDocumentPageDetail>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MedicalDocumentPageDetailToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MedicalDocumentPageDetail&&(identical(other.documentUuid, documentUuid) || other.documentUuid == documentUuid)&&(identical(other.pageNumber, pageNumber) || other.pageNumber == pageNumber)&&(identical(other.pageCount, pageCount) || other.pageCount == pageCount)&&(identical(other.reportSubtype, reportSubtype) || other.reportSubtype == reportSubtype)&&(identical(other.processingStatus, processingStatus) || other.processingStatus == processingStatus)&&(identical(other.processingFailureCode, processingFailureCode) || other.processingFailureCode == processingFailureCode)&&(identical(other.documentDate, documentDate) || other.documentDate == documentDate)&&(identical(other.dateVerified, dateVerified) || other.dateVerified == dateVerified)&&(identical(other.dateSource, dateSource) || other.dateSource == dateSource)&&(identical(other.labResultCount, labResultCount) || other.labResultCount == labResultCount)&&const DeepCollectionEquality().equals(other._detectedCandidates, _detectedCandidates)&&const DeepCollectionEquality().equals(other._labResults, _labResults));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,documentUuid,pageNumber,pageCount,reportSubtype,processingStatus,processingFailureCode,documentDate,dateVerified,dateSource,labResultCount,const DeepCollectionEquality().hash(_detectedCandidates),const DeepCollectionEquality().hash(_labResults));

@override
String toString() {
  return 'MedicalDocumentPageDetail(documentUuid: $documentUuid, pageNumber: $pageNumber, pageCount: $pageCount, reportSubtype: $reportSubtype, processingStatus: $processingStatus, processingFailureCode: $processingFailureCode, documentDate: $documentDate, dateVerified: $dateVerified, dateSource: $dateSource, labResultCount: $labResultCount, detectedCandidates: $detectedCandidates, labResults: $labResults)';
}


}

/// @nodoc
abstract mixin class _$MedicalDocumentPageDetailCopyWith<$Res> implements $MedicalDocumentPageDetailCopyWith<$Res> {
  factory _$MedicalDocumentPageDetailCopyWith(_MedicalDocumentPageDetail value, $Res Function(_MedicalDocumentPageDetail) _then) = __$MedicalDocumentPageDetailCopyWithImpl;
@override @useResult
$Res call({
 String documentUuid, int pageNumber, int pageCount, String reportSubtype, String processingStatus, String processingFailureCode, DateTime? documentDate, bool dateVerified, String dateSource, int labResultCount, List<DateCandidate> detectedCandidates, List<LabResultItem> labResults
});




}
/// @nodoc
class __$MedicalDocumentPageDetailCopyWithImpl<$Res>
    implements _$MedicalDocumentPageDetailCopyWith<$Res> {
  __$MedicalDocumentPageDetailCopyWithImpl(this._self, this._then);

  final _MedicalDocumentPageDetail _self;
  final $Res Function(_MedicalDocumentPageDetail) _then;

/// Create a copy of MedicalDocumentPageDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? documentUuid = null,Object? pageNumber = null,Object? pageCount = null,Object? reportSubtype = null,Object? processingStatus = null,Object? processingFailureCode = null,Object? documentDate = freezed,Object? dateVerified = null,Object? dateSource = null,Object? labResultCount = null,Object? detectedCandidates = null,Object? labResults = null,}) {
  return _then(_MedicalDocumentPageDetail(
documentUuid: null == documentUuid ? _self.documentUuid : documentUuid // ignore: cast_nullable_to_non_nullable
as String,pageNumber: null == pageNumber ? _self.pageNumber : pageNumber // ignore: cast_nullable_to_non_nullable
as int,pageCount: null == pageCount ? _self.pageCount : pageCount // ignore: cast_nullable_to_non_nullable
as int,reportSubtype: null == reportSubtype ? _self.reportSubtype : reportSubtype // ignore: cast_nullable_to_non_nullable
as String,processingStatus: null == processingStatus ? _self.processingStatus : processingStatus // ignore: cast_nullable_to_non_nullable
as String,processingFailureCode: null == processingFailureCode ? _self.processingFailureCode : processingFailureCode // ignore: cast_nullable_to_non_nullable
as String,documentDate: freezed == documentDate ? _self.documentDate : documentDate // ignore: cast_nullable_to_non_nullable
as DateTime?,dateVerified: null == dateVerified ? _self.dateVerified : dateVerified // ignore: cast_nullable_to_non_nullable
as bool,dateSource: null == dateSource ? _self.dateSource : dateSource // ignore: cast_nullable_to_non_nullable
as String,labResultCount: null == labResultCount ? _self.labResultCount : labResultCount // ignore: cast_nullable_to_non_nullable
as int,detectedCandidates: null == detectedCandidates ? _self._detectedCandidates : detectedCandidates // ignore: cast_nullable_to_non_nullable
as List<DateCandidate>,labResults: null == labResults ? _self._labResults : labResults // ignore: cast_nullable_to_non_nullable
as List<LabResultItem>,
  ));
}


}


/// @nodoc
mixin _$MedicalDocumentPageLabResults {

 String get documentUuid; int get pageNumber; String get extractionStatus; int get resultCount; List<LabResultItem> get results;
/// Create a copy of MedicalDocumentPageLabResults
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MedicalDocumentPageLabResultsCopyWith<MedicalDocumentPageLabResults> get copyWith => _$MedicalDocumentPageLabResultsCopyWithImpl<MedicalDocumentPageLabResults>(this as MedicalDocumentPageLabResults, _$identity);

  /// Serializes this MedicalDocumentPageLabResults to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MedicalDocumentPageLabResults&&(identical(other.documentUuid, documentUuid) || other.documentUuid == documentUuid)&&(identical(other.pageNumber, pageNumber) || other.pageNumber == pageNumber)&&(identical(other.extractionStatus, extractionStatus) || other.extractionStatus == extractionStatus)&&(identical(other.resultCount, resultCount) || other.resultCount == resultCount)&&const DeepCollectionEquality().equals(other.results, results));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,documentUuid,pageNumber,extractionStatus,resultCount,const DeepCollectionEquality().hash(results));

@override
String toString() {
  return 'MedicalDocumentPageLabResults(documentUuid: $documentUuid, pageNumber: $pageNumber, extractionStatus: $extractionStatus, resultCount: $resultCount, results: $results)';
}


}

/// @nodoc
abstract mixin class $MedicalDocumentPageLabResultsCopyWith<$Res>  {
  factory $MedicalDocumentPageLabResultsCopyWith(MedicalDocumentPageLabResults value, $Res Function(MedicalDocumentPageLabResults) _then) = _$MedicalDocumentPageLabResultsCopyWithImpl;
@useResult
$Res call({
 String documentUuid, int pageNumber, String extractionStatus, int resultCount, List<LabResultItem> results
});




}
/// @nodoc
class _$MedicalDocumentPageLabResultsCopyWithImpl<$Res>
    implements $MedicalDocumentPageLabResultsCopyWith<$Res> {
  _$MedicalDocumentPageLabResultsCopyWithImpl(this._self, this._then);

  final MedicalDocumentPageLabResults _self;
  final $Res Function(MedicalDocumentPageLabResults) _then;

/// Create a copy of MedicalDocumentPageLabResults
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? documentUuid = null,Object? pageNumber = null,Object? extractionStatus = null,Object? resultCount = null,Object? results = null,}) {
  return _then(_self.copyWith(
documentUuid: null == documentUuid ? _self.documentUuid : documentUuid // ignore: cast_nullable_to_non_nullable
as String,pageNumber: null == pageNumber ? _self.pageNumber : pageNumber // ignore: cast_nullable_to_non_nullable
as int,extractionStatus: null == extractionStatus ? _self.extractionStatus : extractionStatus // ignore: cast_nullable_to_non_nullable
as String,resultCount: null == resultCount ? _self.resultCount : resultCount // ignore: cast_nullable_to_non_nullable
as int,results: null == results ? _self.results : results // ignore: cast_nullable_to_non_nullable
as List<LabResultItem>,
  ));
}

}


/// Adds pattern-matching-related methods to [MedicalDocumentPageLabResults].
extension MedicalDocumentPageLabResultsPatterns on MedicalDocumentPageLabResults {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MedicalDocumentPageLabResults value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MedicalDocumentPageLabResults() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MedicalDocumentPageLabResults value)  $default,){
final _that = this;
switch (_that) {
case _MedicalDocumentPageLabResults():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MedicalDocumentPageLabResults value)?  $default,){
final _that = this;
switch (_that) {
case _MedicalDocumentPageLabResults() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String documentUuid,  int pageNumber,  String extractionStatus,  int resultCount,  List<LabResultItem> results)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MedicalDocumentPageLabResults() when $default != null:
return $default(_that.documentUuid,_that.pageNumber,_that.extractionStatus,_that.resultCount,_that.results);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String documentUuid,  int pageNumber,  String extractionStatus,  int resultCount,  List<LabResultItem> results)  $default,) {final _that = this;
switch (_that) {
case _MedicalDocumentPageLabResults():
return $default(_that.documentUuid,_that.pageNumber,_that.extractionStatus,_that.resultCount,_that.results);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String documentUuid,  int pageNumber,  String extractionStatus,  int resultCount,  List<LabResultItem> results)?  $default,) {final _that = this;
switch (_that) {
case _MedicalDocumentPageLabResults() when $default != null:
return $default(_that.documentUuid,_that.pageNumber,_that.extractionStatus,_that.resultCount,_that.results);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _MedicalDocumentPageLabResults implements MedicalDocumentPageLabResults {
  const _MedicalDocumentPageLabResults({required this.documentUuid, required this.pageNumber, this.extractionStatus = '', this.resultCount = 0, final  List<LabResultItem> results = const <LabResultItem>[]}): _results = results;
  factory _MedicalDocumentPageLabResults.fromJson(Map<String, dynamic> json) => _$MedicalDocumentPageLabResultsFromJson(json);

@override final  String documentUuid;
@override final  int pageNumber;
@override@JsonKey() final  String extractionStatus;
@override@JsonKey() final  int resultCount;
 final  List<LabResultItem> _results;
@override@JsonKey() List<LabResultItem> get results {
  if (_results is EqualUnmodifiableListView) return _results;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_results);
}


/// Create a copy of MedicalDocumentPageLabResults
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MedicalDocumentPageLabResultsCopyWith<_MedicalDocumentPageLabResults> get copyWith => __$MedicalDocumentPageLabResultsCopyWithImpl<_MedicalDocumentPageLabResults>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MedicalDocumentPageLabResultsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MedicalDocumentPageLabResults&&(identical(other.documentUuid, documentUuid) || other.documentUuid == documentUuid)&&(identical(other.pageNumber, pageNumber) || other.pageNumber == pageNumber)&&(identical(other.extractionStatus, extractionStatus) || other.extractionStatus == extractionStatus)&&(identical(other.resultCount, resultCount) || other.resultCount == resultCount)&&const DeepCollectionEquality().equals(other._results, _results));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,documentUuid,pageNumber,extractionStatus,resultCount,const DeepCollectionEquality().hash(_results));

@override
String toString() {
  return 'MedicalDocumentPageLabResults(documentUuid: $documentUuid, pageNumber: $pageNumber, extractionStatus: $extractionStatus, resultCount: $resultCount, results: $results)';
}


}

/// @nodoc
abstract mixin class _$MedicalDocumentPageLabResultsCopyWith<$Res> implements $MedicalDocumentPageLabResultsCopyWith<$Res> {
  factory _$MedicalDocumentPageLabResultsCopyWith(_MedicalDocumentPageLabResults value, $Res Function(_MedicalDocumentPageLabResults) _then) = __$MedicalDocumentPageLabResultsCopyWithImpl;
@override @useResult
$Res call({
 String documentUuid, int pageNumber, String extractionStatus, int resultCount, List<LabResultItem> results
});




}
/// @nodoc
class __$MedicalDocumentPageLabResultsCopyWithImpl<$Res>
    implements _$MedicalDocumentPageLabResultsCopyWith<$Res> {
  __$MedicalDocumentPageLabResultsCopyWithImpl(this._self, this._then);

  final _MedicalDocumentPageLabResults _self;
  final $Res Function(_MedicalDocumentPageLabResults) _then;

/// Create a copy of MedicalDocumentPageLabResults
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? documentUuid = null,Object? pageNumber = null,Object? extractionStatus = null,Object? resultCount = null,Object? results = null,}) {
  return _then(_MedicalDocumentPageLabResults(
documentUuid: null == documentUuid ? _self.documentUuid : documentUuid // ignore: cast_nullable_to_non_nullable
as String,pageNumber: null == pageNumber ? _self.pageNumber : pageNumber // ignore: cast_nullable_to_non_nullable
as int,extractionStatus: null == extractionStatus ? _self.extractionStatus : extractionStatus // ignore: cast_nullable_to_non_nullable
as String,resultCount: null == resultCount ? _self.resultCount : resultCount // ignore: cast_nullable_to_non_nullable
as int,results: null == results ? _self._results : results // ignore: cast_nullable_to_non_nullable
as List<LabResultItem>,
  ));
}


}

// dart format on
