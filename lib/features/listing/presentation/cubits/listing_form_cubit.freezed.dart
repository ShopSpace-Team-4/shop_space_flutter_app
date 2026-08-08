// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'listing_form_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ListingFormState {

/// 0 details, 1 photos, 2 price/lease, 3 review (data-model.md §4).
 int get step; ListingMeta? get meta; bool get metaLoading; Failure? get metaFailure; Map<String, dynamic> get fields; List<ListingMedia> get existingMedia; List<PendingMedia> get pendingAdds; Set<String> get pendingDeletes; List<StagedMediaEntry> get pendingOrder; bool get preloading; Failure? get preloadFailure; bool get isSubmitting; bool get isUploading; double get uploadProgress; Failure? get submitFailure; bool get isEditMode; String? get createdId; String? get updatedId;
/// Create a copy of ListingFormState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ListingFormStateCopyWith<ListingFormState> get copyWith => _$ListingFormStateCopyWithImpl<ListingFormState>(this as ListingFormState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ListingFormState&&(identical(other.step, step) || other.step == step)&&(identical(other.meta, meta) || other.meta == meta)&&(identical(other.metaLoading, metaLoading) || other.metaLoading == metaLoading)&&(identical(other.metaFailure, metaFailure) || other.metaFailure == metaFailure)&&const DeepCollectionEquality().equals(other.fields, fields)&&const DeepCollectionEquality().equals(other.existingMedia, existingMedia)&&const DeepCollectionEquality().equals(other.pendingAdds, pendingAdds)&&const DeepCollectionEquality().equals(other.pendingDeletes, pendingDeletes)&&const DeepCollectionEquality().equals(other.pendingOrder, pendingOrder)&&(identical(other.preloading, preloading) || other.preloading == preloading)&&(identical(other.preloadFailure, preloadFailure) || other.preloadFailure == preloadFailure)&&(identical(other.isSubmitting, isSubmitting) || other.isSubmitting == isSubmitting)&&(identical(other.isUploading, isUploading) || other.isUploading == isUploading)&&(identical(other.uploadProgress, uploadProgress) || other.uploadProgress == uploadProgress)&&(identical(other.submitFailure, submitFailure) || other.submitFailure == submitFailure)&&(identical(other.isEditMode, isEditMode) || other.isEditMode == isEditMode)&&(identical(other.createdId, createdId) || other.createdId == createdId)&&(identical(other.updatedId, updatedId) || other.updatedId == updatedId));
}


@override
int get hashCode => Object.hash(runtimeType,step,meta,metaLoading,metaFailure,const DeepCollectionEquality().hash(fields),const DeepCollectionEquality().hash(existingMedia),const DeepCollectionEquality().hash(pendingAdds),const DeepCollectionEquality().hash(pendingDeletes),const DeepCollectionEquality().hash(pendingOrder),preloading,preloadFailure,isSubmitting,isUploading,uploadProgress,submitFailure,isEditMode,createdId,updatedId);

@override
String toString() {
  return 'ListingFormState(step: $step, meta: $meta, metaLoading: $metaLoading, metaFailure: $metaFailure, fields: $fields, existingMedia: $existingMedia, pendingAdds: $pendingAdds, pendingDeletes: $pendingDeletes, pendingOrder: $pendingOrder, preloading: $preloading, preloadFailure: $preloadFailure, isSubmitting: $isSubmitting, isUploading: $isUploading, uploadProgress: $uploadProgress, submitFailure: $submitFailure, isEditMode: $isEditMode, createdId: $createdId, updatedId: $updatedId)';
}


}

