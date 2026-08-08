// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'listing_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ListingSummary {

 String get id; String get title; String get category; double get areaSqm; double get annualRent; String get currency;@ListingStatusConverter() ListingStatus get status; String? get thumbnailUrl;
/// Create a copy of ListingSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ListingSummaryCopyWith<ListingSummary> get copyWith => _$ListingSummaryCopyWithImpl<ListingSummary>(this as ListingSummary, _$identity);

  /// Serializes this ListingSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ListingSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.category, category) || other.category == category)&&(identical(other.areaSqm, areaSqm) || other.areaSqm == areaSqm)&&(identical(other.annualRent, annualRent) || other.annualRent == annualRent)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.status, status) || other.status == status)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,category,areaSqm,annualRent,currency,status,thumbnailUrl);

@override
String toString() {
  return 'ListingSummary(id: $id, title: $title, category: $category, areaSqm: $areaSqm, annualRent: $annualRent, currency: $currency, status: $status, thumbnailUrl: $thumbnailUrl)';
}


}

/// @nodoc
abstract mixin class $ListingSummaryCopyWith<$Res>  {
  factory $ListingSummaryCopyWith(ListingSummary value, $Res Function(ListingSummary) _then) = _$ListingSummaryCopyWithImpl;
@useResult
$Res call({
 String id, String title, String category, double areaSqm, double annualRent, String currency,@ListingStatusConverter() ListingStatus status, String? thumbnailUrl
});




}
/// @nodoc
class _$ListingSummaryCopyWithImpl<$Res>
    implements $ListingSummaryCopyWith<$Res> {
  _$ListingSummaryCopyWithImpl(this._self, this._then);

  final ListingSummary _self;
  final $Res Function(ListingSummary) _then;

/// Create a copy of ListingSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? category = null,Object? areaSqm = null,Object? annualRent = null,Object? currency = null,Object? status = null,Object? thumbnailUrl = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,areaSqm: null == areaSqm ? _self.areaSqm : areaSqm // ignore: cast_nullable_to_non_nullable
as double,annualRent: null == annualRent ? _self.annualRent : annualRent // ignore: cast_nullable_to_non_nullable
as double,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ListingStatus,thumbnailUrl: freezed == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ListingSummary].
extension ListingSummaryPatterns on ListingSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ListingSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ListingSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ListingSummary value)  $default,){
final _that = this;
switch (_that) {
case _ListingSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ListingSummary value)?  $default,){
final _that = this;
switch (_that) {
case _ListingSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String category,  double areaSqm,  double annualRent,  String currency, @ListingStatusConverter()  ListingStatus status,  String? thumbnailUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ListingSummary() when $default != null:
return $default(_that.id,_that.title,_that.category,_that.areaSqm,_that.annualRent,_that.currency,_that.status,_that.thumbnailUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String category,  double areaSqm,  double annualRent,  String currency, @ListingStatusConverter()  ListingStatus status,  String? thumbnailUrl)  $default,) {final _that = this;
switch (_that) {
case _ListingSummary():
return $default(_that.id,_that.title,_that.category,_that.areaSqm,_that.annualRent,_that.currency,_that.status,_that.thumbnailUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String category,  double areaSqm,  double annualRent,  String currency, @ListingStatusConverter()  ListingStatus status,  String? thumbnailUrl)?  $default,) {final _that = this;
switch (_that) {
case _ListingSummary() when $default != null:
return $default(_that.id,_that.title,_that.category,_that.areaSqm,_that.annualRent,_that.currency,_that.status,_that.thumbnailUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ListingSummary implements ListingSummary {
  const _ListingSummary({required this.id, required this.title, required this.category, required this.areaSqm, required this.annualRent, required this.currency, @ListingStatusConverter() required this.status, this.thumbnailUrl});
  factory _ListingSummary.fromJson(Map<String, dynamic> json) => _$ListingSummaryFromJson(json);

@override final  String id;
@override final  String title;
@override final  String category;
@override final  double areaSqm;
@override final  double annualRent;
@override final  String currency;
@override@ListingStatusConverter() final  ListingStatus status;
@override final  String? thumbnailUrl;

/// Create a copy of ListingSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ListingSummaryCopyWith<_ListingSummary> get copyWith => __$ListingSummaryCopyWithImpl<_ListingSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ListingSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ListingSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.category, category) || other.category == category)&&(identical(other.areaSqm, areaSqm) || other.areaSqm == areaSqm)&&(identical(other.annualRent, annualRent) || other.annualRent == annualRent)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.status, status) || other.status == status)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,category,areaSqm,annualRent,currency,status,thumbnailUrl);

@override
String toString() {
  return 'ListingSummary(id: $id, title: $title, category: $category, areaSqm: $areaSqm, annualRent: $annualRent, currency: $currency, status: $status, thumbnailUrl: $thumbnailUrl)';
}


}

/// @nodoc
abstract mixin class _$ListingSummaryCopyWith<$Res> implements $ListingSummaryCopyWith<$Res> {
  factory _$ListingSummaryCopyWith(_ListingSummary value, $Res Function(_ListingSummary) _then) = __$ListingSummaryCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String category, double areaSqm, double annualRent, String currency,@ListingStatusConverter() ListingStatus status, String? thumbnailUrl
});




}
/// @nodoc
class __$ListingSummaryCopyWithImpl<$Res>
    implements _$ListingSummaryCopyWith<$Res> {
  __$ListingSummaryCopyWithImpl(this._self, this._then);

  final _ListingSummary _self;
  final $Res Function(_ListingSummary) _then;

/// Create a copy of ListingSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? category = null,Object? areaSqm = null,Object? annualRent = null,Object? currency = null,Object? status = null,Object? thumbnailUrl = freezed,}) {
  return _then(_ListingSummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,areaSqm: null == areaSqm ? _self.areaSqm : areaSqm // ignore: cast_nullable_to_non_nullable
as double,annualRent: null == annualRent ? _self.annualRent : annualRent // ignore: cast_nullable_to_non_nullable
as double,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ListingStatus,thumbnailUrl: freezed == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
