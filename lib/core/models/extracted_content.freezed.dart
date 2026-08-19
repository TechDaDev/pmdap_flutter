// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'extracted_content.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ExtractedContentSection {

 String get heading; String get body; int get pageNumber; int get sequence;
/// Create a copy of ExtractedContentSection
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExtractedContentSectionCopyWith<ExtractedContentSection> get copyWith => _$ExtractedContentSectionCopyWithImpl<ExtractedContentSection>(this as ExtractedContentSection, _$identity);

  /// Serializes this ExtractedContentSection to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExtractedContentSection&&(identical(other.heading, heading) || other.heading == heading)&&(identical(other.body, body) || other.body == body)&&(identical(other.pageNumber, pageNumber) || other.pageNumber == pageNumber)&&(identical(other.sequence, sequence) || other.sequence == sequence));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,heading,body,pageNumber,sequence);

@override
String toString() {
  return 'ExtractedContentSection(heading: $heading, body: $body, pageNumber: $pageNumber, sequence: $sequence)';
}


}

/// @nodoc
abstract mixin class $ExtractedContentSectionCopyWith<$Res>  {
  factory $ExtractedContentSectionCopyWith(ExtractedContentSection value, $Res Function(ExtractedContentSection) _then) = _$ExtractedContentSectionCopyWithImpl;
@useResult
$Res call({
 String heading, String body, int pageNumber, int sequence
});




}
/// @nodoc
class _$ExtractedContentSectionCopyWithImpl<$Res>
    implements $ExtractedContentSectionCopyWith<$Res> {
  _$ExtractedContentSectionCopyWithImpl(this._self, this._then);

  final ExtractedContentSection _self;
  final $Res Function(ExtractedContentSection) _then;

/// Create a copy of ExtractedContentSection
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? heading = null,Object? body = null,Object? pageNumber = null,Object? sequence = null,}) {
  return _then(_self.copyWith(
heading: null == heading ? _self.heading : heading // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,pageNumber: null == pageNumber ? _self.pageNumber : pageNumber // ignore: cast_nullable_to_non_nullable
as int,sequence: null == sequence ? _self.sequence : sequence // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ExtractedContentSection].
extension ExtractedContentSectionPatterns on ExtractedContentSection {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExtractedContentSection value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExtractedContentSection() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExtractedContentSection value)  $default,){
final _that = this;
switch (_that) {
case _ExtractedContentSection():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExtractedContentSection value)?  $default,){
final _that = this;
switch (_that) {
case _ExtractedContentSection() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String heading,  String body,  int pageNumber,  int sequence)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExtractedContentSection() when $default != null:
return $default(_that.heading,_that.body,_that.pageNumber,_that.sequence);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String heading,  String body,  int pageNumber,  int sequence)  $default,) {final _that = this;
switch (_that) {
case _ExtractedContentSection():
return $default(_that.heading,_that.body,_that.pageNumber,_that.sequence);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String heading,  String body,  int pageNumber,  int sequence)?  $default,) {final _that = this;
switch (_that) {
case _ExtractedContentSection() when $default != null:
return $default(_that.heading,_that.body,_that.pageNumber,_that.sequence);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _ExtractedContentSection implements ExtractedContentSection {
  const _ExtractedContentSection({this.heading = '', this.body = '', this.pageNumber = 1, this.sequence = 0});
  factory _ExtractedContentSection.fromJson(Map<String, dynamic> json) => _$ExtractedContentSectionFromJson(json);

@override@JsonKey() final  String heading;
@override@JsonKey() final  String body;
@override@JsonKey() final  int pageNumber;
@override@JsonKey() final  int sequence;

/// Create a copy of ExtractedContentSection
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExtractedContentSectionCopyWith<_ExtractedContentSection> get copyWith => __$ExtractedContentSectionCopyWithImpl<_ExtractedContentSection>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExtractedContentSectionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExtractedContentSection&&(identical(other.heading, heading) || other.heading == heading)&&(identical(other.body, body) || other.body == body)&&(identical(other.pageNumber, pageNumber) || other.pageNumber == pageNumber)&&(identical(other.sequence, sequence) || other.sequence == sequence));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,heading,body,pageNumber,sequence);

@override
String toString() {
  return 'ExtractedContentSection(heading: $heading, body: $body, pageNumber: $pageNumber, sequence: $sequence)';
}


}

/// @nodoc
abstract mixin class _$ExtractedContentSectionCopyWith<$Res> implements $ExtractedContentSectionCopyWith<$Res> {
  factory _$ExtractedContentSectionCopyWith(_ExtractedContentSection value, $Res Function(_ExtractedContentSection) _then) = __$ExtractedContentSectionCopyWithImpl;
@override @useResult
$Res call({
 String heading, String body, int pageNumber, int sequence
});




}
/// @nodoc
class __$ExtractedContentSectionCopyWithImpl<$Res>
    implements _$ExtractedContentSectionCopyWith<$Res> {
  __$ExtractedContentSectionCopyWithImpl(this._self, this._then);

  final _ExtractedContentSection _self;
  final $Res Function(_ExtractedContentSection) _then;

/// Create a copy of ExtractedContentSection
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? heading = null,Object? body = null,Object? pageNumber = null,Object? sequence = null,}) {
  return _then(_ExtractedContentSection(
heading: null == heading ? _self.heading : heading // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,pageNumber: null == pageNumber ? _self.pageNumber : pageNumber // ignore: cast_nullable_to_non_nullable
as int,sequence: null == sequence ? _self.sequence : sequence // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$ExtractedContentResponse {

 String get documentUuid; String get documentType; String get contentKind; String get status; List<ExtractedContentSection> get sections;
/// Create a copy of ExtractedContentResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExtractedContentResponseCopyWith<ExtractedContentResponse> get copyWith => _$ExtractedContentResponseCopyWithImpl<ExtractedContentResponse>(this as ExtractedContentResponse, _$identity);

  /// Serializes this ExtractedContentResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExtractedContentResponse&&(identical(other.documentUuid, documentUuid) || other.documentUuid == documentUuid)&&(identical(other.documentType, documentType) || other.documentType == documentType)&&(identical(other.contentKind, contentKind) || other.contentKind == contentKind)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.sections, sections));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,documentUuid,documentType,contentKind,status,const DeepCollectionEquality().hash(sections));

@override
String toString() {
  return 'ExtractedContentResponse(documentUuid: $documentUuid, documentType: $documentType, contentKind: $contentKind, status: $status, sections: $sections)';
}


}

/// @nodoc
abstract mixin class $ExtractedContentResponseCopyWith<$Res>  {
  factory $ExtractedContentResponseCopyWith(ExtractedContentResponse value, $Res Function(ExtractedContentResponse) _then) = _$ExtractedContentResponseCopyWithImpl;
@useResult
$Res call({
 String documentUuid, String documentType, String contentKind, String status, List<ExtractedContentSection> sections
});




}
/// @nodoc
class _$ExtractedContentResponseCopyWithImpl<$Res>
    implements $ExtractedContentResponseCopyWith<$Res> {
  _$ExtractedContentResponseCopyWithImpl(this._self, this._then);

  final ExtractedContentResponse _self;
  final $Res Function(ExtractedContentResponse) _then;

/// Create a copy of ExtractedContentResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? documentUuid = null,Object? documentType = null,Object? contentKind = null,Object? status = null,Object? sections = null,}) {
  return _then(_self.copyWith(
documentUuid: null == documentUuid ? _self.documentUuid : documentUuid // ignore: cast_nullable_to_non_nullable
as String,documentType: null == documentType ? _self.documentType : documentType // ignore: cast_nullable_to_non_nullable
as String,contentKind: null == contentKind ? _self.contentKind : contentKind // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,sections: null == sections ? _self.sections : sections // ignore: cast_nullable_to_non_nullable
as List<ExtractedContentSection>,
  ));
}

}


/// Adds pattern-matching-related methods to [ExtractedContentResponse].
extension ExtractedContentResponsePatterns on ExtractedContentResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExtractedContentResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExtractedContentResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExtractedContentResponse value)  $default,){
final _that = this;
switch (_that) {
case _ExtractedContentResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExtractedContentResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ExtractedContentResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String documentUuid,  String documentType,  String contentKind,  String status,  List<ExtractedContentSection> sections)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExtractedContentResponse() when $default != null:
return $default(_that.documentUuid,_that.documentType,_that.contentKind,_that.status,_that.sections);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String documentUuid,  String documentType,  String contentKind,  String status,  List<ExtractedContentSection> sections)  $default,) {final _that = this;
switch (_that) {
case _ExtractedContentResponse():
return $default(_that.documentUuid,_that.documentType,_that.contentKind,_that.status,_that.sections);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String documentUuid,  String documentType,  String contentKind,  String status,  List<ExtractedContentSection> sections)?  $default,) {final _that = this;
switch (_that) {
case _ExtractedContentResponse() when $default != null:
return $default(_that.documentUuid,_that.documentType,_that.contentKind,_that.status,_that.sections);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _ExtractedContentResponse implements ExtractedContentResponse {
  const _ExtractedContentResponse({required this.documentUuid, this.documentType = '', this.contentKind = '', this.status = '', final  List<ExtractedContentSection> sections = const <ExtractedContentSection>[]}): _sections = sections;
  factory _ExtractedContentResponse.fromJson(Map<String, dynamic> json) => _$ExtractedContentResponseFromJson(json);

@override final  String documentUuid;
@override@JsonKey() final  String documentType;
@override@JsonKey() final  String contentKind;
@override@JsonKey() final  String status;
 final  List<ExtractedContentSection> _sections;
@override@JsonKey() List<ExtractedContentSection> get sections {
  if (_sections is EqualUnmodifiableListView) return _sections;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sections);
}


/// Create a copy of ExtractedContentResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExtractedContentResponseCopyWith<_ExtractedContentResponse> get copyWith => __$ExtractedContentResponseCopyWithImpl<_ExtractedContentResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExtractedContentResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExtractedContentResponse&&(identical(other.documentUuid, documentUuid) || other.documentUuid == documentUuid)&&(identical(other.documentType, documentType) || other.documentType == documentType)&&(identical(other.contentKind, contentKind) || other.contentKind == contentKind)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._sections, _sections));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,documentUuid,documentType,contentKind,status,const DeepCollectionEquality().hash(_sections));

@override
String toString() {
  return 'ExtractedContentResponse(documentUuid: $documentUuid, documentType: $documentType, contentKind: $contentKind, status: $status, sections: $sections)';
}


}

/// @nodoc
abstract mixin class _$ExtractedContentResponseCopyWith<$Res> implements $ExtractedContentResponseCopyWith<$Res> {
  factory _$ExtractedContentResponseCopyWith(_ExtractedContentResponse value, $Res Function(_ExtractedContentResponse) _then) = __$ExtractedContentResponseCopyWithImpl;
@override @useResult
$Res call({
 String documentUuid, String documentType, String contentKind, String status, List<ExtractedContentSection> sections
});




}
/// @nodoc
class __$ExtractedContentResponseCopyWithImpl<$Res>
    implements _$ExtractedContentResponseCopyWith<$Res> {
  __$ExtractedContentResponseCopyWithImpl(this._self, this._then);

  final _ExtractedContentResponse _self;
  final $Res Function(_ExtractedContentResponse) _then;

/// Create a copy of ExtractedContentResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? documentUuid = null,Object? documentType = null,Object? contentKind = null,Object? status = null,Object? sections = null,}) {
  return _then(_ExtractedContentResponse(
documentUuid: null == documentUuid ? _self.documentUuid : documentUuid // ignore: cast_nullable_to_non_nullable
as String,documentType: null == documentType ? _self.documentType : documentType // ignore: cast_nullable_to_non_nullable
as String,contentKind: null == contentKind ? _self.contentKind : contentKind // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,sections: null == sections ? _self._sections : sections // ignore: cast_nullable_to_non_nullable
as List<ExtractedContentSection>,
  ));
}


}

// dart format on
