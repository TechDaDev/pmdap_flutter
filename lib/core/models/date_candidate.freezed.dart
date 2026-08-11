// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'date_candidate.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DateCandidate {

 String get uuid; DateTime? get date; DateTime? get alternativeDate; String get type; double get score; int get pageNumber; String get context;@JsonKey(fromJson: sourceFromJson) Source get source; bool get ambiguous; bool get isSuggested;
/// Create a copy of DateCandidate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DateCandidateCopyWith<DateCandidate> get copyWith => _$DateCandidateCopyWithImpl<DateCandidate>(this as DateCandidate, _$identity);

  /// Serializes this DateCandidate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DateCandidate&&(identical(other.uuid, uuid) || other.uuid == uuid)&&(identical(other.date, date) || other.date == date)&&(identical(other.alternativeDate, alternativeDate) || other.alternativeDate == alternativeDate)&&(identical(other.type, type) || other.type == type)&&(identical(other.score, score) || other.score == score)&&(identical(other.pageNumber, pageNumber) || other.pageNumber == pageNumber)&&(identical(other.context, context) || other.context == context)&&(identical(other.source, source) || other.source == source)&&(identical(other.ambiguous, ambiguous) || other.ambiguous == ambiguous)&&(identical(other.isSuggested, isSuggested) || other.isSuggested == isSuggested));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uuid,date,alternativeDate,type,score,pageNumber,context,source,ambiguous,isSuggested);

@override
String toString() {
  return 'DateCandidate(uuid: $uuid, date: $date, alternativeDate: $alternativeDate, type: $type, score: $score, pageNumber: $pageNumber, context: $context, source: $source, ambiguous: $ambiguous, isSuggested: $isSuggested)';
}


}