/// @nodoc
abstract mixin class $ListingFormStateCopyWith<$Res>  {
  factory $ListingFormStateCopyWith(ListingFormState value, $Res Function(ListingFormState) _then) = _$ListingFormStateCopyWithImpl;
@useResult
$Res call({
 int step, ListingMeta? meta, bool metaLoading, Failure? metaFailure, Map<String, dynamic> fields, List<ListingMedia> existingMedia, List<PendingMedia> pendingAdds, Set<String> pendingDeletes, List<StagedMediaEntry> pendingOrder, bool preloading, Failure? preloadFailure, bool isSubmitting, bool isUploading, double uploadProgress, Failure? submitFailure, bool isEditMode, String? createdId, String? updatedId
});


$ListingMetaCopyWith<$Res>? get meta;

}
/// @nodoc
class _$ListingFormStateCopyWithImpl<$Res>
    implements $ListingFormStateCopyWith<$Res> {
  _$ListingFormStateCopyWithImpl(this._self, this._then);

  final ListingFormState _self;
  final $Res Function(ListingFormState) _then;

/// Create a copy of ListingFormState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? step = null,Object? meta = freezed,Object? metaLoading = null,Object? metaFailure = freezed,Object? fields = null,Object? existingMedia = null,Object? pendingAdds = null,Object? pendingDeletes = null,Object? pendingOrder = null,Object? preloading = null,Object? preloadFailure = freezed,Object? isSubmitting = null,Object? isUploading = null,Object? uploadProgress = null,Object? submitFailure = freezed,Object? isEditMode = null,Object? createdId = freezed,Object? updatedId = freezed,}) {
  return _then(_self.copyWith(
step: null == step ? _self.step : step // ignore: cast_nullable_to_non_nullable
as int,meta: freezed == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as ListingMeta?,metaLoading: null == metaLoading ? _self.metaLoading : metaLoading // ignore: cast_nullable_to_non_nullable
as bool,metaFailure: freezed == metaFailure ? _self.metaFailure : metaFailure // ignore: cast_nullable_to_non_nullable
as Failure?,fields: null == fields ? _self.fields : fields // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,existingMedia: null == existingMedia ? _self.existingMedia : existingMedia // ignore: cast_nullable_to_non_nullable
as List<ListingMedia>,pendingAdds: null == pendingAdds ? _self.pendingAdds : pendingAdds // ignore: cast_nullable_to_non_nullable
as List<PendingMedia>,pendingDeletes: null == pendingDeletes ? _self.pendingDeletes : pendingDeletes // ignore: cast_nullable_to_non_nullable
as Set<String>,pendingOrder: null == pendingOrder ? _self.pendingOrder : pendingOrder // ignore: cast_nullable_to_non_nullable
as List<StagedMediaEntry>,preloading: null == preloading ? _self.preloading : preloading // ignore: cast_nullable_to_non_nullable
as bool,preloadFailure: freezed == preloadFailure ? _self.preloadFailure : preloadFailure // ignore: cast_nullable_to_non_nullable
as Failure?,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,isUploading: null == isUploading ? _self.isUploading : isUploading // ignore: cast_nullable_to_non_nullable
as bool,uploadProgress: null == uploadProgress ? _self.uploadProgress : uploadProgress // ignore: cast_nullable_to_non_nullable
as double,submitFailure: freezed == submitFailure ? _self.submitFailure : submitFailure // ignore: cast_nullable_to_non_nullable
as Failure?,isEditMode: null == isEditMode ? _self.isEditMode : isEditMode // ignore: cast_nullable_to_non_nullable
as bool,createdId: freezed == createdId ? _self.createdId : createdId // ignore: cast_nullable_to_non_nullable
as String?,updatedId: freezed == updatedId ? _self.updatedId : updatedId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of ListingFormState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ListingMetaCopyWith<$Res>? get meta {
    if (_self.meta == null) {
    return null;
  }

  return $ListingMetaCopyWith<$Res>(_self.meta!, (value) {
    return _then(_self.copyWith(meta: value));
  });
}
}


/// Adds pattern-matching-related methods to [ListingFormState].
extension ListingFormStatePatterns on ListingFormState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ListingFormState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ListingFormState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ListingFormState value)  $default,){
final _that = this;
switch (_that) {
case _ListingFormState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ListingFormState value)?  $default,){
final _that = this;
switch (_that) {
case _ListingFormState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int step,  ListingMeta? meta,  bool metaLoading,  Failure? metaFailure,  Map<String, dynamic> fields,  List<ListingMedia> existingMedia,  List<PendingMedia> pendingAdds,  Set<String> pendingDeletes,  List<StagedMediaEntry> pendingOrder,  bool preloading,  Failure? preloadFailure,  bool isSubmitting,  bool isUploading,  double uploadProgress,  Failure? submitFailure,  bool isEditMode,  String? createdId,  String? updatedId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ListingFormState() when $default != null:
return $default(_that.step,_that.meta,_that.metaLoading,_that.metaFailure,_that.fields,_that.existingMedia,_that.pendingAdds,_that.pendingDeletes,_that.pendingOrder,_that.preloading,_that.preloadFailure,_that.isSubmitting,_that.isUploading,_that.uploadProgress,_that.submitFailure,_that.isEditMode,_that.createdId,_that.updatedId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int step,  ListingMeta? meta,  bool metaLoading,  Failure? metaFailure,  Map<String, dynamic> fields,  List<ListingMedia> existingMedia,  List<PendingMedia> pendingAdds,  Set<String> pendingDeletes,  List<StagedMediaEntry> pendingOrder,  bool preloading,  Failure? preloadFailure,  bool isSubmitting,  bool isUploading,  double uploadProgress,  Failure? submitFailure,  bool isEditMode,  String? createdId,  String? updatedId)  $default,) {final _that = this;
switch (_that) {
case _ListingFormState():
return $default(_that.step,_that.meta,_that.metaLoading,_that.metaFailure,_that.fields,_that.existingMedia,_that.pendingAdds,_that.pendingDeletes,_that.pendingOrder,_that.preloading,_that.preloadFailure,_that.isSubmitting,_that.isUploading,_that.uploadProgress,_that.submitFailure,_that.isEditMode,_that.createdId,_that.updatedId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int step,  ListingMeta? meta,  bool metaLoading,  Failure? metaFailure,  Map<String, dynamic> fields,  List<ListingMedia> existingMedia,  List<PendingMedia> pendingAdds,  Set<String> pendingDeletes,  List<StagedMediaEntry> pendingOrder,  bool preloading,  Failure? preloadFailure,  bool isSubmitting,  bool isUploading,  double uploadProgress,  Failure? submitFailure,  bool isEditMode,  String? createdId,  String? updatedId)?  $default,) {final _that = this;
switch (_that) {
case _ListingFormState() when $default != null:
return $default(_that.step,_that.meta,_that.metaLoading,_that.metaFailure,_that.fields,_that.existingMedia,_that.pendingAdds,_that.pendingDeletes,_that.pendingOrder,_that.preloading,_that.preloadFailure,_that.isSubmitting,_that.isUploading,_that.uploadProgress,_that.submitFailure,_that.isEditMode,_that.createdId,_that.updatedId);case _:
  return null;

}
}

}

/// @nodoc


class _ListingFormState implements ListingFormState {
  const _ListingFormState({this.step = 0, this.meta, this.metaLoading = false, this.metaFailure, final  Map<String, dynamic> fields = const <String, dynamic>{}, final  List<ListingMedia> existingMedia = const <ListingMedia>[], final  List<PendingMedia> pendingAdds = const <PendingMedia>[], final  Set<String> pendingDeletes = const <String>{}, final  List<StagedMediaEntry> pendingOrder = const <StagedMediaEntry>[], this.preloading = false, this.preloadFailure, this.isSubmitting = false, this.isUploading = false, this.uploadProgress = 0.0, this.submitFailure, this.isEditMode = false, this.createdId, this.updatedId}): _fields = fields,_existingMedia = existingMedia,_pendingAdds = pendingAdds,_pendingDeletes = pendingDeletes,_pendingOrder = pendingOrder;
  

/// 0 details, 1 photos, 2 price/lease, 3 review (data-model.md §4).
@override@JsonKey() final  int step;
@override final  ListingMeta? meta;
@override@JsonKey() final  bool metaLoading;
@override final  Failure? metaFailure;
 final  Map<String, dynamic> _fields;
@override@JsonKey() Map<String, dynamic> get fields {
  if (_fields is EqualUnmodifiableMapView) return _fields;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_fields);
}

 final  List<ListingMedia> _existingMedia;
@override@JsonKey() List<ListingMedia> get existingMedia {
  if (_existingMedia is EqualUnmodifiableListView) return _existingMedia;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_existingMedia);
}

 final  List<PendingMedia> _pendingAdds;
