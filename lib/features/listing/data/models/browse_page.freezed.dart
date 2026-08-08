// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'browse_page.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BrowsePage {

 List<BrowseListing> get items; BrowseMeta get meta;
/// Create a copy of BrowsePage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BrowsePageCopyWith<BrowsePage> get copyWith => _$BrowsePageCopyWithImpl<BrowsePage>(this as BrowsePage, _$identity);

  /// Serializes this BrowsePage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BrowsePage&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.meta, meta) || other.meta == meta));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items),meta);

@override
String toString() {
  return 'BrowsePage(items: $items, meta: $meta)';
}


}

/// @nodoc
abstract mixin class $BrowsePageCopyWith<$Res>  {
  factory $BrowsePageCopyWith(BrowsePage value, $Res Function(BrowsePage) _then) = _$BrowsePageCopyWithImpl;
@useResult
$Res call({
 List<BrowseListing> items, BrowseMeta meta
});


$BrowseMetaCopyWith<$Res> get meta;

}
/// @nodoc
class _$BrowsePageCopyWithImpl<$Res>
    implements $BrowsePageCopyWith<$Res> {
  _$BrowsePageCopyWithImpl(this._self, this._then);

  final BrowsePage _self;
  final $Res Function(BrowsePage) _then;

/// Create a copy of BrowsePage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? meta = null,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<BrowseListing>,meta: null == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as BrowseMeta,
  ));
}
/// Create a copy of BrowsePage
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BrowseMetaCopyWith<$Res> get meta {
  
  return $BrowseMetaCopyWith<$Res>(_self.meta, (value) {
    return _then(_self.copyWith(meta: value));
  });
}
}


