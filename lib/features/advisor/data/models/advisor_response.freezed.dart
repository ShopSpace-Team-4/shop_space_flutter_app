// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'advisor_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AdvisorResponse {

 String? get sessionId; String get answer; List<AdvisorSource> get sources; String? get disclaimer; List<BrowseListing> get recommendedListings;
/// Create a copy of AdvisorResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdvisorResponseCopyWith<AdvisorResponse> get copyWith => _$AdvisorResponseCopyWithImpl<AdvisorResponse>(this as AdvisorResponse, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdvisorResponse&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.answer, answer) || other.answer == answer)&&const DeepCollectionEquality().equals(other.sources, sources)&&(identical(other.disclaimer, disclaimer) || other.disclaimer == disclaimer)&&const DeepCollectionEquality().equals(other.recommendedListings, recommendedListings));
}


@override
int get hashCode => Object.hash(runtimeType,sessionId,answer,const DeepCollectionEquality().hash(sources),disclaimer,const DeepCollectionEquality().hash(recommendedListings));

@override
String toString() {
  return 'AdvisorResponse(sessionId: $sessionId, answer: $answer, sources: $sources, disclaimer: $disclaimer, recommendedListings: $recommendedListings)';
}


}

/// @nodoc
abstract mixin class $AdvisorResponseCopyWith<$Res>  {
  factory $AdvisorResponseCopyWith(AdvisorResponse value, $Res Function(AdvisorResponse) _then) = _$AdvisorResponseCopyWithImpl;
@useResult
$Res call({
 String? sessionId, String answer, List<AdvisorSource> sources, String? disclaimer, List<BrowseListing> recommendedListings
});




}
/// @nodoc
class _$AdvisorResponseCopyWithImpl<$Res>
    implements $AdvisorResponseCopyWith<$Res> {
  _$AdvisorResponseCopyWithImpl(this._self, this._then);

  final AdvisorResponse _self;
  final $Res Function(AdvisorResponse) _then;

/// Create a copy of AdvisorResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sessionId = freezed,Object? answer = null,Object? sources = null,Object? disclaimer = freezed,Object? recommendedListings = null,}) {
  return _then(_self.copyWith(
sessionId: freezed == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String?,answer: null == answer ? _self.answer : answer // ignore: cast_nullable_to_non_nullable
as String,sources: null == sources ? _self.sources : sources // ignore: cast_nullable_to_non_nullable
as List<AdvisorSource>,disclaimer: freezed == disclaimer ? _self.disclaimer : disclaimer // ignore: cast_nullable_to_non_nullable
as String?,recommendedListings: null == recommendedListings ? _self.recommendedListings : recommendedListings // ignore: cast_nullable_to_non_nullable
as List<BrowseListing>,
  ));
}

}


/// Adds pattern-matching-related methods to [AdvisorResponse].
extension AdvisorResponsePatterns on AdvisorResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdvisorResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdvisorResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdvisorResponse value)  $default,){
final _that = this;
switch (_that) {
case _AdvisorResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdvisorResponse value)?  $default,){
final _that = this;
switch (_that) {
case _AdvisorResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? sessionId,  String answer,  List<AdvisorSource> sources,  String? disclaimer,  List<BrowseListing> recommendedListings)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdvisorResponse() when $default != null:
return $default(_that.sessionId,_that.answer,_that.sources,_that.disclaimer,_that.recommendedListings);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? sessionId,  String answer,  List<AdvisorSource> sources,  String? disclaimer,  List<BrowseListing> recommendedListings)  $default,) {final _that = this;
switch (_that) {
case _AdvisorResponse():
return $default(_that.sessionId,_that.answer,_that.sources,_that.disclaimer,_that.recommendedListings);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? sessionId,  String answer,  List<AdvisorSource> sources,  String? disclaimer,  List<BrowseListing> recommendedListings)?  $default,) {final _that = this;
switch (_that) {
case _AdvisorResponse() when $default != null:
return $default(_that.sessionId,_that.answer,_that.sources,_that.disclaimer,_that.recommendedListings);case _:
  return null;

}
}

}

/// @nodoc


class _AdvisorResponse implements AdvisorResponse {
  const _AdvisorResponse({this.sessionId, required this.answer, final  List<AdvisorSource> sources = const <AdvisorSource>[], this.disclaimer, final  List<BrowseListing> recommendedListings = const <BrowseListing>[]}): _sources = sources,_recommendedListings = recommendedListings;
  

@override final  String? sessionId;
@override final  String answer;
 final  List<AdvisorSource> _sources;
@override@JsonKey() List<AdvisorSource> get sources {
  if (_sources is EqualUnmodifiableListView) return _sources;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sources);
}

@override final  String? disclaimer;
 final  List<BrowseListing> _recommendedListings;
@override@JsonKey() List<BrowseListing> get recommendedListings {
  if (_recommendedListings is EqualUnmodifiableListView) return _recommendedListings;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_recommendedListings);
}


/// Create a copy of AdvisorResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdvisorResponseCopyWith<_AdvisorResponse> get copyWith => __$AdvisorResponseCopyWithImpl<_AdvisorResponse>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdvisorResponse&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.answer, answer) || other.answer == answer)&&const DeepCollectionEquality().equals(other._sources, _sources)&&(identical(other.disclaimer, disclaimer) || other.disclaimer == disclaimer)&&const DeepCollectionEquality().equals(other._recommendedListings, _recommendedListings));
}


@override
int get hashCode => Object.hash(runtimeType,sessionId,answer,const DeepCollectionEquality().hash(_sources),disclaimer,const DeepCollectionEquality().hash(_recommendedListings));

@override
String toString() {
  return 'AdvisorResponse(sessionId: $sessionId, answer: $answer, sources: $sources, disclaimer: $disclaimer, recommendedListings: $recommendedListings)';
}


}

/// @nodoc
abstract mixin class _$AdvisorResponseCopyWith<$Res> implements $AdvisorResponseCopyWith<$Res> {
  factory _$AdvisorResponseCopyWith(_AdvisorResponse value, $Res Function(_AdvisorResponse) _then) = __$AdvisorResponseCopyWithImpl;
@override @useResult
$Res call({
 String? sessionId, String answer, List<AdvisorSource> sources, String? disclaimer, List<BrowseListing> recommendedListings
});




}
/// @nodoc
class __$AdvisorResponseCopyWithImpl<$Res>
    implements _$AdvisorResponseCopyWith<$Res> {
  __$AdvisorResponseCopyWithImpl(this._self, this._then);

  final _AdvisorResponse _self;
  final $Res Function(_AdvisorResponse) _then;

/// Create a copy of AdvisorResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sessionId = freezed,Object? answer = null,Object? sources = null,Object? disclaimer = freezed,Object? recommendedListings = null,}) {
  return _then(_AdvisorResponse(
sessionId: freezed == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String?,answer: null == answer ? _self.answer : answer // ignore: cast_nullable_to_non_nullable
as String,sources: null == sources ? _self._sources : sources // ignore: cast_nullable_to_non_nullable
as List<AdvisorSource>,disclaimer: freezed == disclaimer ? _self.disclaimer : disclaimer // ignore: cast_nullable_to_non_nullable
as String?,recommendedListings: null == recommendedListings ? _self._recommendedListings : recommendedListings // ignore: cast_nullable_to_non_nullable
as List<BrowseListing>,
  ));
}


}

// dart format on
