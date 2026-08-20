// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'medical_document.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StoredFilePublic {

 String get originalFilename; String get mimeType; int get sizeBytes; int? get pageCount;@JsonKey(fromJson: integrityStatusFromJson) IntegrityStatus get integrityStatus;@JsonKey(fromJson: malwareScanStatusFromJson) MalwareScanStatus get malwareScanStatus;
/// Create a copy of StoredFilePublic
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StoredFilePublicCopyWith<StoredFilePublic> get copyWith => _$StoredFilePublicCopyWithImpl<StoredFilePublic>(this as StoredFilePublic, _$identity);

  /// Serializes this StoredFilePublic to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StoredFilePublic&&(identical(other.originalFilename, originalFilename) || other.originalFilename == originalFilename)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType)&&(identical(other.sizeBytes, sizeBytes) || other.sizeBytes == sizeBytes)&&(identical(other.pageCount, pageCount) || other.pageCount == pageCount)&&(identical(other.integrityStatus, integrityStatus) || other.integrityStatus == integrityStatus)&&(identical(other.malwareScanStatus, malwareScanStatus) || other.malwareScanStatus == malwareScanStatus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,originalFilename,mimeType,sizeBytes,pageCount,integrityStatus,malwareScanStatus);

@override
String toString() {
  return 'StoredFilePublic(originalFilename: $originalFilename, mimeType: $mimeType, sizeBytes: $sizeBytes, pageCount: $pageCount, integrityStatus: $integrityStatus, malwareScanStatus: $malwareScanStatus)';
}


}

/// @nodoc
abstract mixin class $StoredFilePublicCopyWith<$Res>  {
  factory $StoredFilePublicCopyWith(StoredFilePublic value, $Res Function(StoredFilePublic) _then) = _$StoredFilePublicCopyWithImpl;
@useResult
$Res call({
 String originalFilename, String mimeType, int sizeBytes, int? pageCount,@JsonKey(fromJson: integrityStatusFromJson) IntegrityStatus integrityStatus,@JsonKey(fromJson: malwareScanStatusFromJson) MalwareScanStatus malwareScanStatus
});




}
/// @nodoc
class _$StoredFilePublicCopyWithImpl<$Res>
    implements $StoredFilePublicCopyWith<$Res> {
  _$StoredFilePublicCopyWithImpl(this._self, this._then);

  final StoredFilePublic _self;
  final $Res Function(StoredFilePublic) _then;

/// Create a copy of StoredFilePublic
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? originalFilename = null,Object? mimeType = null,Object? sizeBytes = null,Object? pageCount = freezed,Object? integrityStatus = null,Object? malwareScanStatus = null,}) {
  return _then(_self.copyWith(
originalFilename: null == originalFilename ? _self.originalFilename : originalFilename // ignore: cast_nullable_to_non_nullable
as String,mimeType: null == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String,sizeBytes: null == sizeBytes ? _self.sizeBytes : sizeBytes // ignore: cast_nullable_to_non_nullable
as int,pageCount: freezed == pageCount ? _self.pageCount : pageCount // ignore: cast_nullable_to_non_nullable
as int?,integrityStatus: null == integrityStatus ? _self.integrityStatus : integrityStatus // ignore: cast_nullable_to_non_nullable
as IntegrityStatus,malwareScanStatus: null == malwareScanStatus ? _self.malwareScanStatus : malwareScanStatus // ignore: cast_nullable_to_non_nullable
as MalwareScanStatus,
  ));
}

}


/// Adds pattern-matching-related methods to [StoredFilePublic].
extension StoredFilePublicPatterns on StoredFilePublic {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StoredFilePublic value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StoredFilePublic() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StoredFilePublic value)  $default,){
final _that = this;
switch (_that) {
case _StoredFilePublic():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StoredFilePublic value)?  $default,){
final _that = this;
switch (_that) {
case _StoredFilePublic() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String originalFilename,  String mimeType,  int sizeBytes,  int? pageCount, @JsonKey(fromJson: integrityStatusFromJson)  IntegrityStatus integrityStatus, @JsonKey(fromJson: malwareScanStatusFromJson)  MalwareScanStatus malwareScanStatus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StoredFilePublic() when $default != null:
return $default(_that.originalFilename,_that.mimeType,_that.sizeBytes,_that.pageCount,_that.integrityStatus,_that.malwareScanStatus);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String originalFilename,  String mimeType,  int sizeBytes,  int? pageCount, @JsonKey(fromJson: integrityStatusFromJson)  IntegrityStatus integrityStatus, @JsonKey(fromJson: malwareScanStatusFromJson)  MalwareScanStatus malwareScanStatus)  $default,) {final _that = this;
switch (_that) {
case _StoredFilePublic():
return $default(_that.originalFilename,_that.mimeType,_that.sizeBytes,_that.pageCount,_that.integrityStatus,_that.malwareScanStatus);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String originalFilename,  String mimeType,  int sizeBytes,  int? pageCount, @JsonKey(fromJson: integrityStatusFromJson)  IntegrityStatus integrityStatus, @JsonKey(fromJson: malwareScanStatusFromJson)  MalwareScanStatus malwareScanStatus)?  $default,) {final _that = this;
switch (_that) {
case _StoredFilePublic() when $default != null:
return $default(_that.originalFilename,_that.mimeType,_that.sizeBytes,_that.pageCount,_that.integrityStatus,_that.malwareScanStatus);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _StoredFilePublic implements StoredFilePublic {
  const _StoredFilePublic({this.originalFilename = '', this.mimeType = '', this.sizeBytes = 0, this.pageCount, @JsonKey(fromJson: integrityStatusFromJson) this.integrityStatus = IntegrityStatus.unknown, @JsonKey(fromJson: malwareScanStatusFromJson) this.malwareScanStatus = MalwareScanStatus.unknown});
  factory _StoredFilePublic.fromJson(Map<String, dynamic> json) => _$StoredFilePublicFromJson(json);

@override@JsonKey() final  String originalFilename;
@override@JsonKey() final  String mimeType;
@override@JsonKey() final  int sizeBytes;
@override final  int? pageCount;
@override@JsonKey(fromJson: integrityStatusFromJson) final  IntegrityStatus integrityStatus;
@override@JsonKey(fromJson: malwareScanStatusFromJson) final  MalwareScanStatus malwareScanStatus;

/// Create a copy of StoredFilePublic
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StoredFilePublicCopyWith<_StoredFilePublic> get copyWith => __$StoredFilePublicCopyWithImpl<_StoredFilePublic>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StoredFilePublicToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StoredFilePublic&&(identical(other.originalFilename, originalFilename) || other.originalFilename == originalFilename)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType)&&(identical(other.sizeBytes, sizeBytes) || other.sizeBytes == sizeBytes)&&(identical(other.pageCount, pageCount) || other.pageCount == pageCount)&&(identical(other.integrityStatus, integrityStatus) || other.integrityStatus == integrityStatus)&&(identical(other.malwareScanStatus, malwareScanStatus) || other.malwareScanStatus == malwareScanStatus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,originalFilename,mimeType,sizeBytes,pageCount,integrityStatus,malwareScanStatus);

@override
String toString() {
  return 'StoredFilePublic(originalFilename: $originalFilename, mimeType: $mimeType, sizeBytes: $sizeBytes, pageCount: $pageCount, integrityStatus: $integrityStatus, malwareScanStatus: $malwareScanStatus)';
}


}

/// @nodoc
abstract mixin class _$StoredFilePublicCopyWith<$Res> implements $StoredFilePublicCopyWith<$Res> {
  factory _$StoredFilePublicCopyWith(_StoredFilePublic value, $Res Function(_StoredFilePublic) _then) = __$StoredFilePublicCopyWithImpl;
@override @useResult
$Res call({
 String originalFilename, String mimeType, int sizeBytes, int? pageCount,@JsonKey(fromJson: integrityStatusFromJson) IntegrityStatus integrityStatus,@JsonKey(fromJson: malwareScanStatusFromJson) MalwareScanStatus malwareScanStatus
});




}
/// @nodoc
class __$StoredFilePublicCopyWithImpl<$Res>
    implements _$StoredFilePublicCopyWith<$Res> {
  __$StoredFilePublicCopyWithImpl(this._self, this._then);

  final _StoredFilePublic _self;
  final $Res Function(_StoredFilePublic) _then;

/// Create a copy of StoredFilePublic
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? originalFilename = null,Object? mimeType = null,Object? sizeBytes = null,Object? pageCount = freezed,Object? integrityStatus = null,Object? malwareScanStatus = null,}) {
  return _then(_StoredFilePublic(
originalFilename: null == originalFilename ? _self.originalFilename : originalFilename // ignore: cast_nullable_to_non_nullable
as String,mimeType: null == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String,sizeBytes: null == sizeBytes ? _self.sizeBytes : sizeBytes // ignore: cast_nullable_to_non_nullable
as int,pageCount: freezed == pageCount ? _self.pageCount : pageCount // ignore: cast_nullable_to_non_nullable
as int?,integrityStatus: null == integrityStatus ? _self.integrityStatus : integrityStatus // ignore: cast_nullable_to_non_nullable
as IntegrityStatus,malwareScanStatus: null == malwareScanStatus ? _self.malwareScanStatus : malwareScanStatus // ignore: cast_nullable_to_non_nullable
as MalwareScanStatus,
  ));
}


}