@override@JsonKey() List<PendingMedia> get pendingAdds {
  if (_pendingAdds is EqualUnmodifiableListView) return _pendingAdds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_pendingAdds);
}

 final  Set<String> _pendingDeletes;
@override@JsonKey() Set<String> get pendingDeletes {
  if (_pendingDeletes is EqualUnmodifiableSetView) return _pendingDeletes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_pendingDeletes);
}

 final  List<StagedMediaEntry> _pendingOrder;
@override@JsonKey() List<StagedMediaEntry> get pendingOrder {
  if (_pendingOrder is EqualUnmodifiableListView) return _pendingOrder;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_pendingOrder);
}

@override@JsonKey() final  bool preloading;
@override final  Failure? preloadFailure;
@override@JsonKey() final  bool isSubmitting;
@override@JsonKey() final  bool isUploading;
@override@JsonKey() final  double uploadProgress;
@override final  Failure? submitFailure;
@override@JsonKey() final  bool isEditMode;
@override final  String? createdId;
@override final  String? updatedId;

/// Create a copy of ListingFormState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ListingFormStateCopyWith<_ListingFormState> get copyWith => __$ListingFormStateCopyWithImpl<_ListingFormState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ListingFormState&&(identical(other.step, step) || other.step == step)&&(identical(other.meta, meta) || other.meta == meta)&&(identical(other.metaLoading, metaLoading) || other.metaLoading == metaLoading)&&(identical(other.metaFailure, metaFailure) || other.metaFailure == metaFailure)&&const DeepCollectionEquality().equals(other._fields, _fields)&&const DeepCollectionEquality().equals(other._existingMedia, _existingMedia)&&const DeepCollectionEquality().equals(other._pendingAdds, _pendingAdds)&&const DeepCollectionEquality().equals(other._pendingDeletes, _pendingDeletes)&&const DeepCollectionEquality().equals(other._pendingOrder, _pendingOrder)&&(identical(other.preloading, preloading) || other.preloading == preloading)&&(identical(other.preloadFailure, preloadFailure) || other.preloadFailure == preloadFailure)&&(identical(other.isSubmitting, isSubmitting) || other.isSubmitting == isSubmitting)&&(identical(other.isUploading, isUploading) || other.isUploading == isUploading)&&(identical(other.uploadProgress, uploadProgress) || other.uploadProgress == uploadProgress)&&(identical(other.submitFailure, submitFailure) || other.submitFailure == submitFailure)&&(identical(other.isEditMode, isEditMode) || other.isEditMode == isEditMode)&&(identical(other.createdId, createdId) || other.createdId == createdId)&&(identical(other.updatedId, updatedId) || other.updatedId == updatedId));
}