/// Adds pattern-matching-related methods to [BrowsePage].
extension BrowsePagePatterns on BrowsePage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BrowsePage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BrowsePage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BrowsePage value)  $default,){
final _that = this;
switch (_that) {
case _BrowsePage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BrowsePage value)?  $default,){
final _that = this;
switch (_that) {
case _BrowsePage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<BrowseListing> items,  BrowseMeta meta)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BrowsePage() when $default != null:
return $default(_that.items,_that.meta);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<BrowseListing> items,  BrowseMeta meta)  $default,) {final _that = this;
switch (_that) {
case _BrowsePage():
return $default(_that.items,_that.meta);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<BrowseListing> items,  BrowseMeta meta)?  $default,) {final _that = this;
switch (_that) {
case _BrowsePage() when $default != null:
return $default(_that.items,_that.meta);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BrowsePage implements BrowsePage {
  const _BrowsePage({required final  List<BrowseListing> items, required this.meta}): _items = items;
  factory _BrowsePage.fromJson(Map<String, dynamic> json) => _$BrowsePageFromJson(json);

 final  List<BrowseListing> _items;
@override List<BrowseListing> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  BrowseMeta meta;

/// Create a copy of BrowsePage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BrowsePageCopyWith<_BrowsePage> get copyWith => __$BrowsePageCopyWithImpl<_BrowsePage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BrowsePageToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BrowsePage&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.meta, meta) || other.meta == meta));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),meta);

@override
String toString() {
  return 'BrowsePage(items: $items, meta: $meta)';
}


}

/// @nodoc
abstract mixin class _$BrowsePageCopyWith<$Res> implements $BrowsePageCopyWith<$Res> {
  factory _$BrowsePageCopyWith(_BrowsePage value, $Res Function(_BrowsePage) _then) = __$BrowsePageCopyWithImpl;
@override @useResult
$Res call({
 List<BrowseListing> items, BrowseMeta meta
});


@override $BrowseMetaCopyWith<$Res> get meta;

}
/// @nodoc
class __$BrowsePageCopyWithImpl<$Res>
    implements _$BrowsePageCopyWith<$Res> {
  __$BrowsePageCopyWithImpl(this._self, this._then);

  final _BrowsePage _self;
  final $Res Function(_BrowsePage) _then;

/// Create a copy of BrowsePage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? meta = null,}) {
  return _then(_BrowsePage(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<BrowseListing>,meta: null == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as BrowseMeta,
  ));
}

/// Create a copy of BrowsePage
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BrowseMetaCopyWith<$Res> get meta {
  
  return $BrowseMetaCopyWith<$Res>(_self.meta, (value) {
    return _then(_self.copyWith(meta: value));
  });
}
}


/// @nodoc
mixin _$BrowseMeta {

 int get page; int get limit; int get total; int get pages;
/// Create a copy of BrowseMeta
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BrowseMetaCopyWith<BrowseMeta> get copyWith => _$BrowseMetaCopyWithImpl<BrowseMeta>(this as BrowseMeta, _$identity);

  /// Serializes this BrowseMeta to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BrowseMeta&&(identical(other.page, page) || other.page == page)&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.total, total) || other.total == total)&&(identical(other.pages, pages) || other.pages == pages));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,page,limit,total,pages);

@override
String toString() {
  return 'BrowseMeta(page: $page, limit: $limit, total: $total, pages: $pages)';
}


}

/// @nodoc
abstract mixin class $BrowseMetaCopyWith<$Res>  {
  factory $BrowseMetaCopyWith(BrowseMeta value, $Res Function(BrowseMeta) _then) = _$BrowseMetaCopyWithImpl;
@useResult
$Res call({
 int page, int limit, int total, int pages
});




}
/// @nodoc
class _$BrowseMetaCopyWithImpl<$Res>
    implements $BrowseMetaCopyWith<$Res> {
  _$BrowseMetaCopyWithImpl(this._self, this._then);

  final BrowseMeta _self;
  final $Res Function(BrowseMeta) _then;

/// Create a copy of BrowseMeta
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? page = null,Object? limit = null,Object? total = null,Object? pages = null,}) {
  return _then(_self.copyWith(
page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,pages: null == pages ? _self.pages : pages // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [BrowseMeta].
extension BrowseMetaPatterns on BrowseMeta {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BrowseMeta value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BrowseMeta() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BrowseMeta value)  $default,){
final _that = this;
switch (_that) {
case _BrowseMeta():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BrowseMeta value)?  $default,){
final _that = this;
switch (_that) {
case _BrowseMeta() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int page,  int limit,  int total,  int pages)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BrowseMeta() when $default != null:
return $default(_that.page,_that.limit,_that.total,_that.pages);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int page,  int limit,  int total,  int pages)  $default,) {final _that = this;
switch (_that) {
case _BrowseMeta():
return $default(_that.page,_that.limit,_that.total,_that.pages);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int page,  int limit,  int total,  int pages)?  $default,) {final _that = this;
switch (_that) {
case _BrowseMeta() when $default != null:
return $default(_that.page,_that.limit,_that.total,_that.pages);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BrowseMeta implements BrowseMeta {
  const _BrowseMeta({required this.page, required this.limit, required this.total, required this.pages});
  factory _BrowseMeta.fromJson(Map<String, dynamic> json) => _$BrowseMetaFromJson(json);

@override final  int page;
@override final  int limit;
@override final  int total;
@override final  int pages;

/// Create a copy of BrowseMeta
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BrowseMetaCopyWith<_BrowseMeta> get copyWith => __$BrowseMetaCopyWithImpl<_BrowseMeta>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BrowseMetaToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BrowseMeta&&(identical(other.page, page) || other.page == page)&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.total, total) || other.total == total)&&(identical(other.pages, pages) || other.pages == pages));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,page,limit,total,pages);

@override
String toString() {
  return 'BrowseMeta(page: $page, limit: $limit, total: $total, pages: $pages)';
}


}

/// @nodoc
abstract mixin class _$BrowseMetaCopyWith<$Res> implements $BrowseMetaCopyWith<$Res> {
  factory _$BrowseMetaCopyWith(_BrowseMeta value, $Res Function(_BrowseMeta) _then) = __$BrowseMetaCopyWithImpl;
@override @useResult
$Res call({
 int page, int limit, int total, int pages
});




}
/// @nodoc
class __$BrowseMetaCopyWithImpl<$Res>
    implements _$BrowseMetaCopyWith<$Res> {
  __$BrowseMetaCopyWithImpl(this._self, this._then);

  final _BrowseMeta _self;
  final $Res Function(_BrowseMeta) _then;

/// Create a copy of BrowseMeta
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? page = null,Object? limit = null,Object? total = null,Object? pages = null,}) {
  return _then(_BrowseMeta(
page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,pages: null == pages ? _self.pages : pages // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
