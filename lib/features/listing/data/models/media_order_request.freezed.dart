// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'media_order_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MediaOrderEntry {

 String get mediaId; int get sortOrder;
/// Create a copy of MediaOrderEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MediaOrderEntryCopyWith<MediaOrderEntry> get copyWith => _$MediaOrderEntryCopyWithImpl<MediaOrderEntry>(this as MediaOrderEntry, _$identity);

  /// Serializes this MediaOrderEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MediaOrderEntry&&(identical(other.mediaId, mediaId) || other.mediaId == mediaId)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,mediaId,sortOrder);

@override
String toString() {
  return 'MediaOrderEntry(mediaId: $mediaId, sortOrder: $sortOrder)';
}


}

/// @nodoc
abstract mixin class $MediaOrderEntryCopyWith<$Res>  {
  factory $MediaOrderEntryCopyWith(MediaOrderEntry value, $Res Function(MediaOrderEntry) _then) = _$MediaOrderEntryCopyWithImpl;
@useResult
$Res call({
 String mediaId, int sortOrder
});




}
/// @nodoc
class _$MediaOrderEntryCopyWithImpl<$Res>
    implements $MediaOrderEntryCopyWith<$Res> {
  _$MediaOrderEntryCopyWithImpl(this._self, this._then);

  final MediaOrderEntry _self;
  final $Res Function(MediaOrderEntry) _then;

/// Create a copy of MediaOrderEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? mediaId = null,Object? sortOrder = null,}) {
  return _then(_self.copyWith(
mediaId: null == mediaId ? _self.mediaId : mediaId // ignore: cast_nullable_to_non_nullable
as String,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [MediaOrderEntry].
extension MediaOrderEntryPatterns on MediaOrderEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MediaOrderEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MediaOrderEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MediaOrderEntry value)  $default,){
final _that = this;
switch (_that) {
case _MediaOrderEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MediaOrderEntry value)?  $default,){
final _that = this;
switch (_that) {
case _MediaOrderEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String mediaId,  int sortOrder)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MediaOrderEntry() when $default != null:
return $default(_that.mediaId,_that.sortOrder);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String mediaId,  int sortOrder)  $default,) {final _that = this;
switch (_that) {
case _MediaOrderEntry():
return $default(_that.mediaId,_that.sortOrder);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String mediaId,  int sortOrder)?  $default,) {final _that = this;
switch (_that) {
case _MediaOrderEntry() when $default != null:
return $default(_that.mediaId,_that.sortOrder);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MediaOrderEntry implements MediaOrderEntry {
  const _MediaOrderEntry({required this.mediaId, required this.sortOrder});
  factory _MediaOrderEntry.fromJson(Map<String, dynamic> json) => _$MediaOrderEntryFromJson(json);

@override final  String mediaId;
@override final  int sortOrder;

/// Create a copy of MediaOrderEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MediaOrderEntryCopyWith<_MediaOrderEntry> get copyWith => __$MediaOrderEntryCopyWithImpl<_MediaOrderEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MediaOrderEntryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MediaOrderEntry&&(identical(other.mediaId, mediaId) || other.mediaId == mediaId)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,mediaId,sortOrder);

@override
String toString() {
  return 'MediaOrderEntry(mediaId: $mediaId, sortOrder: $sortOrder)';
}


}

/// @nodoc
abstract mixin class _$MediaOrderEntryCopyWith<$Res> implements $MediaOrderEntryCopyWith<$Res> {
  factory _$MediaOrderEntryCopyWith(_MediaOrderEntry value, $Res Function(_MediaOrderEntry) _then) = __$MediaOrderEntryCopyWithImpl;
@override @useResult
$Res call({
 String mediaId, int sortOrder
});




}
/// @nodoc
class __$MediaOrderEntryCopyWithImpl<$Res>
    implements _$MediaOrderEntryCopyWith<$Res> {
  __$MediaOrderEntryCopyWithImpl(this._self, this._then);

  final _MediaOrderEntry _self;
  final $Res Function(_MediaOrderEntry) _then;

/// Create a copy of MediaOrderEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? mediaId = null,Object? sortOrder = null,}) {
  return _then(_MediaOrderEntry(
mediaId: null == mediaId ? _self.mediaId : mediaId // ignore: cast_nullable_to_non_nullable
as String,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$MediaOrderRequest {

 List<MediaOrderEntry> get media;
/// Create a copy of MediaOrderRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MediaOrderRequestCopyWith<MediaOrderRequest> get copyWith => _$MediaOrderRequestCopyWithImpl<MediaOrderRequest>(this as MediaOrderRequest, _$identity);

  /// Serializes this MediaOrderRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MediaOrderRequest&&const DeepCollectionEquality().equals(other.media, media));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(media));

@override
String toString() {
  return 'MediaOrderRequest(media: $media)';
}


}

/// @nodoc
abstract mixin class $MediaOrderRequestCopyWith<$Res>  {
  factory $MediaOrderRequestCopyWith(MediaOrderRequest value, $Res Function(MediaOrderRequest) _then) = _$MediaOrderRequestCopyWithImpl;
@useResult
$Res call({
 List<MediaOrderEntry> media
});




}
/// @nodoc
class _$MediaOrderRequestCopyWithImpl<$Res>
    implements $MediaOrderRequestCopyWith<$Res> {
  _$MediaOrderRequestCopyWithImpl(this._self, this._then);

  final MediaOrderRequest _self;
  final $Res Function(MediaOrderRequest) _then;

/// Create a copy of MediaOrderRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? media = null,}) {
  return _then(_self.copyWith(
media: null == media ? _self.media : media // ignore: cast_nullable_to_non_nullable
as List<MediaOrderEntry>,
  ));
}

}


/// Adds pattern-matching-related methods to [MediaOrderRequest].
extension MediaOrderRequestPatterns on MediaOrderRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MediaOrderRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MediaOrderRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MediaOrderRequest value)  $default,){
final _that = this;
switch (_that) {
case _MediaOrderRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MediaOrderRequest value)?  $default,){
final _that = this;
switch (_that) {
case _MediaOrderRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<MediaOrderEntry> media)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MediaOrderRequest() when $default != null:
return $default(_that.media);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<MediaOrderEntry> media)  $default,) {final _that = this;
switch (_that) {
case _MediaOrderRequest():
return $default(_that.media);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<MediaOrderEntry> media)?  $default,) {final _that = this;
switch (_that) {
case _MediaOrderRequest() when $default != null:
return $default(_that.media);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MediaOrderRequest implements MediaOrderRequest {
  const _MediaOrderRequest({required final  List<MediaOrderEntry> media}): _media = media;
  factory _MediaOrderRequest.fromJson(Map<String, dynamic> json) => _$MediaOrderRequestFromJson(json);

 final  List<MediaOrderEntry> _media;
@override List<MediaOrderEntry> get media {
  if (_media is EqualUnmodifiableListView) return _media;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_media);
}


/// Create a copy of MediaOrderRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MediaOrderRequestCopyWith<_MediaOrderRequest> get copyWith => __$MediaOrderRequestCopyWithImpl<_MediaOrderRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MediaOrderRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MediaOrderRequest&&const DeepCollectionEquality().equals(other._media, _media));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_media));

@override
String toString() {
  return 'MediaOrderRequest(media: $media)';
}


}

/// @nodoc
abstract mixin class _$MediaOrderRequestCopyWith<$Res> implements $MediaOrderRequestCopyWith<$Res> {
  factory _$MediaOrderRequestCopyWith(_MediaOrderRequest value, $Res Function(_MediaOrderRequest) _then) = __$MediaOrderRequestCopyWithImpl;
@override @useResult
$Res call({
 List<MediaOrderEntry> media
});




}
/// @nodoc
class __$MediaOrderRequestCopyWithImpl<$Res>
    implements _$MediaOrderRequestCopyWith<$Res> {
  __$MediaOrderRequestCopyWithImpl(this._self, this._then);

  final _MediaOrderRequest _self;
  final $Res Function(_MediaOrderRequest) _then;

/// Create a copy of MediaOrderRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? media = null,}) {
  return _then(_MediaOrderRequest(
media: null == media ? _self._media : media // ignore: cast_nullable_to_non_nullable
as List<MediaOrderEntry>,
  ));
}


}

// dart format on
