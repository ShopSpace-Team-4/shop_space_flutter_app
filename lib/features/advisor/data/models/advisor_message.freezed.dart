// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'advisor_message.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AdvisorMessage {

 String get id; AdvisorRole get role; String get content; List<AdvisorSource> get sources; String? get disclaimer; List<BrowseListing> get recommendedListings; DateTime get createdAt;
/// Create a copy of AdvisorMessage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdvisorMessageCopyWith<AdvisorMessage> get copyWith => _$AdvisorMessageCopyWithImpl<AdvisorMessage>(this as AdvisorMessage, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdvisorMessage&&(identical(other.id, id) || other.id == id)&&(identical(other.role, role) || other.role == role)&&(identical(other.content, content) || other.content == content)&&const DeepCollectionEquality().equals(other.sources, sources)&&(identical(other.disclaimer, disclaimer) || other.disclaimer == disclaimer)&&const DeepCollectionEquality().equals(other.recommendedListings, recommendedListings)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,role,content,const DeepCollectionEquality().hash(sources),disclaimer,const DeepCollectionEquality().hash(recommendedListings),createdAt);

@override
String toString() {
  return 'AdvisorMessage(id: $id, role: $role, content: $content, sources: $sources, disclaimer: $disclaimer, recommendedListings: $recommendedListings, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $AdvisorMessageCopyWith<$Res>  {
  factory $AdvisorMessageCopyWith(AdvisorMessage value, $Res Function(AdvisorMessage) _then) = _$AdvisorMessageCopyWithImpl;
@useResult
$Res call({
 String id, AdvisorRole role, String content, List<AdvisorSource> sources, String? disclaimer, List<BrowseListing> recommendedListings, DateTime createdAt
});




}
/// @nodoc
class _$AdvisorMessageCopyWithImpl<$Res>
    implements $AdvisorMessageCopyWith<$Res> {
  _$AdvisorMessageCopyWithImpl(this._self, this._then);

  final AdvisorMessage _self;
  final $Res Function(AdvisorMessage) _then;

/// Create a copy of AdvisorMessage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? role = null,Object? content = null,Object? sources = null,Object? disclaimer = freezed,Object? recommendedListings = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as AdvisorRole,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,sources: null == sources ? _self.sources : sources // ignore: cast_nullable_to_non_nullable
as List<AdvisorSource>,disclaimer: freezed == disclaimer ? _self.disclaimer : disclaimer // ignore: cast_nullable_to_non_nullable
as String?,recommendedListings: null == recommendedListings ? _self.recommendedListings : recommendedListings // ignore: cast_nullable_to_non_nullable
as List<BrowseListing>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [AdvisorMessage].
extension AdvisorMessagePatterns on AdvisorMessage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdvisorMessage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdvisorMessage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdvisorMessage value)  $default,){
final _that = this;
switch (_that) {
case _AdvisorMessage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdvisorMessage value)?  $default,){
final _that = this;
switch (_that) {
case _AdvisorMessage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  AdvisorRole role,  String content,  List<AdvisorSource> sources,  String? disclaimer,  List<BrowseListing> recommendedListings,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdvisorMessage() when $default != null:
return $default(_that.id,_that.role,_that.content,_that.sources,_that.disclaimer,_that.recommendedListings,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  AdvisorRole role,  String content,  List<AdvisorSource> sources,  String? disclaimer,  List<BrowseListing> recommendedListings,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _AdvisorMessage():
return $default(_that.id,_that.role,_that.content,_that.sources,_that.disclaimer,_that.recommendedListings,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  AdvisorRole role,  String content,  List<AdvisorSource> sources,  String? disclaimer,  List<BrowseListing> recommendedListings,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _AdvisorMessage() when $default != null:
return $default(_that.id,_that.role,_that.content,_that.sources,_that.disclaimer,_that.recommendedListings,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc


class _AdvisorMessage implements AdvisorMessage {
  const _AdvisorMessage({required this.id, required this.role, required this.content, final  List<AdvisorSource> sources = const <AdvisorSource>[], this.disclaimer, final  List<BrowseListing> recommendedListings = const <BrowseListing>[], required this.createdAt}): _sources = sources,_recommendedListings = recommendedListings;
  

@override final  String id;
@override final  AdvisorRole role;
@override final  String content;
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

@override final  DateTime createdAt;

/// Create a copy of AdvisorMessage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdvisorMessageCopyWith<_AdvisorMessage> get copyWith => __$AdvisorMessageCopyWithImpl<_AdvisorMessage>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdvisorMessage&&(identical(other.id, id) || other.id == id)&&(identical(other.role, role) || other.role == role)&&(identical(other.content, content) || other.content == content)&&const DeepCollectionEquality().equals(other._sources, _sources)&&(identical(other.disclaimer, disclaimer) || other.disclaimer == disclaimer)&&const DeepCollectionEquality().equals(other._recommendedListings, _recommendedListings)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,role,content,const DeepCollectionEquality().hash(_sources),disclaimer,const DeepCollectionEquality().hash(_recommendedListings),createdAt);

@override
String toString() {
  return 'AdvisorMessage(id: $id, role: $role, content: $content, sources: $sources, disclaimer: $disclaimer, recommendedListings: $recommendedListings, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$AdvisorMessageCopyWith<$Res> implements $AdvisorMessageCopyWith<$Res> {
  factory _$AdvisorMessageCopyWith(_AdvisorMessage value, $Res Function(_AdvisorMessage) _then) = __$AdvisorMessageCopyWithImpl;
@override @useResult
$Res call({
 String id, AdvisorRole role, String content, List<AdvisorSource> sources, String? disclaimer, List<BrowseListing> recommendedListings, DateTime createdAt
});




}
/// @nodoc
class __$AdvisorMessageCopyWithImpl<$Res>
    implements _$AdvisorMessageCopyWith<$Res> {
  __$AdvisorMessageCopyWithImpl(this._self, this._then);

  final _AdvisorMessage _self;
  final $Res Function(_AdvisorMessage) _then;

/// Create a copy of AdvisorMessage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? role = null,Object? content = null,Object? sources = null,Object? disclaimer = freezed,Object? recommendedListings = null,Object? createdAt = null,}) {
  return _then(_AdvisorMessage(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as AdvisorRole,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,sources: null == sources ? _self._sources : sources // ignore: cast_nullable_to_non_nullable
as List<AdvisorSource>,disclaimer: freezed == disclaimer ? _self.disclaimer : disclaimer // ignore: cast_nullable_to_non_nullable
as String?,recommendedListings: null == recommendedListings ? _self._recommendedListings : recommendedListings // ignore: cast_nullable_to_non_nullable
as List<BrowseListing>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
