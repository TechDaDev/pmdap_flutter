// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'claim.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ClaimReceipt {

 String get claimId; String get status;
/// Create a copy of ClaimReceipt
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ClaimReceiptCopyWith<ClaimReceipt> get copyWith => _$ClaimReceiptCopyWithImpl<ClaimReceipt>(this as ClaimReceipt, _$identity);

  /// Serializes this ClaimReceipt to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ClaimReceipt&&(identical(other.claimId, claimId) || other.claimId == claimId)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,claimId,status);

@override
String toString() {
  return 'ClaimReceipt(claimId: $claimId, status: $status)';
}


}

/// @nodoc
abstract mixin class $ClaimReceiptCopyWith<$Res>  {
  factory $ClaimReceiptCopyWith(ClaimReceipt value, $Res Function(ClaimReceipt) _then) = _$ClaimReceiptCopyWithImpl;
@useResult
$Res call({
 String claimId, String status
});




}
/// @nodoc
class _$ClaimReceiptCopyWithImpl<$Res>
    implements $ClaimReceiptCopyWith<$Res> {
  _$ClaimReceiptCopyWithImpl(this._self, this._then);

  final ClaimReceipt _self;
  final $Res Function(ClaimReceipt) _then;

/// Create a copy of ClaimReceipt
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? claimId = null,Object? status = null,}) {
  return _then(_self.copyWith(
claimId: null == claimId ? _self.claimId : claimId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ClaimReceipt].
extension ClaimReceiptPatterns on ClaimReceipt {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ClaimReceipt value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ClaimReceipt() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ClaimReceipt value)  $default,){
final _that = this;
switch (_that) {
case _ClaimReceipt():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ClaimReceipt value)?  $default,){
final _that = this;
switch (_that) {
case _ClaimReceipt() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String claimId,  String status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ClaimReceipt() when $default != null:
return $default(_that.claimId,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String claimId,  String status)  $default,) {final _that = this;
switch (_that) {
case _ClaimReceipt():
return $default(_that.claimId,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String claimId,  String status)?  $default,) {final _that = this;
switch (_that) {
case _ClaimReceipt() when $default != null:
return $default(_that.claimId,_that.status);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _ClaimReceipt implements ClaimReceipt {
  const _ClaimReceipt({required this.claimId, this.status = ''});
  factory _ClaimReceipt.fromJson(Map<String, dynamic> json) => _$ClaimReceiptFromJson(json);

@override final  String claimId;
@override@JsonKey() final  String status;

/// Create a copy of ClaimReceipt
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ClaimReceiptCopyWith<_ClaimReceipt> get copyWith => __$ClaimReceiptCopyWithImpl<_ClaimReceipt>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ClaimReceiptToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ClaimReceipt&&(identical(other.claimId, claimId) || other.claimId == claimId)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,claimId,status);

@override
String toString() {
  return 'ClaimReceipt(claimId: $claimId, status: $status)';
}


}

/// @nodoc
abstract mixin class _$ClaimReceiptCopyWith<$Res> implements $ClaimReceiptCopyWith<$Res> {
  factory _$ClaimReceiptCopyWith(_ClaimReceipt value, $Res Function(_ClaimReceipt) _then) = __$ClaimReceiptCopyWithImpl;
@override @useResult
$Res call({
 String claimId, String status
});




}
/// @nodoc
class __$ClaimReceiptCopyWithImpl<$Res>
    implements _$ClaimReceiptCopyWith<$Res> {
  __$ClaimReceiptCopyWithImpl(this._self, this._then);

  final _ClaimReceipt _self;
  final $Res Function(_ClaimReceipt) _then;

/// Create a copy of ClaimReceipt
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? claimId = null,Object? status = null,}) {
  return _then(_ClaimReceipt(
claimId: null == claimId ? _self.claimId : claimId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
