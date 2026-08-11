// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'advisor_source.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AdvisorSource {

@JsonKey(name: 'document_id') String? get documentId; String? get title; String? get category;@JsonKey(name: 'business_type') String? get businessType;
/// Create a copy of AdvisorSource
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdvisorSourceCopyWith<AdvisorSource> get copyWith => _$AdvisorSourceCopyWithImpl<AdvisorSource>(this as AdvisorSource, _$identity);

  /// Serializes this AdvisorSource to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdvisorSource&&(identical(other.documentId, documentId) || other.documentId == documentId)&&(identical(other.title, title) || other.title == title)&&(identical(other.category, category) || other.category == category)&&(identical(other.businessType, businessType) || other.businessType == businessType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,documentId,title,category,businessType);

@override
String toString() {
  return 'AdvisorSource(documentId: $documentId, title: $title, category: $category, businessType: $businessType)';
}


}

/// @nodoc
abstract mixin class $AdvisorSourceCopyWith<$Res>  {
  factory $AdvisorSourceCopyWith(AdvisorSource value, $Res Function(AdvisorSource) _then) = _$AdvisorSourceCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'document_id') String? documentId, String? title, String? category,@JsonKey(name: 'business_type') String? businessType
});




}
/// @nodoc
class _$AdvisorSourceCopyWithImpl<$Res>
    implements $AdvisorSourceCopyWith<$Res> {
  _$AdvisorSourceCopyWithImpl(this._self, this._then);

  final AdvisorSource _self;
  final $Res Function(AdvisorSource) _then;

/// Create a copy of AdvisorSource
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? documentId = freezed,Object? title = freezed,Object? category = freezed,Object? businessType = freezed,}) {
  return _then(_self.copyWith(
documentId: freezed == documentId ? _self.documentId : documentId // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,businessType: freezed == businessType ? _self.businessType : businessType // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AdvisorSource].
extension AdvisorSourcePatterns on AdvisorSource {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdvisorSource value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdvisorSource() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdvisorSource value)  $default,){
final _that = this;
switch (_that) {
case _AdvisorSource():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdvisorSource value)?  $default,){
final _that = this;
switch (_that) {
case _AdvisorSource() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'document_id')  String? documentId,  String? title,  String? category, @JsonKey(name: 'business_type')  String? businessType)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdvisorSource() when $default != null:
return $default(_that.documentId,_that.title,_that.category,_that.businessType);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'document_id')  String? documentId,  String? title,  String? category, @JsonKey(name: 'business_type')  String? businessType)  $default,) {final _that = this;
switch (_that) {
case _AdvisorSource():
return $default(_that.documentId,_that.title,_that.category,_that.businessType);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'document_id')  String? documentId,  String? title,  String? category, @JsonKey(name: 'business_type')  String? businessType)?  $default,) {final _that = this;
switch (_that) {
case _AdvisorSource() when $default != null:
return $default(_that.documentId,_that.title,_that.category,_that.businessType);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AdvisorSource implements AdvisorSource {
  const _AdvisorSource({@JsonKey(name: 'document_id') this.documentId, this.title, this.category, @JsonKey(name: 'business_type') this.businessType});
  factory _AdvisorSource.fromJson(Map<String, dynamic> json) => _$AdvisorSourceFromJson(json);

@override@JsonKey(name: 'document_id') final  String? documentId;
@override final  String? title;
@override final  String? category;
@override@JsonKey(name: 'business_type') final  String? businessType;

/// Create a copy of AdvisorSource
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdvisorSourceCopyWith<_AdvisorSource> get copyWith => __$AdvisorSourceCopyWithImpl<_AdvisorSource>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AdvisorSourceToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdvisorSource&&(identical(other.documentId, documentId) || other.documentId == documentId)&&(identical(other.title, title) || other.title == title)&&(identical(other.category, category) || other.category == category)&&(identical(other.businessType, businessType) || other.businessType == businessType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,documentId,title,category,businessType);

@override
String toString() {
  return 'AdvisorSource(documentId: $documentId, title: $title, category: $category, businessType: $businessType)';
}


}

/// @nodoc
abstract mixin class _$AdvisorSourceCopyWith<$Res> implements $AdvisorSourceCopyWith<$Res> {
  factory _$AdvisorSourceCopyWith(_AdvisorSource value, $Res Function(_AdvisorSource) _then) = __$AdvisorSourceCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'document_id') String? documentId, String? title, String? category,@JsonKey(name: 'business_type') String? businessType
});




}
/// @nodoc
class __$AdvisorSourceCopyWithImpl<$Res>
    implements _$AdvisorSourceCopyWith<$Res> {
  __$AdvisorSourceCopyWithImpl(this._self, this._then);

  final _AdvisorSource _self;
  final $Res Function(_AdvisorSource) _then;

/// Create a copy of AdvisorSource
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? documentId = freezed,Object? title = freezed,Object? category = freezed,Object? businessType = freezed,}) {
  return _then(_AdvisorSource(
documentId: freezed == documentId ? _self.documentId : documentId // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,businessType: freezed == businessType ? _self.businessType : businessType // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
