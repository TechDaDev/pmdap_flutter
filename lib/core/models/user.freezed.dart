// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PublicUser {

 String get uuid; String get email; String get phone;@JsonKey(fromJson: roleFromJson) Role get role; bool get emailVerified; bool get phoneVerified; DateTime? get createdAt;
/// Create a copy of PublicUser
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PublicUserCopyWith<PublicUser> get copyWith => _$PublicUserCopyWithImpl<PublicUser>(this as PublicUser, _$identity);

  /// Serializes this PublicUser to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PublicUser&&(identical(other.uuid, uuid) || other.uuid == uuid)&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.role, role) || other.role == role)&&(identical(other.emailVerified, emailVerified) || other.emailVerified == emailVerified)&&(identical(other.phoneVerified, phoneVerified) || other.phoneVerified == phoneVerified)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uuid,email,phone,role,emailVerified,phoneVerified,createdAt);

@override
String toString() {
  return 'PublicUser(uuid: $uuid, email: $email, phone: $phone, role: $role, emailVerified: $emailVerified, phoneVerified: $phoneVerified, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $PublicUserCopyWith<$Res>  {
  factory $PublicUserCopyWith(PublicUser value, $Res Function(PublicUser) _then) = _$PublicUserCopyWithImpl;
@useResult
$Res call({
 String uuid, String email, String phone,@JsonKey(fromJson: roleFromJson) Role role, bool emailVerified, bool phoneVerified, DateTime? createdAt
});




}
/// @nodoc
class _$PublicUserCopyWithImpl<$Res>
    implements $PublicUserCopyWith<$Res> {
  _$PublicUserCopyWithImpl(this._self, this._then);

  final PublicUser _self;
  final $Res Function(PublicUser) _then;

/// Create a copy of PublicUser
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? uuid = null,Object? email = null,Object? phone = null,Object? role = null,Object? emailVerified = null,Object? phoneVerified = null,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
uuid: null == uuid ? _self.uuid : uuid // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as Role,emailVerified: null == emailVerified ? _self.emailVerified : emailVerified // ignore: cast_nullable_to_non_nullable
as bool,phoneVerified: null == phoneVerified ? _self.phoneVerified : phoneVerified // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [PublicUser].
extension PublicUserPatterns on PublicUser {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PublicUser value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PublicUser() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PublicUser value)  $default,){
final _that = this;
switch (_that) {
case _PublicUser():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PublicUser value)?  $default,){
final _that = this;
switch (_that) {
case _PublicUser() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String uuid,  String email,  String phone, @JsonKey(fromJson: roleFromJson)  Role role,  bool emailVerified,  bool phoneVerified,  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PublicUser() when $default != null:
return $default(_that.uuid,_that.email,_that.phone,_that.role,_that.emailVerified,_that.phoneVerified,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String uuid,  String email,  String phone, @JsonKey(fromJson: roleFromJson)  Role role,  bool emailVerified,  bool phoneVerified,  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _PublicUser():
return $default(_that.uuid,_that.email,_that.phone,_that.role,_that.emailVerified,_that.phoneVerified,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String uuid,  String email,  String phone, @JsonKey(fromJson: roleFromJson)  Role role,  bool emailVerified,  bool phoneVerified,  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _PublicUser() when $default != null:
return $default(_that.uuid,_that.email,_that.phone,_that.role,_that.emailVerified,_that.phoneVerified,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PublicUser implements PublicUser {
  const _PublicUser({required this.uuid, required this.email, this.phone = '', @JsonKey(fromJson: roleFromJson) this.role = Role.unknown, this.emailVerified = false, this.phoneVerified = false, this.createdAt});
  factory _PublicUser.fromJson(Map<String, dynamic> json) => _$PublicUserFromJson(json);

@override final  String uuid;
@override final  String email;
@override@JsonKey() final  String phone;
@override@JsonKey(fromJson: roleFromJson) final  Role role;
@override@JsonKey() final  bool emailVerified;
@override@JsonKey() final  bool phoneVerified;
@override final  DateTime? createdAt;

/// Create a copy of PublicUser
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PublicUserCopyWith<_PublicUser> get copyWith => __$PublicUserCopyWithImpl<_PublicUser>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PublicUserToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PublicUser&&(identical(other.uuid, uuid) || other.uuid == uuid)&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.role, role) || other.role == role)&&(identical(other.emailVerified, emailVerified) || other.emailVerified == emailVerified)&&(identical(other.phoneVerified, phoneVerified) || other.phoneVerified == phoneVerified)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uuid,email,phone,role,emailVerified,phoneVerified,createdAt);

@override
String toString() {
  return 'PublicUser(uuid: $uuid, email: $email, phone: $phone, role: $role, emailVerified: $emailVerified, phoneVerified: $phoneVerified, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$PublicUserCopyWith<$Res> implements $PublicUserCopyWith<$Res> {
  factory _$PublicUserCopyWith(_PublicUser value, $Res Function(_PublicUser) _then) = __$PublicUserCopyWithImpl;
@override @useResult
$Res call({
 String uuid, String email, String phone,@JsonKey(fromJson: roleFromJson) Role role, bool emailVerified, bool phoneVerified, DateTime? createdAt
});




}
/// @nodoc
class __$PublicUserCopyWithImpl<$Res>
    implements _$PublicUserCopyWith<$Res> {
  __$PublicUserCopyWithImpl(this._self, this._then);

  final _PublicUser _self;
  final $Res Function(_PublicUser) _then;

/// Create a copy of PublicUser
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? uuid = null,Object? email = null,Object? phone = null,Object? role = null,Object? emailVerified = null,Object? phoneVerified = null,Object? createdAt = freezed,}) {
  return _then(_PublicUser(
uuid: null == uuid ? _self.uuid : uuid // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as Role,emailVerified: null == emailVerified ? _self.emailVerified : emailVerified // ignore: cast_nullable_to_non_nullable
as bool,phoneVerified: null == phoneVerified ? _self.phoneVerified : phoneVerified // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