@override
int get hashCode => Object.hash(runtimeType,step,meta,metaLoading,metaFailure,const DeepCollectionEquality().hash(_fields),const DeepCollectionEquality().hash(_existingMedia),const DeepCollectionEquality().hash(_pendingAdds),const DeepCollectionEquality().hash(_pendingDeletes),const DeepCollectionEquality().hash(_pendingOrder),preloading,preloadFailure,isSubmitting,isUploading,uploadProgress,submitFailure,isEditMode,createdId,updatedId);

@override
String toString() {
  return 'ListingFormState(step: $step, meta: $meta, metaLoading: $metaLoading, metaFailure: $metaFailure, fields: $fields, existingMedia: $existingMedia, pendingAdds: $pendingAdds, pendingDeletes: $pendingDeletes, pendingOrder: $pendingOrder, preloading: $preloading, preloadFailure: $preloadFailure, isSubmitting: $isSubmitting, isUploading: $isUploading, uploadProgress: $uploadProgress, submitFailure: $submitFailure, isEditMode: $isEditMode, createdId: $createdId, updatedId: $updatedId)';
}


}

/// @nodoc
abstract mixin class _$ListingFormStateCopyWith<$Res> implements $ListingFormStateCopyWith<$Res> {
  factory _$ListingFormStateCopyWith(_ListingFormState value, $Res Function(_ListingFormState) _then) = __$ListingFormStateCopyWithImpl;
@override @useResult
$Res call({
 int step, ListingMeta? meta, bool metaLoading, Failure? metaFailure, Map<String, dynamic> fields, List<ListingMedia> existingMedia, List<PendingMedia> pendingAdds, Set<String> pendingDeletes, List<StagedMediaEntry> pendingOrder, bool preloading, Failure? preloadFailure, bool isSubmitting, bool isUploading, double uploadProgress, Failure? submitFailure, bool isEditMode, String? createdId, String? updatedId
});


@override $ListingMetaCopyWith<$Res>? get meta;

}
/// @nodoc
class __$ListingFormStateCopyWithImpl<$Res>
    implements _$ListingFormStateCopyWith<$Res> {
  __$ListingFormStateCopyWithImpl(this._self, this._then);

  final _ListingFormState _self;
  final $Res Function(_ListingFormState) _then;

/// Create a copy of ListingFormState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? step = null,Object? meta = freezed,Object? metaLoading = null,Object? metaFailure = freezed,Object? fields = null,Object? existingMedia = null,Object? pendingAdds = null,Object? pendingDeletes = null,Object? pendingOrder = null,Object? preloading = null,Object? preloadFailure = freezed,Object? isSubmitting = null,Object? isUploading = null,Object? uploadProgress = null,Object? submitFailure = freezed,Object? isEditMode = null,Object? createdId = freezed,Object? updatedId = freezed,}) {
  return _then(_ListingFormState(
step: null == step ? _self.step : step // ignore: cast_nullable_to_non_nullable
as int,meta: freezed == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as ListingMeta?,metaLoading: null == metaLoading ? _self.metaLoading : metaLoading // ignore: cast_nullable_to_non_nullable
as bool,metaFailure: freezed == metaFailure ? _self.metaFailure : metaFailure // ignore: cast_nullable_to_non_nullable
as Failure?,fields: null == fields ? _self._fields : fields // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,existingMedia: null == existingMedia ? _self._existingMedia : existingMedia // ignore: cast_nullable_to_non_nullable
as List<ListingMedia>,pendingAdds: null == pendingAdds ? _self._pendingAdds : pendingAdds // ignore: cast_nullable_to_non_nullable
as List<PendingMedia>,pendingDeletes: null == pendingDeletes ? _self._pendingDeletes : pendingDeletes // ignore: cast_nullable_to_non_nullable
as Set<String>,pendingOrder: null == pendingOrder ? _self._pendingOrder : pendingOrder // ignore: cast_nullable_to_non_nullable
as List<StagedMediaEntry>,preloading: null == preloading ? _self.preloading : preloading // ignore: cast_nullable_to_non_nullable
as bool,preloadFailure: freezed == preloadFailure ? _self.preloadFailure : preloadFailure // ignore: cast_nullable_to_non_nullable
as Failure?,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,isUploading: null == isUploading ? _self.isUploading : isUploading // ignore: cast_nullable_to_non_nullable
as bool,uploadProgress: null == uploadProgress ? _self.uploadProgress : uploadProgress // ignore: cast_nullable_to_non_nullable
as double,submitFailure: freezed == submitFailure ? _self.submitFailure : submitFailure // ignore: cast_nullable_to_non_nullable
as Failure?,isEditMode: null == isEditMode ? _self.isEditMode : isEditMode // ignore: cast_nullable_to_non_nullable
as bool,createdId: freezed == createdId ? _self.createdId : createdId // ignore: cast_nullable_to_non_nullable
as String?,updatedId: freezed == updatedId ? _self.updatedId : updatedId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of ListingFormState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ListingMetaCopyWith<$Res>? get meta {
    if (_self.meta == null) {
    return null;
  }

  return $ListingMetaCopyWith<$Res>(_self.meta!, (value) {
    return _then(_self.copyWith(meta: value));
  });
}
}

// dart format on