/// @nodoc
abstract mixin class $DateCandidateCopyWith<$Res>  {
  factory $DateCandidateCopyWith(DateCandidate value, $Res Function(DateCandidate) _then) = _$DateCandidateCopyWithImpl;
@useResult
$Res call({
 String uuid, DateTime? date, DateTime? alternativeDate, String type, double score, int pageNumber, String context,@JsonKey(fromJson: sourceFromJson) Source source, bool ambiguous, bool isSuggested
});




}
/// @nodoc
class _$DateCandidateCopyWithImpl<$Res>
    implements $DateCandidateCopyWith<$Res> {
  _$DateCandidateCopyWithImpl(this._self, this._then);

  final DateCandidate _self;
  final $Res Function(DateCandidate) _then;

/// Create a copy of DateCandidate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? uuid = null,Object? date = freezed,Object? alternativeDate = freezed,Object? type = null,Object? score = null,Object? pageNumber = null,Object? context = null,Object? source = null,Object? ambiguous = null,Object? isSuggested = null,}) {
  return _then(_self.copyWith(
uuid: null == uuid ? _self.uuid : uuid // ignore: cast_nullable_to_non_nullable
as String,date: freezed == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime?,alternativeDate: freezed == alternativeDate ? _self.alternativeDate : alternativeDate // ignore: cast_nullable_to_non_nullable
as DateTime?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as double,pageNumber: null == pageNumber ? _self.pageNumber : pageNumber // ignore: cast_nullable_to_non_nullable
as int,context: null == context ? _self.context : context // ignore: cast_nullable_to_non_nullable
as String,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as Source,ambiguous: null == ambiguous ? _self.ambiguous : ambiguous // ignore: cast_nullable_to_non_nullable
as bool,isSuggested: null == isSuggested ? _self.isSuggested : isSuggested // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [DateCandidate].
extension DateCandidatePatterns on DateCandidate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DateCandidate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DateCandidate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DateCandidate value)  $default,){
final _that = this;
switch (_that) {
case _DateCandidate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DateCandidate value)?  $default,){
final _that = this;
switch (_that) {
case _DateCandidate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String uuid,  DateTime? date,  DateTime? alternativeDate,  String type,  double score,  int pageNumber,  String context, @JsonKey(fromJson: sourceFromJson)  Source source,  bool ambiguous,  bool isSuggested)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DateCandidate() when $default != null:
return $default(_that.uuid,_that.date,_that.alternativeDate,_that.type,_that.score,_that.pageNumber,_that.context,_that.source,_that.ambiguous,_that.isSuggested);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String uuid,  DateTime? date,  DateTime? alternativeDate,  String type,  double score,  int pageNumber,  String context, @JsonKey(fromJson: sourceFromJson)  Source source,  bool ambiguous,  bool isSuggested)  $default,) {final _that = this;
switch (_that) {
case _DateCandidate():
return $default(_that.uuid,_that.date,_that.alternativeDate,_that.type,_that.score,_that.pageNumber,_that.context,_that.source,_that.ambiguous,_that.isSuggested);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String uuid,  DateTime? date,  DateTime? alternativeDate,  String type,  double score,  int pageNumber,  String context, @JsonKey(fromJson: sourceFromJson)  Source source,  bool ambiguous,  bool isSuggested)?  $default,) {final _that = this;
switch (_that) {
case _DateCandidate() when $default != null:
return $default(_that.uuid,_that.date,_that.alternativeDate,_that.type,_that.score,_that.pageNumber,_that.context,_that.source,_that.ambiguous,_that.isSuggested);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _DateCandidate implements DateCandidate {
  const _DateCandidate({required this.uuid, this.date, this.alternativeDate, this.type = '', this.score = 0, this.pageNumber = 0, this.context = '', @JsonKey(fromJson: sourceFromJson) this.source = Source.unknown, this.ambiguous = false, this.isSuggested = false});
  factory _DateCandidate.fromJson(Map<String, dynamic> json) => _$DateCandidateFromJson(json);

@override final  String uuid;
@override final  DateTime? date;
@override final  DateTime? alternativeDate;
@override@JsonKey() final  String type;
@override@JsonKey() final  double score;
@override@JsonKey() final  int pageNumber;
@override@JsonKey() final  String context;
@override@JsonKey(fromJson: sourceFromJson) final  Source source;
@override@JsonKey() final  bool ambiguous;
@override@JsonKey() final  bool isSuggested;

/// Create a copy of DateCandidate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DateCandidateCopyWith<_DateCandidate> get copyWith => __$DateCandidateCopyWithImpl<_DateCandidate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DateCandidateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DateCandidate&&(identical(other.uuid, uuid) || other.uuid == uuid)&&(identical(other.date, date) || other.date == date)&&(identical(other.alternativeDate, alternativeDate) || other.alternativeDate == alternativeDate)&&(identical(other.type, type) || other.type == type)&&(identical(other.score, score) || other.score == score)&&(identical(other.pageNumber, pageNumber) || other.pageNumber == pageNumber)&&(identical(other.context, context) || other.context == context)&&(identical(other.source, source) || other.source == source)&&(identical(other.ambiguous, ambiguous) || other.ambiguous == ambiguous)&&(identical(other.isSuggested, isSuggested) || other.isSuggested == isSuggested));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uuid,date,alternativeDate,type,score,pageNumber,context,source,ambiguous,isSuggested);

@override
String toString() {
  return 'DateCandidate(uuid: $uuid, date: $date, alternativeDate: $alternativeDate, type: $type, score: $score, pageNumber: $pageNumber, context: $context, source: $source, ambiguous: $ambiguous, isSuggested: $isSuggested)';
}


}

/// @nodoc
abstract mixin class _$DateCandidateCopyWith<$Res> implements $DateCandidateCopyWith<$Res> {
  factory _$DateCandidateCopyWith(_DateCandidate value, $Res Function(_DateCandidate) _then) = __$DateCandidateCopyWithImpl;
@override @useResult
$Res call({
 String uuid, DateTime? date, DateTime? alternativeDate, String type, double score, int pageNumber, String context,@JsonKey(fromJson: sourceFromJson) Source source, bool ambiguous, bool isSuggested
});




}
/// @nodoc
class __$DateCandidateCopyWithImpl<$Res>
    implements _$DateCandidateCopyWith<$Res> {
  __$DateCandidateCopyWithImpl(this._self, this._then);

  final _DateCandidate _self;
  final $Res Function(_DateCandidate) _then;

/// Create a copy of DateCandidate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? uuid = null,Object? date = freezed,Object? alternativeDate = freezed,Object? type = null,Object? score = null,Object? pageNumber = null,Object? context = null,Object? source = null,Object? ambiguous = null,Object? isSuggested = null,}) {
  return _then(_DateCandidate(
uuid: null == uuid ? _self.uuid : uuid // ignore: cast_nullable_to_non_nullable
as String,date: freezed == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime?,alternativeDate: freezed == alternativeDate ? _self.alternativeDate : alternativeDate // ignore: cast_nullable_to_non_nullable
as DateTime?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as double,pageNumber: null == pageNumber ? _self.pageNumber : pageNumber // ignore: cast_nullable_to_non_nullable
as int,context: null == context ? _self.context : context // ignore: cast_nullable_to_non_nullable
as String,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as Source,ambiguous: null == ambiguous ? _self.ambiguous : ambiguous // ignore: cast_nullable_to_non_nullable
as bool,isSuggested: null == isSuggested ? _self.isSuggested : isSuggested // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
