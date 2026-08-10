// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'archive.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ArchiveFacilitySummary {

 String? get uuid; String get name;
/// Create a copy of ArchiveFacilitySummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ArchiveFacilitySummaryCopyWith<ArchiveFacilitySummary> get copyWith => _$ArchiveFacilitySummaryCopyWithImpl<ArchiveFacilitySummary>(this as ArchiveFacilitySummary, _$identity);

  /// Serializes this ArchiveFacilitySummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ArchiveFacilitySummary&&(identical(other.uuid, uuid) || other.uuid == uuid)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uuid,name);

@override
String toString() {
  return 'ArchiveFacilitySummary(uuid: $uuid, name: $name)';
}


}

/// @nodoc
abstract mixin class $ArchiveFacilitySummaryCopyWith<$Res>  {
  factory $ArchiveFacilitySummaryCopyWith(ArchiveFacilitySummary value, $Res Function(ArchiveFacilitySummary) _then) = _$ArchiveFacilitySummaryCopyWithImpl;
@useResult
$Res call({
 String? uuid, String name
});




}
/// @nodoc
class _$ArchiveFacilitySummaryCopyWithImpl<$Res>
    implements $ArchiveFacilitySummaryCopyWith<$Res> {
  _$ArchiveFacilitySummaryCopyWithImpl(this._self, this._then);

  final ArchiveFacilitySummary _self;
  final $Res Function(ArchiveFacilitySummary) _then;

/// Create a copy of ArchiveFacilitySummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? uuid = freezed,Object? name = null,}) {
  return _then(_self.copyWith(
uuid: freezed == uuid ? _self.uuid : uuid // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ArchiveFacilitySummary].
extension ArchiveFacilitySummaryPatterns on ArchiveFacilitySummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ArchiveFacilitySummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ArchiveFacilitySummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ArchiveFacilitySummary value)  $default,){
final _that = this;
switch (_that) {
case _ArchiveFacilitySummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ArchiveFacilitySummary value)?  $default,){
final _that = this;
switch (_that) {
case _ArchiveFacilitySummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? uuid,  String name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ArchiveFacilitySummary() when $default != null:
return $default(_that.uuid,_that.name);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? uuid,  String name)  $default,) {final _that = this;
switch (_that) {
case _ArchiveFacilitySummary():
return $default(_that.uuid,_that.name);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? uuid,  String name)?  $default,) {final _that = this;
switch (_that) {
case _ArchiveFacilitySummary() when $default != null:
return $default(_that.uuid,_that.name);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ArchiveFacilitySummary implements ArchiveFacilitySummary {
  const _ArchiveFacilitySummary({this.uuid, this.name = ''});
  factory _ArchiveFacilitySummary.fromJson(Map<String, dynamic> json) => _$ArchiveFacilitySummaryFromJson(json);

@override final  String? uuid;
@override@JsonKey() final  String name;

/// Create a copy of ArchiveFacilitySummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ArchiveFacilitySummaryCopyWith<_ArchiveFacilitySummary> get copyWith => __$ArchiveFacilitySummaryCopyWithImpl<_ArchiveFacilitySummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ArchiveFacilitySummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ArchiveFacilitySummary&&(identical(other.uuid, uuid) || other.uuid == uuid)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uuid,name);

@override
String toString() {
  return 'ArchiveFacilitySummary(uuid: $uuid, name: $name)';
}


}

/// @nodoc
abstract mixin class _$ArchiveFacilitySummaryCopyWith<$Res> implements $ArchiveFacilitySummaryCopyWith<$Res> {
  factory _$ArchiveFacilitySummaryCopyWith(_ArchiveFacilitySummary value, $Res Function(_ArchiveFacilitySummary) _then) = __$ArchiveFacilitySummaryCopyWithImpl;
@override @useResult
$Res call({
 String? uuid, String name
});




}
/// @nodoc
class __$ArchiveFacilitySummaryCopyWithImpl<$Res>
    implements _$ArchiveFacilitySummaryCopyWith<$Res> {
  __$ArchiveFacilitySummaryCopyWithImpl(this._self, this._then);

  final _ArchiveFacilitySummary _self;
  final $Res Function(_ArchiveFacilitySummary) _then;

/// Create a copy of ArchiveFacilitySummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? uuid = freezed,Object? name = null,}) {
  return _then(_ArchiveFacilitySummary(
uuid: freezed == uuid ? _self.uuid : uuid // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$ArchiveDocument {

 String get uuid; String get title;@JsonKey(fromJson: medicalDocumentTypeFromJson) MedicalDocumentType get documentType; DateTime? get documentDate; bool get dateVerified;@JsonKey(fromJson: dateSourceFromJson) DateSource get dateSource; ArchiveFacilitySummary? get healthcareFacility; String get facilityName; String get locationText; String get department; String get physicianName;@JsonKey(fromJson: processingStatusFromJson) ProcessingStatus get processingStatus; DateTime? get createdAt;
/// Create a copy of ArchiveDocument
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ArchiveDocumentCopyWith<ArchiveDocument> get copyWith => _$ArchiveDocumentCopyWithImpl<ArchiveDocument>(this as ArchiveDocument, _$identity);

  /// Serializes this ArchiveDocument to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ArchiveDocument&&(identical(other.uuid, uuid) || other.uuid == uuid)&&(identical(other.title, title) || other.title == title)&&(identical(other.documentType, documentType) || other.documentType == documentType)&&(identical(other.documentDate, documentDate) || other.documentDate == documentDate)&&(identical(other.dateVerified, dateVerified) || other.dateVerified == dateVerified)&&(identical(other.dateSource, dateSource) || other.dateSource == dateSource)&&(identical(other.healthcareFacility, healthcareFacility) || other.healthcareFacility == healthcareFacility)&&(identical(other.facilityName, facilityName) || other.facilityName == facilityName)&&(identical(other.locationText, locationText) || other.locationText == locationText)&&(identical(other.department, department) || other.department == department)&&(identical(other.physicianName, physicianName) || other.physicianName == physicianName)&&(identical(other.processingStatus, processingStatus) || other.processingStatus == processingStatus)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uuid,title,documentType,documentDate,dateVerified,dateSource,healthcareFacility,facilityName,locationText,department,physicianName,processingStatus,createdAt);

@override
String toString() {
  return 'ArchiveDocument(uuid: $uuid, title: $title, documentType: $documentType, documentDate: $documentDate, dateVerified: $dateVerified, dateSource: $dateSource, healthcareFacility: $healthcareFacility, facilityName: $facilityName, locationText: $locationText, department: $department, physicianName: $physicianName, processingStatus: $processingStatus, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $ArchiveDocumentCopyWith<$Res>  {
  factory $ArchiveDocumentCopyWith(ArchiveDocument value, $Res Function(ArchiveDocument) _then) = _$ArchiveDocumentCopyWithImpl;
@useResult
$Res call({
 String uuid, String title,@JsonKey(fromJson: medicalDocumentTypeFromJson) MedicalDocumentType documentType, DateTime? documentDate, bool dateVerified,@JsonKey(fromJson: dateSourceFromJson) DateSource dateSource, ArchiveFacilitySummary? healthcareFacility, String facilityName, String locationText, String department, String physicianName,@JsonKey(fromJson: processingStatusFromJson) ProcessingStatus processingStatus, DateTime? createdAt
});


$ArchiveFacilitySummaryCopyWith<$Res>? get healthcareFacility;

}
/// @nodoc
class _$ArchiveDocumentCopyWithImpl<$Res>
    implements $ArchiveDocumentCopyWith<$Res> {
  _$ArchiveDocumentCopyWithImpl(this._self, this._then);

  final ArchiveDocument _self;
  final $Res Function(ArchiveDocument) _then;

/// Create a copy of ArchiveDocument
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? uuid = null,Object? title = null,Object? documentType = null,Object? documentDate = freezed,Object? dateVerified = null,Object? dateSource = null,Object? healthcareFacility = freezed,Object? facilityName = null,Object? locationText = null,Object? department = null,Object? physicianName = null,Object? processingStatus = null,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
uuid: null == uuid ? _self.uuid : uuid // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,documentType: null == documentType ? _self.documentType : documentType // ignore: cast_nullable_to_non_nullable
as MedicalDocumentType,documentDate: freezed == documentDate ? _self.documentDate : documentDate // ignore: cast_nullable_to_non_nullable
as DateTime?,dateVerified: null == dateVerified ? _self.dateVerified : dateVerified // ignore: cast_nullable_to_non_nullable
as bool,dateSource: null == dateSource ? _self.dateSource : dateSource // ignore: cast_nullable_to_non_nullable
as DateSource,healthcareFacility: freezed == healthcareFacility ? _self.healthcareFacility : healthcareFacility // ignore: cast_nullable_to_non_nullable
as ArchiveFacilitySummary?,facilityName: null == facilityName ? _self.facilityName : facilityName // ignore: cast_nullable_to_non_nullable
as String,locationText: null == locationText ? _self.locationText : locationText // ignore: cast_nullable_to_non_nullable
as String,department: null == department ? _self.department : department // ignore: cast_nullable_to_non_nullable
as String,physicianName: null == physicianName ? _self.physicianName : physicianName // ignore: cast_nullable_to_non_nullable
as String,processingStatus: null == processingStatus ? _self.processingStatus : processingStatus // ignore: cast_nullable_to_non_nullable
as ProcessingStatus,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of ArchiveDocument
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ArchiveFacilitySummaryCopyWith<$Res>? get healthcareFacility {
    if (_self.healthcareFacility == null) {
    return null;
  }

  return $ArchiveFacilitySummaryCopyWith<$Res>(_self.healthcareFacility!, (value) {
    return _then(_self.copyWith(healthcareFacility: value));
  });
}
}


/// Adds pattern-matching-related methods to [ArchiveDocument].
extension ArchiveDocumentPatterns on ArchiveDocument {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ArchiveDocument value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ArchiveDocument() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ArchiveDocument value)  $default,){
final _that = this;
switch (_that) {
case _ArchiveDocument():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ArchiveDocument value)?  $default,){
final _that = this;
switch (_that) {
case _ArchiveDocument() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String uuid,  String title, @JsonKey(fromJson: medicalDocumentTypeFromJson)  MedicalDocumentType documentType,  DateTime? documentDate,  bool dateVerified, @JsonKey(fromJson: dateSourceFromJson)  DateSource dateSource,  ArchiveFacilitySummary? healthcareFacility,  String facilityName,  String locationText,  String department,  String physicianName, @JsonKey(fromJson: processingStatusFromJson)  ProcessingStatus processingStatus,  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ArchiveDocument() when $default != null:
return $default(_that.uuid,_that.title,_that.documentType,_that.documentDate,_that.dateVerified,_that.dateSource,_that.healthcareFacility,_that.facilityName,_that.locationText,_that.department,_that.physicianName,_that.processingStatus,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String uuid,  String title, @JsonKey(fromJson: medicalDocumentTypeFromJson)  MedicalDocumentType documentType,  DateTime? documentDate,  bool dateVerified, @JsonKey(fromJson: dateSourceFromJson)  DateSource dateSource,  ArchiveFacilitySummary? healthcareFacility,  String facilityName,  String locationText,  String department,  String physicianName, @JsonKey(fromJson: processingStatusFromJson)  ProcessingStatus processingStatus,  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _ArchiveDocument():
return $default(_that.uuid,_that.title,_that.documentType,_that.documentDate,_that.dateVerified,_that.dateSource,_that.healthcareFacility,_that.facilityName,_that.locationText,_that.department,_that.physicianName,_that.processingStatus,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String uuid,  String title, @JsonKey(fromJson: medicalDocumentTypeFromJson)  MedicalDocumentType documentType,  DateTime? documentDate,  bool dateVerified, @JsonKey(fromJson: dateSourceFromJson)  DateSource dateSource,  ArchiveFacilitySummary? healthcareFacility,  String facilityName,  String locationText,  String department,  String physicianName, @JsonKey(fromJson: processingStatusFromJson)  ProcessingStatus processingStatus,  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _ArchiveDocument() when $default != null:
return $default(_that.uuid,_that.title,_that.documentType,_that.documentDate,_that.dateVerified,_that.dateSource,_that.healthcareFacility,_that.facilityName,_that.locationText,_that.department,_that.physicianName,_that.processingStatus,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ArchiveDocument implements ArchiveDocument {
  const _ArchiveDocument({required this.uuid, this.title = '', @JsonKey(fromJson: medicalDocumentTypeFromJson) this.documentType = MedicalDocumentType.unknown, this.documentDate, this.dateVerified = false, @JsonKey(fromJson: dateSourceFromJson) this.dateSource = DateSource.unknown, this.healthcareFacility, this.facilityName = '', this.locationText = '', this.department = '', this.physicianName = '', @JsonKey(fromJson: processingStatusFromJson) this.processingStatus = ProcessingStatus.unknown, this.createdAt});
  factory _ArchiveDocument.fromJson(Map<String, dynamic> json) => _$ArchiveDocumentFromJson(json);

@override final  String uuid;
@override@JsonKey() final  String title;
@override@JsonKey(fromJson: medicalDocumentTypeFromJson) final  MedicalDocumentType documentType;
@override final  DateTime? documentDate;
@override@JsonKey() final  bool dateVerified;
@override@JsonKey(fromJson: dateSourceFromJson) final  DateSource dateSource;
@override final  ArchiveFacilitySummary? healthcareFacility;
@override@JsonKey() final  String facilityName;
@override@JsonKey() final  String locationText;
@override@JsonKey() final  String department;
@override@JsonKey() final  String physicianName;
@override@JsonKey(fromJson: processingStatusFromJson) final  ProcessingStatus processingStatus;
@override final  DateTime? createdAt;

/// Create a copy of ArchiveDocument
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ArchiveDocumentCopyWith<_ArchiveDocument> get copyWith => __$ArchiveDocumentCopyWithImpl<_ArchiveDocument>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ArchiveDocumentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ArchiveDocument&&(identical(other.uuid, uuid) || other.uuid == uuid)&&(identical(other.title, title) || other.title == title)&&(identical(other.documentType, documentType) || other.documentType == documentType)&&(identical(other.documentDate, documentDate) || other.documentDate == documentDate)&&(identical(other.dateVerified, dateVerified) || other.dateVerified == dateVerified)&&(identical(other.dateSource, dateSource) || other.dateSource == dateSource)&&(identical(other.healthcareFacility, healthcareFacility) || other.healthcareFacility == healthcareFacility)&&(identical(other.facilityName, facilityName) || other.facilityName == facilityName)&&(identical(other.locationText, locationText) || other.locationText == locationText)&&(identical(other.department, department) || other.department == department)&&(identical(other.physicianName, physicianName) || other.physicianName == physicianName)&&(identical(other.processingStatus, processingStatus) || other.processingStatus == processingStatus)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uuid,title,documentType,documentDate,dateVerified,dateSource,healthcareFacility,facilityName,locationText,department,physicianName,processingStatus,createdAt);

@override
String toString() {
  return 'ArchiveDocument(uuid: $uuid, title: $title, documentType: $documentType, documentDate: $documentDate, dateVerified: $dateVerified, dateSource: $dateSource, healthcareFacility: $healthcareFacility, facilityName: $facilityName, locationText: $locationText, department: $department, physicianName: $physicianName, processingStatus: $processingStatus, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$ArchiveDocumentCopyWith<$Res> implements $ArchiveDocumentCopyWith<$Res> {
  factory _$ArchiveDocumentCopyWith(_ArchiveDocument value, $Res Function(_ArchiveDocument) _then) = __$ArchiveDocumentCopyWithImpl;
@override @useResult
$Res call({
 String uuid, String title,@JsonKey(fromJson: medicalDocumentTypeFromJson) MedicalDocumentType documentType, DateTime? documentDate, bool dateVerified,@JsonKey(fromJson: dateSourceFromJson) DateSource dateSource, ArchiveFacilitySummary? healthcareFacility, String facilityName, String locationText, String department, String physicianName,@JsonKey(fromJson: processingStatusFromJson) ProcessingStatus processingStatus, DateTime? createdAt
});


@override $ArchiveFacilitySummaryCopyWith<$Res>? get healthcareFacility;

}
/// @nodoc
class __$ArchiveDocumentCopyWithImpl<$Res>
    implements _$ArchiveDocumentCopyWith<$Res> {
  __$ArchiveDocumentCopyWithImpl(this._self, this._then);

  final _ArchiveDocument _self;
  final $Res Function(_ArchiveDocument) _then;

/// Create a copy of ArchiveDocument
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? uuid = null,Object? title = null,Object? documentType = null,Object? documentDate = freezed,Object? dateVerified = null,Object? dateSource = null,Object? healthcareFacility = freezed,Object? facilityName = null,Object? locationText = null,Object? department = null,Object? physicianName = null,Object? processingStatus = null,Object? createdAt = freezed,}) {
  return _then(_ArchiveDocument(
uuid: null == uuid ? _self.uuid : uuid // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,documentType: null == documentType ? _self.documentType : documentType // ignore: cast_nullable_to_non_nullable
as MedicalDocumentType,documentDate: freezed == documentDate ? _self.documentDate : documentDate // ignore: cast_nullable_to_non_nullable
as DateTime?,dateVerified: null == dateVerified ? _self.dateVerified : dateVerified // ignore: cast_nullable_to_non_nullable
as bool,dateSource: null == dateSource ? _self.dateSource : dateSource // ignore: cast_nullable_to_non_nullable
as DateSource,healthcareFacility: freezed == healthcareFacility ? _self.healthcareFacility : healthcareFacility // ignore: cast_nullable_to_non_nullable
as ArchiveFacilitySummary?,facilityName: null == facilityName ? _self.facilityName : facilityName // ignore: cast_nullable_to_non_nullable
as String,locationText: null == locationText ? _self.locationText : locationText // ignore: cast_nullable_to_non_nullable
as String,department: null == department ? _self.department : department // ignore: cast_nullable_to_non_nullable
as String,physicianName: null == physicianName ? _self.physicianName : physicianName // ignore: cast_nullable_to_non_nullable
as String,processingStatus: null == processingStatus ? _self.processingStatus : processingStatus // ignore: cast_nullable_to_non_nullable
as ProcessingStatus,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of ArchiveDocument
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ArchiveFacilitySummaryCopyWith<$Res>? get healthcareFacility {
    if (_self.healthcareFacility == null) {
    return null;
  }

  return $ArchiveFacilitySummaryCopyWith<$Res>(_self.healthcareFacility!, (value) {
    return _then(_self.copyWith(healthcareFacility: value));
  });
}
}


/// @nodoc
mixin _$ArchiveSummaryMonth {

 int get month; int get count;
/// Create a copy of ArchiveSummaryMonth
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ArchiveSummaryMonthCopyWith<ArchiveSummaryMonth> get copyWith => _$ArchiveSummaryMonthCopyWithImpl<ArchiveSummaryMonth>(this as ArchiveSummaryMonth, _$identity);

  /// Serializes this ArchiveSummaryMonth to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ArchiveSummaryMonth&&(identical(other.month, month) || other.month == month)&&(identical(other.count, count) || other.count == count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,month,count);

@override
String toString() {
  return 'ArchiveSummaryMonth(month: $month, count: $count)';
}


}

/// @nodoc
abstract mixin class $ArchiveSummaryMonthCopyWith<$Res>  {
  factory $ArchiveSummaryMonthCopyWith(ArchiveSummaryMonth value, $Res Function(ArchiveSummaryMonth) _then) = _$ArchiveSummaryMonthCopyWithImpl;
@useResult
$Res call({
 int month, int count
});




}
/// @nodoc
class _$ArchiveSummaryMonthCopyWithImpl<$Res>
    implements $ArchiveSummaryMonthCopyWith<$Res> {
  _$ArchiveSummaryMonthCopyWithImpl(this._self, this._then);

  final ArchiveSummaryMonth _self;
  final $Res Function(ArchiveSummaryMonth) _then;

/// Create a copy of ArchiveSummaryMonth
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? month = null,Object? count = null,}) {
  return _then(_self.copyWith(
month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as int,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ArchiveSummaryMonth].
extension ArchiveSummaryMonthPatterns on ArchiveSummaryMonth {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ArchiveSummaryMonth value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ArchiveSummaryMonth() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ArchiveSummaryMonth value)  $default,){
final _that = this;
switch (_that) {
case _ArchiveSummaryMonth():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ArchiveSummaryMonth value)?  $default,){
final _that = this;
switch (_that) {
case _ArchiveSummaryMonth() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int month,  int count)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ArchiveSummaryMonth() when $default != null:
return $default(_that.month,_that.count);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int month,  int count)  $default,) {final _that = this;
switch (_that) {
case _ArchiveSummaryMonth():
return $default(_that.month,_that.count);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int month,  int count)?  $default,) {final _that = this;
switch (_that) {
case _ArchiveSummaryMonth() when $default != null:
return $default(_that.month,_that.count);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ArchiveSummaryMonth implements ArchiveSummaryMonth {
  const _ArchiveSummaryMonth({this.month = 0, this.count = 0});
  factory _ArchiveSummaryMonth.fromJson(Map<String, dynamic> json) => _$ArchiveSummaryMonthFromJson(json);

@override@JsonKey() final  int month;
@override@JsonKey() final  int count;

/// Create a copy of ArchiveSummaryMonth
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ArchiveSummaryMonthCopyWith<_ArchiveSummaryMonth> get copyWith => __$ArchiveSummaryMonthCopyWithImpl<_ArchiveSummaryMonth>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ArchiveSummaryMonthToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ArchiveSummaryMonth&&(identical(other.month, month) || other.month == month)&&(identical(other.count, count) || other.count == count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,month,count);

@override
String toString() {
  return 'ArchiveSummaryMonth(month: $month, count: $count)';
}


}

/// @nodoc
abstract mixin class _$ArchiveSummaryMonthCopyWith<$Res> implements $ArchiveSummaryMonthCopyWith<$Res> {
  factory _$ArchiveSummaryMonthCopyWith(_ArchiveSummaryMonth value, $Res Function(_ArchiveSummaryMonth) _then) = __$ArchiveSummaryMonthCopyWithImpl;
@override @useResult
$Res call({
 int month, int count
});




}
/// @nodoc
class __$ArchiveSummaryMonthCopyWithImpl<$Res>
    implements _$ArchiveSummaryMonthCopyWith<$Res> {
  __$ArchiveSummaryMonthCopyWithImpl(this._self, this._then);

  final _ArchiveSummaryMonth _self;
  final $Res Function(_ArchiveSummaryMonth) _then;

/// Create a copy of ArchiveSummaryMonth
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? month = null,Object? count = null,}) {
  return _then(_ArchiveSummaryMonth(
month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as int,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$ArchiveSummaryYear {

 int get year; int get count; List<ArchiveSummaryMonth> get months;
/// Create a copy of ArchiveSummaryYear
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ArchiveSummaryYearCopyWith<ArchiveSummaryYear> get copyWith => _$ArchiveSummaryYearCopyWithImpl<ArchiveSummaryYear>(this as ArchiveSummaryYear, _$identity);

  /// Serializes this ArchiveSummaryYear to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ArchiveSummaryYear&&(identical(other.year, year) || other.year == year)&&(identical(other.count, count) || other.count == count)&&const DeepCollectionEquality().equals(other.months, months));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,year,count,const DeepCollectionEquality().hash(months));

@override
String toString() {
  return 'ArchiveSummaryYear(year: $year, count: $count, months: $months)';
}


}

/// @nodoc
abstract mixin class $ArchiveSummaryYearCopyWith<$Res>  {
  factory $ArchiveSummaryYearCopyWith(ArchiveSummaryYear value, $Res Function(ArchiveSummaryYear) _then) = _$ArchiveSummaryYearCopyWithImpl;
@useResult
$Res call({
 int year, int count, List<ArchiveSummaryMonth> months
});




}
/// @nodoc
class _$ArchiveSummaryYearCopyWithImpl<$Res>
    implements $ArchiveSummaryYearCopyWith<$Res> {
  _$ArchiveSummaryYearCopyWithImpl(this._self, this._then);

  final ArchiveSummaryYear _self;
  final $Res Function(ArchiveSummaryYear) _then;

/// Create a copy of ArchiveSummaryYear
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? year = null,Object? count = null,Object? months = null,}) {
  return _then(_self.copyWith(
year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,months: null == months ? _self.months : months // ignore: cast_nullable_to_non_nullable
as List<ArchiveSummaryMonth>,
  ));
}

}


/// Adds pattern-matching-related methods to [ArchiveSummaryYear].
extension ArchiveSummaryYearPatterns on ArchiveSummaryYear {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ArchiveSummaryYear value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ArchiveSummaryYear() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ArchiveSummaryYear value)  $default,){
final _that = this;
switch (_that) {
case _ArchiveSummaryYear():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ArchiveSummaryYear value)?  $default,){
final _that = this;
switch (_that) {
case _ArchiveSummaryYear() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int year,  int count,  List<ArchiveSummaryMonth> months)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ArchiveSummaryYear() when $default != null:
return $default(_that.year,_that.count,_that.months);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int year,  int count,  List<ArchiveSummaryMonth> months)  $default,) {final _that = this;
switch (_that) {
case _ArchiveSummaryYear():
return $default(_that.year,_that.count,_that.months);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int year,  int count,  List<ArchiveSummaryMonth> months)?  $default,) {final _that = this;
switch (_that) {
case _ArchiveSummaryYear() when $default != null:
return $default(_that.year,_that.count,_that.months);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ArchiveSummaryYear implements ArchiveSummaryYear {
  const _ArchiveSummaryYear({this.year = 0, this.count = 0, final  List<ArchiveSummaryMonth> months = const <ArchiveSummaryMonth>[]}): _months = months;
  factory _ArchiveSummaryYear.fromJson(Map<String, dynamic> json) => _$ArchiveSummaryYearFromJson(json);

@override@JsonKey() final  int year;
@override@JsonKey() final  int count;
 final  List<ArchiveSummaryMonth> _months;
@override@JsonKey() List<ArchiveSummaryMonth> get months {
  if (_months is EqualUnmodifiableListView) return _months;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_months);
}


/// Create a copy of ArchiveSummaryYear
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ArchiveSummaryYearCopyWith<_ArchiveSummaryYear> get copyWith => __$ArchiveSummaryYearCopyWithImpl<_ArchiveSummaryYear>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ArchiveSummaryYearToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ArchiveSummaryYear&&(identical(other.year, year) || other.year == year)&&(identical(other.count, count) || other.count == count)&&const DeepCollectionEquality().equals(other._months, _months));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,year,count,const DeepCollectionEquality().hash(_months));

@override
String toString() {
  return 'ArchiveSummaryYear(year: $year, count: $count, months: $months)';
}


}

/// @nodoc
abstract mixin class _$ArchiveSummaryYearCopyWith<$Res> implements $ArchiveSummaryYearCopyWith<$Res> {
  factory _$ArchiveSummaryYearCopyWith(_ArchiveSummaryYear value, $Res Function(_ArchiveSummaryYear) _then) = __$ArchiveSummaryYearCopyWithImpl;
@override @useResult
$Res call({
 int year, int count, List<ArchiveSummaryMonth> months
});




}
/// @nodoc
class __$ArchiveSummaryYearCopyWithImpl<$Res>
    implements _$ArchiveSummaryYearCopyWith<$Res> {
  __$ArchiveSummaryYearCopyWithImpl(this._self, this._then);

  final _ArchiveSummaryYear _self;
  final $Res Function(_ArchiveSummaryYear) _then;

/// Create a copy of ArchiveSummaryYear
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? year = null,Object? count = null,Object? months = null,}) {
  return _then(_ArchiveSummaryYear(
year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,months: null == months ? _self._months : months // ignore: cast_nullable_to_non_nullable
as List<ArchiveSummaryMonth>,
  ));
}


}


/// @nodoc
mixin _$ArchiveSummaryDocumentType {

@JsonKey(fromJson: medicalDocumentTypeFromJson) MedicalDocumentType get documentType; int get count;
/// Create a copy of ArchiveSummaryDocumentType
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ArchiveSummaryDocumentTypeCopyWith<ArchiveSummaryDocumentType> get copyWith => _$ArchiveSummaryDocumentTypeCopyWithImpl<ArchiveSummaryDocumentType>(this as ArchiveSummaryDocumentType, _$identity);

  /// Serializes this ArchiveSummaryDocumentType to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ArchiveSummaryDocumentType&&(identical(other.documentType, documentType) || other.documentType == documentType)&&(identical(other.count, count) || other.count == count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,documentType,count);

@override
String toString() {
  return 'ArchiveSummaryDocumentType(documentType: $documentType, count: $count)';
}


}

/// @nodoc
abstract mixin class $ArchiveSummaryDocumentTypeCopyWith<$Res>  {
  factory $ArchiveSummaryDocumentTypeCopyWith(ArchiveSummaryDocumentType value, $Res Function(ArchiveSummaryDocumentType) _then) = _$ArchiveSummaryDocumentTypeCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: medicalDocumentTypeFromJson) MedicalDocumentType documentType, int count
});




}
/// @nodoc
class _$ArchiveSummaryDocumentTypeCopyWithImpl<$Res>
    implements $ArchiveSummaryDocumentTypeCopyWith<$Res> {
  _$ArchiveSummaryDocumentTypeCopyWithImpl(this._self, this._then);

  final ArchiveSummaryDocumentType _self;
  final $Res Function(ArchiveSummaryDocumentType) _then;

/// Create a copy of ArchiveSummaryDocumentType
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? documentType = null,Object? count = null,}) {
  return _then(_self.copyWith(
documentType: null == documentType ? _self.documentType : documentType // ignore: cast_nullable_to_non_nullable
as MedicalDocumentType,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ArchiveSummaryDocumentType].
extension ArchiveSummaryDocumentTypePatterns on ArchiveSummaryDocumentType {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ArchiveSummaryDocumentType value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ArchiveSummaryDocumentType() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ArchiveSummaryDocumentType value)  $default,){
final _that = this;
switch (_that) {
case _ArchiveSummaryDocumentType():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ArchiveSummaryDocumentType value)?  $default,){
final _that = this;
switch (_that) {
case _ArchiveSummaryDocumentType() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: medicalDocumentTypeFromJson)  MedicalDocumentType documentType,  int count)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ArchiveSummaryDocumentType() when $default != null:
return $default(_that.documentType,_that.count);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: medicalDocumentTypeFromJson)  MedicalDocumentType documentType,  int count)  $default,) {final _that = this;
switch (_that) {
case _ArchiveSummaryDocumentType():
return $default(_that.documentType,_that.count);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: medicalDocumentTypeFromJson)  MedicalDocumentType documentType,  int count)?  $default,) {final _that = this;
switch (_that) {
case _ArchiveSummaryDocumentType() when $default != null:
return $default(_that.documentType,_that.count);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ArchiveSummaryDocumentType implements ArchiveSummaryDocumentType {
  const _ArchiveSummaryDocumentType({@JsonKey(fromJson: medicalDocumentTypeFromJson) this.documentType = MedicalDocumentType.unknown, this.count = 0});
  factory _ArchiveSummaryDocumentType.fromJson(Map<String, dynamic> json) => _$ArchiveSummaryDocumentTypeFromJson(json);

@override@JsonKey(fromJson: medicalDocumentTypeFromJson) final  MedicalDocumentType documentType;
@override@JsonKey() final  int count;

/// Create a copy of ArchiveSummaryDocumentType
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ArchiveSummaryDocumentTypeCopyWith<_ArchiveSummaryDocumentType> get copyWith => __$ArchiveSummaryDocumentTypeCopyWithImpl<_ArchiveSummaryDocumentType>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ArchiveSummaryDocumentTypeToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ArchiveSummaryDocumentType&&(identical(other.documentType, documentType) || other.documentType == documentType)&&(identical(other.count, count) || other.count == count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,documentType,count);

@override
String toString() {
  return 'ArchiveSummaryDocumentType(documentType: $documentType, count: $count)';
}


}

/// @nodoc
abstract mixin class _$ArchiveSummaryDocumentTypeCopyWith<$Res> implements $ArchiveSummaryDocumentTypeCopyWith<$Res> {
  factory _$ArchiveSummaryDocumentTypeCopyWith(_ArchiveSummaryDocumentType value, $Res Function(_ArchiveSummaryDocumentType) _then) = __$ArchiveSummaryDocumentTypeCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: medicalDocumentTypeFromJson) MedicalDocumentType documentType, int count
});




}
/// @nodoc
class __$ArchiveSummaryDocumentTypeCopyWithImpl<$Res>
    implements _$ArchiveSummaryDocumentTypeCopyWith<$Res> {
  __$ArchiveSummaryDocumentTypeCopyWithImpl(this._self, this._then);

  final _ArchiveSummaryDocumentType _self;
  final $Res Function(_ArchiveSummaryDocumentType) _then;

/// Create a copy of ArchiveSummaryDocumentType
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? documentType = null,Object? count = null,}) {
  return _then(_ArchiveSummaryDocumentType(
documentType: null == documentType ? _self.documentType : documentType // ignore: cast_nullable_to_non_nullable
as MedicalDocumentType,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$ArchiveSummaryFacility {

 String? get uuid; String get name; int get count;
/// Create a copy of ArchiveSummaryFacility
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ArchiveSummaryFacilityCopyWith<ArchiveSummaryFacility> get copyWith => _$ArchiveSummaryFacilityCopyWithImpl<ArchiveSummaryFacility>(this as ArchiveSummaryFacility, _$identity);

  /// Serializes this ArchiveSummaryFacility to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ArchiveSummaryFacility&&(identical(other.uuid, uuid) || other.uuid == uuid)&&(identical(other.name, name) || other.name == name)&&(identical(other.count, count) || other.count == count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uuid,name,count);

@override
String toString() {
  return 'ArchiveSummaryFacility(uuid: $uuid, name: $name, count: $count)';
}


}

/// @nodoc
abstract mixin class $ArchiveSummaryFacilityCopyWith<$Res>  {
  factory $ArchiveSummaryFacilityCopyWith(ArchiveSummaryFacility value, $Res Function(ArchiveSummaryFacility) _then) = _$ArchiveSummaryFacilityCopyWithImpl;
@useResult
$Res call({
 String? uuid, String name, int count
});




}
/// @nodoc
class _$ArchiveSummaryFacilityCopyWithImpl<$Res>
    implements $ArchiveSummaryFacilityCopyWith<$Res> {
  _$ArchiveSummaryFacilityCopyWithImpl(this._self, this._then);

  final ArchiveSummaryFacility _self;
  final $Res Function(ArchiveSummaryFacility) _then;

/// Create a copy of ArchiveSummaryFacility
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? uuid = freezed,Object? name = null,Object? count = null,}) {
  return _then(_self.copyWith(
uuid: freezed == uuid ? _self.uuid : uuid // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ArchiveSummaryFacility].
extension ArchiveSummaryFacilityPatterns on ArchiveSummaryFacility {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ArchiveSummaryFacility value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ArchiveSummaryFacility() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ArchiveSummaryFacility value)  $default,){
final _that = this;
switch (_that) {
case _ArchiveSummaryFacility():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ArchiveSummaryFacility value)?  $default,){
final _that = this;
switch (_that) {
case _ArchiveSummaryFacility() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? uuid,  String name,  int count)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ArchiveSummaryFacility() when $default != null:
return $default(_that.uuid,_that.name,_that.count);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? uuid,  String name,  int count)  $default,) {final _that = this;
switch (_that) {
case _ArchiveSummaryFacility():
return $default(_that.uuid,_that.name,_that.count);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? uuid,  String name,  int count)?  $default,) {final _that = this;
switch (_that) {
case _ArchiveSummaryFacility() when $default != null:
return $default(_that.uuid,_that.name,_that.count);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ArchiveSummaryFacility implements ArchiveSummaryFacility {
  const _ArchiveSummaryFacility({this.uuid, this.name = '', this.count = 0});
  factory _ArchiveSummaryFacility.fromJson(Map<String, dynamic> json) => _$ArchiveSummaryFacilityFromJson(json);

@override final  String? uuid;
@override@JsonKey() final  String name;
@override@JsonKey() final  int count;

/// Create a copy of ArchiveSummaryFacility
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ArchiveSummaryFacilityCopyWith<_ArchiveSummaryFacility> get copyWith => __$ArchiveSummaryFacilityCopyWithImpl<_ArchiveSummaryFacility>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ArchiveSummaryFacilityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ArchiveSummaryFacility&&(identical(other.uuid, uuid) || other.uuid == uuid)&&(identical(other.name, name) || other.name == name)&&(identical(other.count, count) || other.count == count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uuid,name,count);

@override
String toString() {
  return 'ArchiveSummaryFacility(uuid: $uuid, name: $name, count: $count)';
}


}

/// @nodoc
abstract mixin class _$ArchiveSummaryFacilityCopyWith<$Res> implements $ArchiveSummaryFacilityCopyWith<$Res> {
  factory _$ArchiveSummaryFacilityCopyWith(_ArchiveSummaryFacility value, $Res Function(_ArchiveSummaryFacility) _then) = __$ArchiveSummaryFacilityCopyWithImpl;
@override @useResult
$Res call({
 String? uuid, String name, int count
});




}
/// @nodoc
class __$ArchiveSummaryFacilityCopyWithImpl<$Res>
    implements _$ArchiveSummaryFacilityCopyWith<$Res> {
  __$ArchiveSummaryFacilityCopyWithImpl(this._self, this._then);

  final _ArchiveSummaryFacility _self;
  final $Res Function(_ArchiveSummaryFacility) _then;

/// Create a copy of ArchiveSummaryFacility
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? uuid = freezed,Object? name = null,Object? count = null,}) {
  return _then(_ArchiveSummaryFacility(
uuid: freezed == uuid ? _self.uuid : uuid // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$ArchiveSummary {

 List<ArchiveSummaryYear> get years; List<ArchiveSummaryDocumentType> get documentTypes; List<ArchiveSummaryFacility> get facilities; int get unconfirmedDateCount;
/// Create a copy of ArchiveSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ArchiveSummaryCopyWith<ArchiveSummary> get copyWith => _$ArchiveSummaryCopyWithImpl<ArchiveSummary>(this as ArchiveSummary, _$identity);

  /// Serializes this ArchiveSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ArchiveSummary&&const DeepCollectionEquality().equals(other.years, years)&&const DeepCollectionEquality().equals(other.documentTypes, documentTypes)&&const DeepCollectionEquality().equals(other.facilities, facilities)&&(identical(other.unconfirmedDateCount, unconfirmedDateCount) || other.unconfirmedDateCount == unconfirmedDateCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(years),const DeepCollectionEquality().hash(documentTypes),const DeepCollectionEquality().hash(facilities),unconfirmedDateCount);

@override
String toString() {
  return 'ArchiveSummary(years: $years, documentTypes: $documentTypes, facilities: $facilities, unconfirmedDateCount: $unconfirmedDateCount)';
}


}

/// @nodoc
abstract mixin class $ArchiveSummaryCopyWith<$Res>  {
  factory $ArchiveSummaryCopyWith(ArchiveSummary value, $Res Function(ArchiveSummary) _then) = _$ArchiveSummaryCopyWithImpl;
@useResult
$Res call({
 List<ArchiveSummaryYear> years, List<ArchiveSummaryDocumentType> documentTypes, List<ArchiveSummaryFacility> facilities, int unconfirmedDateCount
});




}
/// @nodoc
class _$ArchiveSummaryCopyWithImpl<$Res>
    implements $ArchiveSummaryCopyWith<$Res> {
  _$ArchiveSummaryCopyWithImpl(this._self, this._then);

  final ArchiveSummary _self;
  final $Res Function(ArchiveSummary) _then;

/// Create a copy of ArchiveSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? years = null,Object? documentTypes = null,Object? facilities = null,Object? unconfirmedDateCount = null,}) {
  return _then(_self.copyWith(
years: null == years ? _self.years : years // ignore: cast_nullable_to_non_nullable
as List<ArchiveSummaryYear>,documentTypes: null == documentTypes ? _self.documentTypes : documentTypes // ignore: cast_nullable_to_non_nullable
as List<ArchiveSummaryDocumentType>,facilities: null == facilities ? _self.facilities : facilities // ignore: cast_nullable_to_non_nullable
as List<ArchiveSummaryFacility>,unconfirmedDateCount: null == unconfirmedDateCount ? _self.unconfirmedDateCount : unconfirmedDateCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ArchiveSummary].
extension ArchiveSummaryPatterns on ArchiveSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ArchiveSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ArchiveSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ArchiveSummary value)  $default,){
final _that = this;
switch (_that) {
case _ArchiveSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ArchiveSummary value)?  $default,){
final _that = this;
switch (_that) {
case _ArchiveSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<ArchiveSummaryYear> years,  List<ArchiveSummaryDocumentType> documentTypes,  List<ArchiveSummaryFacility> facilities,  int unconfirmedDateCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ArchiveSummary() when $default != null:
return $default(_that.years,_that.documentTypes,_that.facilities,_that.unconfirmedDateCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<ArchiveSummaryYear> years,  List<ArchiveSummaryDocumentType> documentTypes,  List<ArchiveSummaryFacility> facilities,  int unconfirmedDateCount)  $default,) {final _that = this;
switch (_that) {
case _ArchiveSummary():
return $default(_that.years,_that.documentTypes,_that.facilities,_that.unconfirmedDateCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<ArchiveSummaryYear> years,  List<ArchiveSummaryDocumentType> documentTypes,  List<ArchiveSummaryFacility> facilities,  int unconfirmedDateCount)?  $default,) {final _that = this;
switch (_that) {
case _ArchiveSummary() when $default != null:
return $default(_that.years,_that.documentTypes,_that.facilities,_that.unconfirmedDateCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ArchiveSummary implements ArchiveSummary {
  const _ArchiveSummary({final  List<ArchiveSummaryYear> years = const <ArchiveSummaryYear>[], final  List<ArchiveSummaryDocumentType> documentTypes = const <ArchiveSummaryDocumentType>[], final  List<ArchiveSummaryFacility> facilities = const <ArchiveSummaryFacility>[], this.unconfirmedDateCount = 0}): _years = years,_documentTypes = documentTypes,_facilities = facilities;
  factory _ArchiveSummary.fromJson(Map<String, dynamic> json) => _$ArchiveSummaryFromJson(json);

 final  List<ArchiveSummaryYear> _years;
@override@JsonKey() List<ArchiveSummaryYear> get years {
  if (_years is EqualUnmodifiableListView) return _years;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_years);
}

 final  List<ArchiveSummaryDocumentType> _documentTypes;
@override@JsonKey() List<ArchiveSummaryDocumentType> get documentTypes {
  if (_documentTypes is EqualUnmodifiableListView) return _documentTypes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_documentTypes);
}

 final  List<ArchiveSummaryFacility> _facilities;
@override@JsonKey() List<ArchiveSummaryFacility> get facilities {
  if (_facilities is EqualUnmodifiableListView) return _facilities;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_facilities);
}

@override@JsonKey() final  int unconfirmedDateCount;

/// Create a copy of ArchiveSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ArchiveSummaryCopyWith<_ArchiveSummary> get copyWith => __$ArchiveSummaryCopyWithImpl<_ArchiveSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ArchiveSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ArchiveSummary&&const DeepCollectionEquality().equals(other._years, _years)&&const DeepCollectionEquality().equals(other._documentTypes, _documentTypes)&&const DeepCollectionEquality().equals(other._facilities, _facilities)&&(identical(other.unconfirmedDateCount, unconfirmedDateCount) || other.unconfirmedDateCount == unconfirmedDateCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_years),const DeepCollectionEquality().hash(_documentTypes),const DeepCollectionEquality().hash(_facilities),unconfirmedDateCount);

@override
String toString() {
  return 'ArchiveSummary(years: $years, documentTypes: $documentTypes, facilities: $facilities, unconfirmedDateCount: $unconfirmedDateCount)';
}


}

/// @nodoc
abstract mixin class _$ArchiveSummaryCopyWith<$Res> implements $ArchiveSummaryCopyWith<$Res> {
  factory _$ArchiveSummaryCopyWith(_ArchiveSummary value, $Res Function(_ArchiveSummary) _then) = __$ArchiveSummaryCopyWithImpl;
@override @useResult
$Res call({
 List<ArchiveSummaryYear> years, List<ArchiveSummaryDocumentType> documentTypes, List<ArchiveSummaryFacility> facilities, int unconfirmedDateCount
});




}
/// @nodoc
class __$ArchiveSummaryCopyWithImpl<$Res>
    implements _$ArchiveSummaryCopyWith<$Res> {
  __$ArchiveSummaryCopyWithImpl(this._self, this._then);

  final _ArchiveSummary _self;
  final $Res Function(_ArchiveSummary) _then;

/// Create a copy of ArchiveSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? years = null,Object? documentTypes = null,Object? facilities = null,Object? unconfirmedDateCount = null,}) {
  return _then(_ArchiveSummary(
years: null == years ? _self._years : years // ignore: cast_nullable_to_non_nullable
as List<ArchiveSummaryYear>,documentTypes: null == documentTypes ? _self._documentTypes : documentTypes // ignore: cast_nullable_to_non_nullable
as List<ArchiveSummaryDocumentType>,facilities: null == facilities ? _self._facilities : facilities // ignore: cast_nullable_to_non_nullable
as List<ArchiveSummaryFacility>,unconfirmedDateCount: null == unconfirmedDateCount ? _self.unconfirmedDateCount : unconfirmedDateCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
