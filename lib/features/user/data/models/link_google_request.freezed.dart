// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'link_google_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LinkGoogleRequest {

 String get idToken;
/// Create a copy of LinkGoogleRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LinkGoogleRequestCopyWith<LinkGoogleRequest> get copyWith => _$LinkGoogleRequestCopyWithImpl<LinkGoogleRequest>(this as LinkGoogleRequest, _$identity);

  /// Serializes this LinkGoogleRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LinkGoogleRequest&&(identical(other.idToken, idToken) || other.idToken == idToken));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,idToken);

@override
String toString() {
  return 'LinkGoogleRequest(idToken: $idToken)';
}


}

/// @nodoc
abstract mixin class $LinkGoogleRequestCopyWith<$Res>  {
  factory $LinkGoogleRequestCopyWith(LinkGoogleRequest value, $Res Function(LinkGoogleRequest) _then) = _$LinkGoogleRequestCopyWithImpl;
@useResult
$Res call({
 String idToken
});




}
/// @nodoc
class _$LinkGoogleRequestCopyWithImpl<$Res>
    implements $LinkGoogleRequestCopyWith<$Res> {
  _$LinkGoogleRequestCopyWithImpl(this._self, this._then);

  final LinkGoogleRequest _self;
  final $Res Function(LinkGoogleRequest) _then;

/// Create a copy of LinkGoogleRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? idToken = null,}) {
  return _then(_self.copyWith(
idToken: null == idToken ? _self.idToken : idToken // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [LinkGoogleRequest].
extension LinkGoogleRequestPatterns on LinkGoogleRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LinkGoogleRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LinkGoogleRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LinkGoogleRequest value)  $default,){
final _that = this;
switch (_that) {
case _LinkGoogleRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LinkGoogleRequest value)?  $default,){
final _that = this;
switch (_that) {
case _LinkGoogleRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String idToken)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LinkGoogleRequest() when $default != null:
return $default(_that.idToken);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String idToken)  $default,) {final _that = this;
switch (_that) {
case _LinkGoogleRequest():
return $default(_that.idToken);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String idToken)?  $default,) {final _that = this;
switch (_that) {
case _LinkGoogleRequest() when $default != null:
return $default(_that.idToken);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LinkGoogleRequest implements LinkGoogleRequest {
  const _LinkGoogleRequest({required this.idToken});
  factory _LinkGoogleRequest.fromJson(Map<String, dynamic> json) => _$LinkGoogleRequestFromJson(json);

@override final  String idToken;

/// Create a copy of LinkGoogleRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LinkGoogleRequestCopyWith<_LinkGoogleRequest> get copyWith => __$LinkGoogleRequestCopyWithImpl<_LinkGoogleRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LinkGoogleRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LinkGoogleRequest&&(identical(other.idToken, idToken) || other.idToken == idToken));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,idToken);

@override
String toString() {
  return 'LinkGoogleRequest(idToken: $idToken)';
}


}

/// @nodoc
abstract mixin class _$LinkGoogleRequestCopyWith<$Res> implements $LinkGoogleRequestCopyWith<$Res> {
  factory _$LinkGoogleRequestCopyWith(_LinkGoogleRequest value, $Res Function(_LinkGoogleRequest) _then) = __$LinkGoogleRequestCopyWithImpl;
@override @useResult
$Res call({
 String idToken
});




}
/// @nodoc
class __$LinkGoogleRequestCopyWithImpl<$Res>
    implements _$LinkGoogleRequestCopyWith<$Res> {
  __$LinkGoogleRequestCopyWithImpl(this._self, this._then);

  final _LinkGoogleRequest _self;
  final $Res Function(_LinkGoogleRequest) _then;

/// Create a copy of LinkGoogleRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? idToken = null,}) {
  return _then(_LinkGoogleRequest(
idToken: null == idToken ? _self.idToken : idToken // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