/// @nodoc
mixin _$MedicalDocument {

 String get uuid;@JsonKey(fromJson: medicalDocumentTypeFromJson) MedicalDocumentType get documentType;@JsonKey(fromJson: classificationSourceFromJson) ClassificationSource get classificationSource; String get title; String get description; DateTime? get documentDate;@JsonKey(fromJson: dateSourceFromJson) DateSource get dateSource; bool get dateVerified; DateTime? get dateVerifiedAt; String get facilityName; HealthcareFacility? get healthcareFacility; String get locationText; String get department; String get physicianName;@JsonKey(fromJson: processingStatusFromJson) ProcessingStatus get processingStatus;@JsonKey(fromJson: archiveStatusFromJson) ArchiveStatus get archiveStatus; StoredFilePublic? get file; DateTime? get createdAt; DateTime? get updatedAt;
/// Create a copy of MedicalDocument
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MedicalDocumentCopyWith<MedicalDocument> get copyWith => _$MedicalDocumentCopyWithImpl<MedicalDocument>(this as MedicalDocument, _$identity);

  /// Serializes this MedicalDocument to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MedicalDocument&&(identical(other.uuid, uuid) || other.uuid == uuid)&&(identical(other.documentType, documentType) || other.documentType == documentType)&&(identical(other.classificationSource, classificationSource) || other.classificationSource == classificationSource)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.documentDate, documentDate) || other.documentDate == documentDate)&&(identical(other.dateSource, dateSource) || other.dateSource == dateSource)&&(identical(other.dateVerified, dateVerified) || other.dateVerified == dateVerified)&&(identical(other.dateVerifiedAt, dateVerifiedAt) || other.dateVerifiedAt == dateVerifiedAt)&&(identical(other.facilityName, facilityName) || other.facilityName == facilityName)&&(identical(other.healthcareFacility, healthcareFacility) || other.healthcareFacility == healthcareFacility)&&(identical(other.locationText, locationText) || other.locationText == locationText)&&(identical(other.department, department) || other.department == department)&&(identical(other.physicianName, physicianName) || other.physicianName == physicianName)&&(identical(other.processingStatus, processingStatus) || other.processingStatus == processingStatus)&&(identical(other.archiveStatus, archiveStatus) || other.archiveStatus == archiveStatus)&&(identical(other.file, file) || other.file == file)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,uuid,documentType,classificationSource,title,description,documentDate,dateSource,dateVerified,dateVerifiedAt,facilityName,healthcareFacility,locationText,department,physicianName,processingStatus,archiveStatus,file,createdAt,updatedAt]);

@override
String toString() {
  return 'MedicalDocument(uuid: $uuid, documentType: $documentType, classificationSource: $classificationSource, title: $title, description: $description, documentDate: $documentDate, dateSource: $dateSource, dateVerified: $dateVerified, dateVerifiedAt: $dateVerifiedAt, facilityName: $facilityName, healthcareFacility: $healthcareFacility, locationText: $locationText, department: $department, physicianName: $physicianName, processingStatus: $processingStatus, archiveStatus: $archiveStatus, file: $file, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $MedicalDocumentCopyWith<$Res>  {
  factory $MedicalDocumentCopyWith(MedicalDocument value, $Res Function(MedicalDocument) _then) = _$MedicalDocumentCopyWithImpl;
@useResult
$Res call({
 String uuid,@JsonKey(fromJson: medicalDocumentTypeFromJson) MedicalDocumentType documentType,@JsonKey(fromJson: classificationSourceFromJson) ClassificationSource classificationSource, String title, String description, DateTime? documentDate,@JsonKey(fromJson: dateSourceFromJson) DateSource dateSource, bool dateVerified, DateTime? dateVerifiedAt, String facilityName, HealthcareFacility? healthcareFacility, String locationText, String department, String physicianName,@JsonKey(fromJson: processingStatusFromJson) ProcessingStatus processingStatus,@JsonKey(fromJson: archiveStatusFromJson) ArchiveStatus archiveStatus, StoredFilePublic? file, DateTime? createdAt, DateTime? updatedAt
});


$HealthcareFacilityCopyWith<$Res>? get healthcareFacility;$StoredFilePublicCopyWith<$Res>? get file;

}
/// @nodoc
class _$MedicalDocumentCopyWithImpl<$Res>
    implements $MedicalDocumentCopyWith<$Res> {
  _$MedicalDocumentCopyWithImpl(this._self, this._then);

  final MedicalDocument _self;
  final $Res Function(MedicalDocument) _then;

/// Create a copy of MedicalDocument
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? uuid = null,Object? documentType = null,Object? classificationSource = null,Object? title = null,Object? description = null,Object? documentDate = freezed,Object? dateSource = null,Object? dateVerified = null,Object? dateVerifiedAt = freezed,Object? facilityName = null,Object? healthcareFacility = freezed,Object? locationText = null,Object? department = null,Object? physicianName = null,Object? processingStatus = null,Object? archiveStatus = null,Object? file = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
uuid: null == uuid ? _self.uuid : uuid // ignore: cast_nullable_to_non_nullable
as String,documentType: null == documentType ? _self.documentType : documentType // ignore: cast_nullable_to_non_nullable
as MedicalDocumentType,classificationSource: null == classificationSource ? _self.classificationSource : classificationSource // ignore: cast_nullable_to_non_nullable
as ClassificationSource,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,documentDate: freezed == documentDate ? _self.documentDate : documentDate // ignore: cast_nullable_to_non_nullable
as DateTime?,dateSource: null == dateSource ? _self.dateSource : dateSource // ignore: cast_nullable_to_non_nullable
as DateSource,dateVerified: null == dateVerified ? _self.dateVerified : dateVerified // ignore: cast_nullable_to_non_nullable
as bool,dateVerifiedAt: freezed == dateVerifiedAt ? _self.dateVerifiedAt : dateVerifiedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,facilityName: null == facilityName ? _self.facilityName : facilityName // ignore: cast_nullable_to_non_nullable
as String,healthcareFacility: freezed == healthcareFacility ? _self.healthcareFacility : healthcareFacility // ignore: cast_nullable_to_non_nullable
as HealthcareFacility?,locationText: null == locationText ? _self.locationText : locationText // ignore: cast_nullable_to_non_nullable
as String,department: null == department ? _self.department : department // ignore: cast_nullable_to_non_nullable
as String,physicianName: null == physicianName ? _self.physicianName : physicianName // ignore: cast_nullable_to_non_nullable
as String,processingStatus: null == processingStatus ? _self.processingStatus : processingStatus // ignore: cast_nullable_to_non_nullable
as ProcessingStatus,archiveStatus: null == archiveStatus ? _self.archiveStatus : archiveStatus // ignore: cast_nullable_to_non_nullable
as ArchiveStatus,file: freezed == file ? _self.file : file // ignore: cast_nullable_to_non_nullable
as StoredFilePublic?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of MedicalDocument
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HealthcareFacilityCopyWith<$Res>? get healthcareFacility {
    if (_self.healthcareFacility == null) {
    return null;
  }

  return $HealthcareFacilityCopyWith<$Res>(_self.healthcareFacility!, (value) {
    return _then(_self.copyWith(healthcareFacility: value));
  });
}/// Create a copy of MedicalDocument
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StoredFilePublicCopyWith<$Res>? get file {
    if (_self.file == null) {
    return null;
  }

  return $StoredFilePublicCopyWith<$Res>(_self.file!, (value) {
    return _then(_self.copyWith(file: value));
  });
}
}


/// Adds pattern-matching-related methods to [MedicalDocument].
extension MedicalDocumentPatterns on MedicalDocument {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MedicalDocument value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MedicalDocument() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MedicalDocument value)  $default,){
final _that = this;
switch (_that) {
case _MedicalDocument():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MedicalDocument value)?  $default,){
final _that = this;
switch (_that) {
case _MedicalDocument() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String uuid, @JsonKey(fromJson: medicalDocumentTypeFromJson)  MedicalDocumentType documentType, @JsonKey(fromJson: classificationSourceFromJson)  ClassificationSource classificationSource,  String title,  String description,  DateTime? documentDate, @JsonKey(fromJson: dateSourceFromJson)  DateSource dateSource,  bool dateVerified,  DateTime? dateVerifiedAt,  String facilityName,  HealthcareFacility? healthcareFacility,  String locationText,  String department,  String physicianName, @JsonKey(fromJson: processingStatusFromJson)  ProcessingStatus processingStatus, @JsonKey(fromJson: archiveStatusFromJson)  ArchiveStatus archiveStatus,  StoredFilePublic? file,  DateTime? createdAt,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MedicalDocument() when $default != null:
return $default(_that.uuid,_that.documentType,_that.classificationSource,_that.title,_that.description,_that.documentDate,_that.dateSource,_that.dateVerified,_that.dateVerifiedAt,_that.facilityName,_that.healthcareFacility,_that.locationText,_that.department,_that.physicianName,_that.processingStatus,_that.archiveStatus,_that.file,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String uuid, @JsonKey(fromJson: medicalDocumentTypeFromJson)  MedicalDocumentType documentType, @JsonKey(fromJson: classificationSourceFromJson)  ClassificationSource classificationSource,  String title,  String description,  DateTime? documentDate, @JsonKey(fromJson: dateSourceFromJson)  DateSource dateSource,  bool dateVerified,  DateTime? dateVerifiedAt,  String facilityName,  HealthcareFacility? healthcareFacility,  String locationText,  String department,  String physicianName, @JsonKey(fromJson: processingStatusFromJson)  ProcessingStatus processingStatus, @JsonKey(fromJson: archiveStatusFromJson)  ArchiveStatus archiveStatus,  StoredFilePublic? file,  DateTime? createdAt,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _MedicalDocument():
return $default(_that.uuid,_that.documentType,_that.classificationSource,_that.title,_that.description,_that.documentDate,_that.dateSource,_that.dateVerified,_that.dateVerifiedAt,_that.facilityName,_that.healthcareFacility,_that.locationText,_that.department,_that.physicianName,_that.processingStatus,_that.archiveStatus,_that.file,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String uuid, @JsonKey(fromJson: medicalDocumentTypeFromJson)  MedicalDocumentType documentType, @JsonKey(fromJson: classificationSourceFromJson)  ClassificationSource classificationSource,  String title,  String description,  DateTime? documentDate, @JsonKey(fromJson: dateSourceFromJson)  DateSource dateSource,  bool dateVerified,  DateTime? dateVerifiedAt,  String facilityName,  HealthcareFacility? healthcareFacility,  String locationText,  String department,  String physicianName, @JsonKey(fromJson: processingStatusFromJson)  ProcessingStatus processingStatus, @JsonKey(fromJson: archiveStatusFromJson)  ArchiveStatus archiveStatus,  StoredFilePublic? file,  DateTime? createdAt,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _MedicalDocument() when $default != null:
return $default(_that.uuid,_that.documentType,_that.classificationSource,_that.title,_that.description,_that.documentDate,_that.dateSource,_that.dateVerified,_that.dateVerifiedAt,_that.facilityName,_that.healthcareFacility,_that.locationText,_that.department,_that.physicianName,_that.processingStatus,_that.archiveStatus,_that.file,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _MedicalDocument implements MedicalDocument {
  const _MedicalDocument({required this.uuid, @JsonKey(fromJson: medicalDocumentTypeFromJson) this.documentType = MedicalDocumentType.unknown, @JsonKey(fromJson: classificationSourceFromJson) this.classificationSource = ClassificationSource.unknown, this.title = '', this.description = '', this.documentDate, @JsonKey(fromJson: dateSourceFromJson) this.dateSource = DateSource.unknown, this.dateVerified = false, this.dateVerifiedAt, this.facilityName = '', this.healthcareFacility, this.locationText = '', this.department = '', this.physicianName = '', @JsonKey(fromJson: processingStatusFromJson) this.processingStatus = ProcessingStatus.unknown, @JsonKey(fromJson: archiveStatusFromJson) this.archiveStatus = ArchiveStatus.unknown, this.file, this.createdAt, this.updatedAt});
  factory _MedicalDocument.fromJson(Map<String, dynamic> json) => _$MedicalDocumentFromJson(json);

@override final  String uuid;
@override@JsonKey(fromJson: medicalDocumentTypeFromJson) final  MedicalDocumentType documentType;
@override@JsonKey(fromJson: classificationSourceFromJson) final  ClassificationSource classificationSource;
@override@JsonKey() final  String title;
@override@JsonKey() final  String description;
@override final  DateTime? documentDate;
@override@JsonKey(fromJson: dateSourceFromJson) final  DateSource dateSource;
@override@JsonKey() final  bool dateVerified;
@override final  DateTime? dateVerifiedAt;
@override@JsonKey() final  String facilityName;
@override final  HealthcareFacility? healthcareFacility;
@override@JsonKey() final  String locationText;
@override@JsonKey() final  String department;
@override@JsonKey() final  String physicianName;
@override@JsonKey(fromJson: processingStatusFromJson) final  ProcessingStatus processingStatus;
@override@JsonKey(fromJson: archiveStatusFromJson) final  ArchiveStatus archiveStatus;
@override final  StoredFilePublic? file;
@override final  DateTime? createdAt;
@override final  DateTime? updatedAt;

/// Create a copy of MedicalDocument
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MedicalDocumentCopyWith<_MedicalDocument> get copyWith => __$MedicalDocumentCopyWithImpl<_MedicalDocument>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MedicalDocumentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MedicalDocument&&(identical(other.uuid, uuid) || other.uuid == uuid)&&(identical(other.documentType, documentType) || other.documentType == documentType)&&(identical(other.classificationSource, classificationSource) || other.classificationSource == classificationSource)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.documentDate, documentDate) || other.documentDate == documentDate)&&(identical(other.dateSource, dateSource) || other.dateSource == dateSource)&&(identical(other.dateVerified, dateVerified) || other.dateVerified == dateVerified)&&(identical(other.dateVerifiedAt, dateVerifiedAt) || other.dateVerifiedAt == dateVerifiedAt)&&(identical(other.facilityName, facilityName) || other.facilityName == facilityName)&&(identical(other.healthcareFacility, healthcareFacility) || other.healthcareFacility == healthcareFacility)&&(identical(other.locationText, locationText) || other.locationText == locationText)&&(identical(other.department, department) || other.department == department)&&(identical(other.physicianName, physicianName) || other.physicianName == physicianName)&&(identical(other.processingStatus, processingStatus) || other.processingStatus == processingStatus)&&(identical(other.archiveStatus, archiveStatus) || other.archiveStatus == archiveStatus)&&(identical(other.file, file) || other.file == file)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,uuid,documentType,classificationSource,title,description,documentDate,dateSource,dateVerified,dateVerifiedAt,facilityName,healthcareFacility,locationText,department,physicianName,processingStatus,archiveStatus,file,createdAt,updatedAt]);

@override
String toString() {
  return 'MedicalDocument(uuid: $uuid, documentType: $documentType, classificationSource: $classificationSource, title: $title, description: $description, documentDate: $documentDate, dateSource: $dateSource, dateVerified: $dateVerified, dateVerifiedAt: $dateVerifiedAt, facilityName: $facilityName, healthcareFacility: $healthcareFacility, locationText: $locationText, department: $department, physicianName: $physicianName, processingStatus: $processingStatus, archiveStatus: $archiveStatus, file: $file, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$MedicalDocumentCopyWith<$Res> implements $MedicalDocumentCopyWith<$Res> {
  factory _$MedicalDocumentCopyWith(_MedicalDocument value, $Res Function(_MedicalDocument) _then) = __$MedicalDocumentCopyWithImpl;
@override @useResult
$Res call({
 String uuid,@JsonKey(fromJson: medicalDocumentTypeFromJson) MedicalDocumentType documentType,@JsonKey(fromJson: classificationSourceFromJson) ClassificationSource classificationSource, String title, String description, DateTime? documentDate,@JsonKey(fromJson: dateSourceFromJson) DateSource dateSource, bool dateVerified, DateTime? dateVerifiedAt, String facilityName, HealthcareFacility? healthcareFacility, String locationText, String department, String physicianName,@JsonKey(fromJson: processingStatusFromJson) ProcessingStatus processingStatus,@JsonKey(fromJson: archiveStatusFromJson) ArchiveStatus archiveStatus, StoredFilePublic? file, DateTime? createdAt, DateTime? updatedAt
});


@override $HealthcareFacilityCopyWith<$Res>? get healthcareFacility;@override $StoredFilePublicCopyWith<$Res>? get file;

}
/// @nodoc
class __$MedicalDocumentCopyWithImpl<$Res>
    implements _$MedicalDocumentCopyWith<$Res> {
  __$MedicalDocumentCopyWithImpl(this._self, this._then);

  final _MedicalDocument _self;
  final $Res Function(_MedicalDocument) _then;

/// Create a copy of MedicalDocument
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? uuid = null,Object? documentType = null,Object? classificationSource = null,Object? title = null,Object? description = null,Object? documentDate = freezed,Object? dateSource = null,Object? dateVerified = null,Object? dateVerifiedAt = freezed,Object? facilityName = null,Object? healthcareFacility = freezed,Object? locationText = null,Object? department = null,Object? physicianName = null,Object? processingStatus = null,Object? archiveStatus = null,Object? file = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_MedicalDocument(
uuid: null == uuid ? _self.uuid : uuid // ignore: cast_nullable_to_non_nullable
as String,documentType: null == documentType ? _self.documentType : documentType // ignore: cast_nullable_to_non_nullable
as MedicalDocumentType,classificationSource: null == classificationSource ? _self.classificationSource : classificationSource // ignore: cast_nullable_to_non_nullable
as ClassificationSource,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,documentDate: freezed == documentDate ? _self.documentDate : documentDate // ignore: cast_nullable_to_non_nullable
as DateTime?,dateSource: null == dateSource ? _self.dateSource : dateSource // ignore: cast_nullable_to_non_nullable
as DateSource,dateVerified: null == dateVerified ? _self.dateVerified : dateVerified // ignore: cast_nullable_to_non_nullable
as bool,dateVerifiedAt: freezed == dateVerifiedAt ? _self.dateVerifiedAt : dateVerifiedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,facilityName: null == facilityName ? _self.facilityName : facilityName // ignore: cast_nullable_to_non_nullable
as String,healthcareFacility: freezed == healthcareFacility ? _self.healthcareFacility : healthcareFacility // ignore: cast_nullable_to_non_nullable
as HealthcareFacility?,locationText: null == locationText ? _self.locationText : locationText // ignore: cast_nullable_to_non_nullable
as String,department: null == department ? _self.department : department // ignore: cast_nullable_to_non_nullable
as String,physicianName: null == physicianName ? _self.physicianName : physicianName // ignore: cast_nullable_to_non_nullable
as String,processingStatus: null == processingStatus ? _self.processingStatus : processingStatus // ignore: cast_nullable_to_non_nullable
as ProcessingStatus,archiveStatus: null == archiveStatus ? _self.archiveStatus : archiveStatus // ignore: cast_nullable_to_non_nullable
as ArchiveStatus,file: freezed == file ? _self.file : file // ignore: cast_nullable_to_non_nullable
as StoredFilePublic?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of MedicalDocument
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HealthcareFacilityCopyWith<$Res>? get healthcareFacility {
    if (_self.healthcareFacility == null) {
    return null;
  }

  return $HealthcareFacilityCopyWith<$Res>(_self.healthcareFacility!, (value) {
    return _then(_self.copyWith(healthcareFacility: value));
  });
}/// Create a copy of MedicalDocument
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StoredFilePublicCopyWith<$Res>? get file {
    if (_self.file == null) {
    return null;
  }

  return $StoredFilePublicCopyWith<$Res>(_self.file!, (value) {
    return _then(_self.copyWith(file: value));
  });
}
}


/// @nodoc
mixin _$MedicalDocumentDetail {

 String get uuid;@JsonKey(fromJson: medicalDocumentTypeFromJson) MedicalDocumentType get documentType;@JsonKey(fromJson: classificationSourceFromJson) ClassificationSource get classificationSource; String get title; String get description; DateTime? get documentDate;@JsonKey(fromJson: dateSourceFromJson) DateSource get dateSource; bool get dateVerified; DateTime? get dateVerifiedAt; String get facilityName; HealthcareFacility? get healthcareFacility; String get locationText; String get department; String get physicianName;@JsonKey(fromJson: processingStatusFromJson) ProcessingStatus get processingStatus;@JsonKey(fromJson: archiveStatusFromJson) ArchiveStatus get archiveStatus; StoredFilePublic? get file; DateTime? get createdAt; DateTime? get updatedAt; bool get textAvailable;/// Existing document uuid when this upload was flagged as a content
/// duplicate (owner-scoped). Null otherwise.
 String? get duplicateOf;
/// Create a copy of MedicalDocumentDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MedicalDocumentDetailCopyWith<MedicalDocumentDetail> get copyWith => _$MedicalDocumentDetailCopyWithImpl<MedicalDocumentDetail>(this as MedicalDocumentDetail, _$identity);

  /// Serializes this MedicalDocumentDetail to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MedicalDocumentDetail&&(identical(other.uuid, uuid) || other.uuid == uuid)&&(identical(other.documentType, documentType) || other.documentType == documentType)&&(identical(other.classificationSource, classificationSource) || other.classificationSource == classificationSource)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.documentDate, documentDate) || other.documentDate == documentDate)&&(identical(other.dateSource, dateSource) || other.dateSource == dateSource)&&(identical(other.dateVerified, dateVerified) || other.dateVerified == dateVerified)&&(identical(other.dateVerifiedAt, dateVerifiedAt) || other.dateVerifiedAt == dateVerifiedAt)&&(identical(other.facilityName, facilityName) || other.facilityName == facilityName)&&(identical(other.healthcareFacility, healthcareFacility) || other.healthcareFacility == healthcareFacility)&&(identical(other.locationText, locationText) || other.locationText == locationText)&&(identical(other.department, department) || other.department == department)&&(identical(other.physicianName, physicianName) || other.physicianName == physicianName)&&(identical(other.processingStatus, processingStatus) || other.processingStatus == processingStatus)&&(identical(other.archiveStatus, archiveStatus) || other.archiveStatus == archiveStatus)&&(identical(other.file, file) || other.file == file)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.textAvailable, textAvailable) || other.textAvailable == textAvailable)&&(identical(other.duplicateOf, duplicateOf) || other.duplicateOf == duplicateOf));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,uuid,documentType,classificationSource,title,description,documentDate,dateSource,dateVerified,dateVerifiedAt,facilityName,healthcareFacility,locationText,department,physicianName,processingStatus,archiveStatus,file,createdAt,updatedAt,textAvailable,duplicateOf]);

@override
String toString() {
  return 'MedicalDocumentDetail(uuid: $uuid, documentType: $documentType, classificationSource: $classificationSource, title: $title, description: $description, documentDate: $documentDate, dateSource: $dateSource, dateVerified: $dateVerified, dateVerifiedAt: $dateVerifiedAt, facilityName: $facilityName, healthcareFacility: $healthcareFacility, locationText: $locationText, department: $department, physicianName: $physicianName, processingStatus: $processingStatus, archiveStatus: $archiveStatus, file: $file, createdAt: $createdAt, updatedAt: $updatedAt, textAvailable: $textAvailable, duplicateOf: $duplicateOf)';
}


}

/// @nodoc
abstract mixin class $MedicalDocumentDetailCopyWith<$Res>  {
  factory $MedicalDocumentDetailCopyWith(MedicalDocumentDetail value, $Res Function(MedicalDocumentDetail) _then) = _$MedicalDocumentDetailCopyWithImpl;
@useResult
$Res call({
 String uuid,@JsonKey(fromJson: medicalDocumentTypeFromJson) MedicalDocumentType documentType,@JsonKey(fromJson: classificationSourceFromJson) ClassificationSource classificationSource, String title, String description, DateTime? documentDate,@JsonKey(fromJson: dateSourceFromJson) DateSource dateSource, bool dateVerified, DateTime? dateVerifiedAt, String facilityName, HealthcareFacility? healthcareFacility, String locationText, String department, String physicianName,@JsonKey(fromJson: processingStatusFromJson) ProcessingStatus processingStatus,@JsonKey(fromJson: archiveStatusFromJson) ArchiveStatus archiveStatus, StoredFilePublic? file, DateTime? createdAt, DateTime? updatedAt, bool textAvailable, String? duplicateOf
});


$HealthcareFacilityCopyWith<$Res>? get healthcareFacility;$StoredFilePublicCopyWith<$Res>? get file;

}
/// @nodoc
class _$MedicalDocumentDetailCopyWithImpl<$Res>
    implements $MedicalDocumentDetailCopyWith<$Res> {
  _$MedicalDocumentDetailCopyWithImpl(this._self, this._then);

  final MedicalDocumentDetail _self;
  final $Res Function(MedicalDocumentDetail) _then;

/// Create a copy of MedicalDocumentDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? uuid = null,Object? documentType = null,Object? classificationSource = null,Object? title = null,Object? description = null,Object? documentDate = freezed,Object? dateSource = null,Object? dateVerified = null,Object? dateVerifiedAt = freezed,Object? facilityName = null,Object? healthcareFacility = freezed,Object? locationText = null,Object? department = null,Object? physicianName = null,Object? processingStatus = null,Object? archiveStatus = null,Object? file = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? textAvailable = null,Object? duplicateOf = freezed,}) {
  return _then(_self.copyWith(
uuid: null == uuid ? _self.uuid : uuid // ignore: cast_nullable_to_non_nullable
as String,documentType: null == documentType ? _self.documentType : documentType // ignore: cast_nullable_to_non_nullable
as MedicalDocumentType,classificationSource: null == classificationSource ? _self.classificationSource : classificationSource // ignore: cast_nullable_to_non_nullable
as ClassificationSource,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,documentDate: freezed == documentDate ? _self.documentDate : documentDate // ignore: cast_nullable_to_non_nullable
as DateTime?,dateSource: null == dateSource ? _self.dateSource : dateSource // ignore: cast_nullable_to_non_nullable
as DateSource,dateVerified: null == dateVerified ? _self.dateVerified : dateVerified // ignore: cast_nullable_to_non_nullable
as bool,dateVerifiedAt: freezed == dateVerifiedAt ? _self.dateVerifiedAt : dateVerifiedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,facilityName: null == facilityName ? _self.facilityName : facilityName // ignore: cast_nullable_to_non_nullable
as String,healthcareFacility: freezed == healthcareFacility ? _self.healthcareFacility : healthcareFacility // ignore: cast_nullable_to_non_nullable
as HealthcareFacility?,locationText: null == locationText ? _self.locationText : locationText // ignore: cast_nullable_to_non_nullable
as String,department: null == department ? _self.department : department // ignore: cast_nullable_to_non_nullable
as String,physicianName: null == physicianName ? _self.physicianName : physicianName // ignore: cast_nullable_to_non_nullable
as String,processingStatus: null == processingStatus ? _self.processingStatus : processingStatus // ignore: cast_nullable_to_non_nullable
as ProcessingStatus,archiveStatus: null == archiveStatus ? _self.archiveStatus : archiveStatus // ignore: cast_nullable_to_non_nullable
as ArchiveStatus,file: freezed == file ? _self.file : file // ignore: cast_nullable_to_non_nullable
as StoredFilePublic?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,textAvailable: null == textAvailable ? _self.textAvailable : textAvailable // ignore: cast_nullable_to_non_nullable
as bool,duplicateOf: freezed == duplicateOf ? _self.duplicateOf : duplicateOf // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of MedicalDocumentDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HealthcareFacilityCopyWith<$Res>? get healthcareFacility {
    if (_self.healthcareFacility == null) {
    return null;
  }

  return $HealthcareFacilityCopyWith<$Res>(_self.healthcareFacility!, (value) {
    return _then(_self.copyWith(healthcareFacility: value));
  });
}/// Create a copy of MedicalDocumentDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StoredFilePublicCopyWith<$Res>? get file {
    if (_self.file == null) {
    return null;
  }

  return $StoredFilePublicCopyWith<$Res>(_self.file!, (value) {
    return _then(_self.copyWith(file: value));
  });
}
}


/// Adds pattern-matching-related methods to [MedicalDocumentDetail].
extension MedicalDocumentDetailPatterns on MedicalDocumentDetail {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MedicalDocumentDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MedicalDocumentDetail() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MedicalDocumentDetail value)  $default,){
final _that = this;
switch (_that) {
case _MedicalDocumentDetail():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MedicalDocumentDetail value)?  $default,){
final _that = this;
switch (_that) {
case _MedicalDocumentDetail() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String uuid, @JsonKey(fromJson: medicalDocumentTypeFromJson)  MedicalDocumentType documentType, @JsonKey(fromJson: classificationSourceFromJson)  ClassificationSource classificationSource,  String title,  String description,  DateTime? documentDate, @JsonKey(fromJson: dateSourceFromJson)  DateSource dateSource,  bool dateVerified,  DateTime? dateVerifiedAt,  String facilityName,  HealthcareFacility? healthcareFacility,  String locationText,  String department,  String physicianName, @JsonKey(fromJson: processingStatusFromJson)  ProcessingStatus processingStatus, @JsonKey(fromJson: archiveStatusFromJson)  ArchiveStatus archiveStatus,  StoredFilePublic? file,  DateTime? createdAt,  DateTime? updatedAt,  bool textAvailable,  String? duplicateOf)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MedicalDocumentDetail() when $default != null:
return $default(_that.uuid,_that.documentType,_that.classificationSource,_that.title,_that.description,_that.documentDate,_that.dateSource,_that.dateVerified,_that.dateVerifiedAt,_that.facilityName,_that.healthcareFacility,_that.locationText,_that.department,_that.physicianName,_that.processingStatus,_that.archiveStatus,_that.file,_that.createdAt,_that.updatedAt,_that.textAvailable,_that.duplicateOf);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String uuid, @JsonKey(fromJson: medicalDocumentTypeFromJson)  MedicalDocumentType documentType, @JsonKey(fromJson: classificationSourceFromJson)  ClassificationSource classificationSource,  String title,  String description,  DateTime? documentDate, @JsonKey(fromJson: dateSourceFromJson)  DateSource dateSource,  bool dateVerified,  DateTime? dateVerifiedAt,  String facilityName,  HealthcareFacility? healthcareFacility,  String locationText,  String department,  String physicianName, @JsonKey(fromJson: processingStatusFromJson)  ProcessingStatus processingStatus, @JsonKey(fromJson: archiveStatusFromJson)  ArchiveStatus archiveStatus,  StoredFilePublic? file,  DateTime? createdAt,  DateTime? updatedAt,  bool textAvailable,  String? duplicateOf)  $default,) {final _that = this;
switch (_that) {
case _MedicalDocumentDetail():
return $default(_that.uuid,_that.documentType,_that.classificationSource,_that.title,_that.description,_that.documentDate,_that.dateSource,_that.dateVerified,_that.dateVerifiedAt,_that.facilityName,_that.healthcareFacility,_that.locationText,_that.department,_that.physicianName,_that.processingStatus,_that.archiveStatus,_that.file,_that.createdAt,_that.updatedAt,_that.textAvailable,_that.duplicateOf);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String uuid, @JsonKey(fromJson: medicalDocumentTypeFromJson)  MedicalDocumentType documentType, @JsonKey(fromJson: classificationSourceFromJson)  ClassificationSource classificationSource,  String title,  String description,  DateTime? documentDate, @JsonKey(fromJson: dateSourceFromJson)  DateSource dateSource,  bool dateVerified,  DateTime? dateVerifiedAt,  String facilityName,  HealthcareFacility? healthcareFacility,  String locationText,  String department,  String physicianName, @JsonKey(fromJson: processingStatusFromJson)  ProcessingStatus processingStatus, @JsonKey(fromJson: archiveStatusFromJson)  ArchiveStatus archiveStatus,  StoredFilePublic? file,  DateTime? createdAt,  DateTime? updatedAt,  bool textAvailable,  String? duplicateOf)?  $default,) {final _that = this;
switch (_that) {
case _MedicalDocumentDetail() when $default != null:
return $default(_that.uuid,_that.documentType,_that.classificationSource,_that.title,_that.description,_that.documentDate,_that.dateSource,_that.dateVerified,_that.dateVerifiedAt,_that.facilityName,_that.healthcareFacility,_that.locationText,_that.department,_that.physicianName,_that.processingStatus,_that.archiveStatus,_that.file,_that.createdAt,_that.updatedAt,_that.textAvailable,_that.duplicateOf);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _MedicalDocumentDetail implements MedicalDocumentDetail {
  const _MedicalDocumentDetail({required this.uuid, @JsonKey(fromJson: medicalDocumentTypeFromJson) this.documentType = MedicalDocumentType.unknown, @JsonKey(fromJson: classificationSourceFromJson) this.classificationSource = ClassificationSource.unknown, this.title = '', this.description = '', this.documentDate, @JsonKey(fromJson: dateSourceFromJson) this.dateSource = DateSource.unknown, this.dateVerified = false, this.dateVerifiedAt, this.facilityName = '', this.healthcareFacility, this.locationText = '', this.department = '', this.physicianName = '', @JsonKey(fromJson: processingStatusFromJson) this.processingStatus = ProcessingStatus.unknown, @JsonKey(fromJson: archiveStatusFromJson) this.archiveStatus = ArchiveStatus.unknown, this.file, this.createdAt, this.updatedAt, this.textAvailable = false, this.duplicateOf});
  factory _MedicalDocumentDetail.fromJson(Map<String, dynamic> json) => _$MedicalDocumentDetailFromJson(json);

@override final  String uuid;
@override@JsonKey(fromJson: medicalDocumentTypeFromJson) final  MedicalDocumentType documentType;
@override@JsonKey(fromJson: classificationSourceFromJson) final  ClassificationSource classificationSource;
@override@JsonKey() final  String title;
@override@JsonKey() final  String description;
@override final  DateTime? documentDate;
@override@JsonKey(fromJson: dateSourceFromJson) final  DateSource dateSource;
@override@JsonKey() final  bool dateVerified;
@override final  DateTime? dateVerifiedAt;
@override@JsonKey() final  String facilityName;
@override final  HealthcareFacility? healthcareFacility;
@override@JsonKey() final  String locationText;
@override@JsonKey() final  String department;
@override@JsonKey() final  String physicianName;
@override@JsonKey(fromJson: processingStatusFromJson) final  ProcessingStatus processingStatus;
@override@JsonKey(fromJson: archiveStatusFromJson) final  ArchiveStatus archiveStatus;
@override final  StoredFilePublic? file;
@override final  DateTime? createdAt;
@override final  DateTime? updatedAt;
@override@JsonKey() final  bool textAvailable;
/// Existing document uuid when this upload was flagged as a content
/// duplicate (owner-scoped). Null otherwise.
@override final  String? duplicateOf;

/// Create a copy of MedicalDocumentDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MedicalDocumentDetailCopyWith<_MedicalDocumentDetail> get copyWith => __$MedicalDocumentDetailCopyWithImpl<_MedicalDocumentDetail>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MedicalDocumentDetailToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MedicalDocumentDetail&&(identical(other.uuid, uuid) || other.uuid == uuid)&&(identical(other.documentType, documentType) || other.documentType == documentType)&&(identical(other.classificationSource, classificationSource) || other.classificationSource == classificationSource)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.documentDate, documentDate) || other.documentDate == documentDate)&&(identical(other.dateSource, dateSource) || other.dateSource == dateSource)&&(identical(other.dateVerified, dateVerified) || other.dateVerified == dateVerified)&&(identical(other.dateVerifiedAt, dateVerifiedAt) || other.dateVerifiedAt == dateVerifiedAt)&&(identical(other.facilityName, facilityName) || other.facilityName == facilityName)&&(identical(other.healthcareFacility, healthcareFacility) || other.healthcareFacility == healthcareFacility)&&(identical(other.locationText, locationText) || other.locationText == locationText)&&(identical(other.department, department) || other.department == department)&&(identical(other.physicianName, physicianName) || other.physicianName == physicianName)&&(identical(other.processingStatus, processingStatus) || other.processingStatus == processingStatus)&&(identical(other.archiveStatus, archiveStatus) || other.archiveStatus == archiveStatus)&&(identical(other.file, file) || other.file == file)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.textAvailable, textAvailable) || other.textAvailable == textAvailable)&&(identical(other.duplicateOf, duplicateOf) || other.duplicateOf == duplicateOf));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,uuid,documentType,classificationSource,title,description,documentDate,dateSource,dateVerified,dateVerifiedAt,facilityName,healthcareFacility,locationText,department,physicianName,processingStatus,archiveStatus,file,createdAt,updatedAt,textAvailable,duplicateOf]);

@override
String toString() {
  return 'MedicalDocumentDetail(uuid: $uuid, documentType: $documentType, classificationSource: $classificationSource, title: $title, description: $description, documentDate: $documentDate, dateSource: $dateSource, dateVerified: $dateVerified, dateVerifiedAt: $dateVerifiedAt, facilityName: $facilityName, healthcareFacility: $healthcareFacility, locationText: $locationText, department: $department, physicianName: $physicianName, processingStatus: $processingStatus, archiveStatus: $archiveStatus, file: $file, createdAt: $createdAt, updatedAt: $updatedAt, textAvailable: $textAvailable, duplicateOf: $duplicateOf)';
}


}

/// @nodoc
abstract mixin class _$MedicalDocumentDetailCopyWith<$Res> implements $MedicalDocumentDetailCopyWith<$Res> {
  factory _$MedicalDocumentDetailCopyWith(_MedicalDocumentDetail value, $Res Function(_MedicalDocumentDetail) _then) = __$MedicalDocumentDetailCopyWithImpl;
@override @useResult
$Res call({
 String uuid,@JsonKey(fromJson: medicalDocumentTypeFromJson) MedicalDocumentType documentType,@JsonKey(fromJson: classificationSourceFromJson) ClassificationSource classificationSource, String title, String description, DateTime? documentDate,@JsonKey(fromJson: dateSourceFromJson) DateSource dateSource, bool dateVerified, DateTime? dateVerifiedAt, String facilityName, HealthcareFacility? healthcareFacility, String locationText, String department, String physicianName,@JsonKey(fromJson: processingStatusFromJson) ProcessingStatus processingStatus,@JsonKey(fromJson: archiveStatusFromJson) ArchiveStatus archiveStatus, StoredFilePublic? file, DateTime? createdAt, DateTime? updatedAt, bool textAvailable, String? duplicateOf
});


@override $HealthcareFacilityCopyWith<$Res>? get healthcareFacility;@override $StoredFilePublicCopyWith<$Res>? get file;

}
/// @nodoc
class __$MedicalDocumentDetailCopyWithImpl<$Res>
    implements _$MedicalDocumentDetailCopyWith<$Res> {
  __$MedicalDocumentDetailCopyWithImpl(this._self, this._then);

  final _MedicalDocumentDetail _self;
  final $Res Function(_MedicalDocumentDetail) _then;

/// Create a copy of MedicalDocumentDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? uuid = null,Object? documentType = null,Object? classificationSource = null,Object? title = null,Object? description = null,Object? documentDate = freezed,Object? dateSource = null,Object? dateVerified = null,Object? dateVerifiedAt = freezed,Object? facilityName = null,Object? healthcareFacility = freezed,Object? locationText = null,Object? department = null,Object? physicianName = null,Object? processingStatus = null,Object? archiveStatus = null,Object? file = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? textAvailable = null,Object? duplicateOf = freezed,}) {
  return _then(_MedicalDocumentDetail(
uuid: null == uuid ? _self.uuid : uuid // ignore: cast_nullable_to_non_nullable
as String,documentType: null == documentType ? _self.documentType : documentType // ignore: cast_nullable_to_non_nullable
as MedicalDocumentType,classificationSource: null == classificationSource ? _self.classificationSource : classificationSource // ignore: cast_nullable_to_non_nullable
as ClassificationSource,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,documentDate: freezed == documentDate ? _self.documentDate : documentDate // ignore: cast_nullable_to_non_nullable
as DateTime?,dateSource: null == dateSource ? _self.dateSource : dateSource // ignore: cast_nullable_to_non_nullable
as DateSource,dateVerified: null == dateVerified ? _self.dateVerified : dateVerified // ignore: cast_nullable_to_non_nullable
as bool,dateVerifiedAt: freezed == dateVerifiedAt ? _self.dateVerifiedAt : dateVerifiedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,facilityName: null == facilityName ? _self.facilityName : facilityName // ignore: cast_nullable_to_non_nullable
as String,healthcareFacility: freezed == healthcareFacility ? _self.healthcareFacility : healthcareFacility // ignore: cast_nullable_to_non_nullable
as HealthcareFacility?,locationText: null == locationText ? _self.locationText : locationText // ignore: cast_nullable_to_non_nullable
as String,department: null == department ? _self.department : department // ignore: cast_nullable_to_non_nullable
as String,physicianName: null == physicianName ? _self.physicianName : physicianName // ignore: cast_nullable_to_non_nullable
as String,processingStatus: null == processingStatus ? _self.processingStatus : processingStatus // ignore: cast_nullable_to_non_nullable
as ProcessingStatus,archiveStatus: null == archiveStatus ? _self.archiveStatus : archiveStatus // ignore: cast_nullable_to_non_nullable
as ArchiveStatus,file: freezed == file ? _self.file : file // ignore: cast_nullable_to_non_nullable
as StoredFilePublic?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,textAvailable: null == textAvailable ? _self.textAvailable : textAvailable // ignore: cast_nullable_to_non_nullable
as bool,duplicateOf: freezed == duplicateOf ? _self.duplicateOf : duplicateOf // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of MedicalDocumentDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HealthcareFacilityCopyWith<$Res>? get healthcareFacility {
    if (_self.healthcareFacility == null) {
    return null;
  }

  return $HealthcareFacilityCopyWith<$Res>(_self.healthcareFacility!, (value) {
    return _then(_self.copyWith(healthcareFacility: value));
  });
}/// Create a copy of MedicalDocumentDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StoredFilePublicCopyWith<$Res>? get file {
    if (_self.file == null) {
    return null;
  }

  return $StoredFilePublicCopyWith<$Res>(_self.file!, (value) {
    return _then(_self.copyWith(file: value));
  });
}
}


/// @nodoc
mixin _$DocumentDateConfirmationResponse {

 String get uuid; DateTime? get documentDate;@JsonKey(fromJson: dateSourceFromJson) DateSource get dateSource; bool get dateVerified; DateTime? get dateVerifiedAt;@JsonKey(fromJson: processingStatusFromJson) ProcessingStatus get processingStatus;
/// Create a copy of DocumentDateConfirmationResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DocumentDateConfirmationResponseCopyWith<DocumentDateConfirmationResponse> get copyWith => _$DocumentDateConfirmationResponseCopyWithImpl<DocumentDateConfirmationResponse>(this as DocumentDateConfirmationResponse, _$identity);

  /// Serializes this DocumentDateConfirmationResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DocumentDateConfirmationResponse&&(identical(other.uuid, uuid) || other.uuid == uuid)&&(identical(other.documentDate, documentDate) || other.documentDate == documentDate)&&(identical(other.dateSource, dateSource) || other.dateSource == dateSource)&&(identical(other.dateVerified, dateVerified) || other.dateVerified == dateVerified)&&(identical(other.dateVerifiedAt, dateVerifiedAt) || other.dateVerifiedAt == dateVerifiedAt)&&(identical(other.processingStatus, processingStatus) || other.processingStatus == processingStatus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uuid,documentDate,dateSource,dateVerified,dateVerifiedAt,processingStatus);

@override
String toString() {
  return 'DocumentDateConfirmationResponse(uuid: $uuid, documentDate: $documentDate, dateSource: $dateSource, dateVerified: $dateVerified, dateVerifiedAt: $dateVerifiedAt, processingStatus: $processingStatus)';
}


}

/// @nodoc
abstract mixin class $DocumentDateConfirmationResponseCopyWith<$Res>  {
  factory $DocumentDateConfirmationResponseCopyWith(DocumentDateConfirmationResponse value, $Res Function(DocumentDateConfirmationResponse) _then) = _$DocumentDateConfirmationResponseCopyWithImpl;
@useResult
$Res call({
 String uuid, DateTime? documentDate,@JsonKey(fromJson: dateSourceFromJson) DateSource dateSource, bool dateVerified, DateTime? dateVerifiedAt,@JsonKey(fromJson: processingStatusFromJson) ProcessingStatus processingStatus
});




}
/// @nodoc
class _$DocumentDateConfirmationResponseCopyWithImpl<$Res>
    implements $DocumentDateConfirmationResponseCopyWith<$Res> {
  _$DocumentDateConfirmationResponseCopyWithImpl(this._self, this._then);

  final DocumentDateConfirmationResponse _self;
  final $Res Function(DocumentDateConfirmationResponse) _then;

/// Create a copy of DocumentDateConfirmationResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? uuid = null,Object? documentDate = freezed,Object? dateSource = null,Object? dateVerified = null,Object? dateVerifiedAt = freezed,Object? processingStatus = null,}) {
  return _then(_self.copyWith(
uuid: null == uuid ? _self.uuid : uuid // ignore: cast_nullable_to_non_nullable
as String,documentDate: freezed == documentDate ? _self.documentDate : documentDate // ignore: cast_nullable_to_non_nullable
as DateTime?,dateSource: null == dateSource ? _self.dateSource : dateSource // ignore: cast_nullable_to_non_nullable
as DateSource,dateVerified: null == dateVerified ? _self.dateVerified : dateVerified // ignore: cast_nullable_to_non_nullable
as bool,dateVerifiedAt: freezed == dateVerifiedAt ? _self.dateVerifiedAt : dateVerifiedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,processingStatus: null == processingStatus ? _self.processingStatus : processingStatus // ignore: cast_nullable_to_non_nullable
as ProcessingStatus,
  ));
}

}


/// Adds pattern-matching-related methods to [DocumentDateConfirmationResponse].
extension DocumentDateConfirmationResponsePatterns on DocumentDateConfirmationResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DocumentDateConfirmationResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DocumentDateConfirmationResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DocumentDateConfirmationResponse value)  $default,){
final _that = this;
switch (_that) {
case _DocumentDateConfirmationResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DocumentDateConfirmationResponse value)?  $default,){
final _that = this;
switch (_that) {
case _DocumentDateConfirmationResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String uuid,  DateTime? documentDate, @JsonKey(fromJson: dateSourceFromJson)  DateSource dateSource,  bool dateVerified,  DateTime? dateVerifiedAt, @JsonKey(fromJson: processingStatusFromJson)  ProcessingStatus processingStatus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DocumentDateConfirmationResponse() when $default != null:
return $default(_that.uuid,_that.documentDate,_that.dateSource,_that.dateVerified,_that.dateVerifiedAt,_that.processingStatus);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String uuid,  DateTime? documentDate, @JsonKey(fromJson: dateSourceFromJson)  DateSource dateSource,  bool dateVerified,  DateTime? dateVerifiedAt, @JsonKey(fromJson: processingStatusFromJson)  ProcessingStatus processingStatus)  $default,) {final _that = this;
switch (_that) {
case _DocumentDateConfirmationResponse():
return $default(_that.uuid,_that.documentDate,_that.dateSource,_that.dateVerified,_that.dateVerifiedAt,_that.processingStatus);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String uuid,  DateTime? documentDate, @JsonKey(fromJson: dateSourceFromJson)  DateSource dateSource,  bool dateVerified,  DateTime? dateVerifiedAt, @JsonKey(fromJson: processingStatusFromJson)  ProcessingStatus processingStatus)?  $default,) {final _that = this;
switch (_that) {
case _DocumentDateConfirmationResponse() when $default != null:
return $default(_that.uuid,_that.documentDate,_that.dateSource,_that.dateVerified,_that.dateVerifiedAt,_that.processingStatus);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _DocumentDateConfirmationResponse implements DocumentDateConfirmationResponse {
  const _DocumentDateConfirmationResponse({required this.uuid, this.documentDate, @JsonKey(fromJson: dateSourceFromJson) this.dateSource = DateSource.unknown, this.dateVerified = false, this.dateVerifiedAt, @JsonKey(fromJson: processingStatusFromJson) this.processingStatus = ProcessingStatus.unknown});
  factory _DocumentDateConfirmationResponse.fromJson(Map<String, dynamic> json) => _$DocumentDateConfirmationResponseFromJson(json);

@override final  String uuid;
@override final  DateTime? documentDate;
@override@JsonKey(fromJson: dateSourceFromJson) final  DateSource dateSource;
@override@JsonKey() final  bool dateVerified;
@override final  DateTime? dateVerifiedAt;
@override@JsonKey(fromJson: processingStatusFromJson) final  ProcessingStatus processingStatus;

/// Create a copy of DocumentDateConfirmationResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DocumentDateConfirmationResponseCopyWith<_DocumentDateConfirmationResponse> get copyWith => __$DocumentDateConfirmationResponseCopyWithImpl<_DocumentDateConfirmationResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DocumentDateConfirmationResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DocumentDateConfirmationResponse&&(identical(other.uuid, uuid) || other.uuid == uuid)&&(identical(other.documentDate, documentDate) || other.documentDate == documentDate)&&(identical(other.dateSource, dateSource) || other.dateSource == dateSource)&&(identical(other.dateVerified, dateVerified) || other.dateVerified == dateVerified)&&(identical(other.dateVerifiedAt, dateVerifiedAt) || other.dateVerifiedAt == dateVerifiedAt)&&(identical(other.processingStatus, processingStatus) || other.processingStatus == processingStatus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uuid,documentDate,dateSource,dateVerified,dateVerifiedAt,processingStatus);

@override
String toString() {
  return 'DocumentDateConfirmationResponse(uuid: $uuid, documentDate: $documentDate, dateSource: $dateSource, dateVerified: $dateVerified, dateVerifiedAt: $dateVerifiedAt, processingStatus: $processingStatus)';
}


}

/// @nodoc
abstract mixin class _$DocumentDateConfirmationResponseCopyWith<$Res> implements $DocumentDateConfirmationResponseCopyWith<$Res> {
  factory _$DocumentDateConfirmationResponseCopyWith(_DocumentDateConfirmationResponse value, $Res Function(_DocumentDateConfirmationResponse) _then) = __$DocumentDateConfirmationResponseCopyWithImpl;
@override @useResult
$Res call({
 String uuid, DateTime? documentDate,@JsonKey(fromJson: dateSourceFromJson) DateSource dateSource, bool dateVerified, DateTime? dateVerifiedAt,@JsonKey(fromJson: processingStatusFromJson) ProcessingStatus processingStatus
});




}
/// @nodoc
class __$DocumentDateConfirmationResponseCopyWithImpl<$Res>
    implements _$DocumentDateConfirmationResponseCopyWith<$Res> {
  __$DocumentDateConfirmationResponseCopyWithImpl(this._self, this._then);

  final _DocumentDateConfirmationResponse _self;
  final $Res Function(_DocumentDateConfirmationResponse) _then;

/// Create a copy of DocumentDateConfirmationResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? uuid = null,Object? documentDate = freezed,Object? dateSource = null,Object? dateVerified = null,Object? dateVerifiedAt = freezed,Object? processingStatus = null,}) {
  return _then(_DocumentDateConfirmationResponse(
uuid: null == uuid ? _self.uuid : uuid // ignore: cast_nullable_to_non_nullable
as String,documentDate: freezed == documentDate ? _self.documentDate : documentDate // ignore: cast_nullable_to_non_nullable
as DateTime?,dateSource: null == dateSource ? _self.dateSource : dateSource // ignore: cast_nullable_to_non_nullable
as DateSource,dateVerified: null == dateVerified ? _self.dateVerified : dateVerified // ignore: cast_nullable_to_non_nullable
as bool,dateVerifiedAt: freezed == dateVerifiedAt ? _self.dateVerifiedAt : dateVerifiedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,processingStatus: null == processingStatus ? _self.processingStatus : processingStatus // ignore: cast_nullable_to_non_nullable
as ProcessingStatus,
  ));
}


}

// dart format on
