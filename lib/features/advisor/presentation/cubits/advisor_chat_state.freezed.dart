// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'advisor_chat_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AdvisorChatState {

 List<AdvisorMessage> get messages; String? get sessionId; bool get isSending; String? get failedMessageId; Failure? get failure;
/// Create a copy of AdvisorChatState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdvisorChatStateCopyWith<AdvisorChatState> get copyWith => _$AdvisorChatStateCopyWithImpl<AdvisorChatState>(this as AdvisorChatState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdvisorChatState&&const DeepCollectionEquality().equals(other.messages, messages)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.isSending, isSending) || other.isSending == isSending)&&(identical(other.failedMessageId, failedMessageId) || other.failedMessageId == failedMessageId)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(messages),sessionId,isSending,failedMessageId,failure);

@override
String toString() {
  return 'AdvisorChatState(messages: $messages, sessionId: $sessionId, isSending: $isSending, failedMessageId: $failedMessageId, failure: $failure)';
}


}

/// @nodoc
abstract mixin class $AdvisorChatStateCopyWith<$Res>  {
  factory $AdvisorChatStateCopyWith(AdvisorChatState value, $Res Function(AdvisorChatState) _then) = _$AdvisorChatStateCopyWithImpl;
@useResult
$Res call({
 List<AdvisorMessage> messages, String? sessionId, bool isSending, String? failedMessageId, Failure? failure
});




}
/// @nodoc
class _$AdvisorChatStateCopyWithImpl<$Res>
    implements $AdvisorChatStateCopyWith<$Res> {
  _$AdvisorChatStateCopyWithImpl(this._self, this._then);

  final AdvisorChatState _self;
  final $Res Function(AdvisorChatState) _then;

/// Create a copy of AdvisorChatState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? messages = null,Object? sessionId = freezed,Object? isSending = null,Object? failedMessageId = freezed,Object? failure = freezed,}) {
  return _then(_self.copyWith(
messages: null == messages ? _self.messages : messages // ignore: cast_nullable_to_non_nullable
as List<AdvisorMessage>,sessionId: freezed == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String?,isSending: null == isSending ? _self.isSending : isSending // ignore: cast_nullable_to_non_nullable
as bool,failedMessageId: freezed == failedMessageId ? _self.failedMessageId : failedMessageId // ignore: cast_nullable_to_non_nullable
as String?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

}


/// Adds pattern-matching-related methods to [AdvisorChatState].
extension AdvisorChatStatePatterns on AdvisorChatState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdvisorChatState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdvisorChatState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdvisorChatState value)  $default,){
final _that = this;
switch (_that) {
case _AdvisorChatState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdvisorChatState value)?  $default,){
final _that = this;
switch (_that) {
case _AdvisorChatState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<AdvisorMessage> messages,  String? sessionId,  bool isSending,  String? failedMessageId,  Failure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdvisorChatState() when $default != null:
return $default(_that.messages,_that.sessionId,_that.isSending,_that.failedMessageId,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<AdvisorMessage> messages,  String? sessionId,  bool isSending,  String? failedMessageId,  Failure? failure)  $default,) {final _that = this;
switch (_that) {
case _AdvisorChatState():
return $default(_that.messages,_that.sessionId,_that.isSending,_that.failedMessageId,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<AdvisorMessage> messages,  String? sessionId,  bool isSending,  String? failedMessageId,  Failure? failure)?  $default,) {final _that = this;
switch (_that) {
case _AdvisorChatState() when $default != null:
return $default(_that.messages,_that.sessionId,_that.isSending,_that.failedMessageId,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _AdvisorChatState implements AdvisorChatState {
  const _AdvisorChatState({final  List<AdvisorMessage> messages = const <AdvisorMessage>[], this.sessionId, this.isSending = false, this.failedMessageId, this.failure}): _messages = messages;
  

 final  List<AdvisorMessage> _messages;
@override@JsonKey() List<AdvisorMessage> get messages {
  if (_messages is EqualUnmodifiableListView) return _messages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_messages);
}

@override final  String? sessionId;
@override@JsonKey() final  bool isSending;
@override final  String? failedMessageId;
@override final  Failure? failure;

/// Create a copy of AdvisorChatState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdvisorChatStateCopyWith<_AdvisorChatState> get copyWith => __$AdvisorChatStateCopyWithImpl<_AdvisorChatState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdvisorChatState&&const DeepCollectionEquality().equals(other._messages, _messages)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.isSending, isSending) || other.isSending == isSending)&&(identical(other.failedMessageId, failedMessageId) || other.failedMessageId == failedMessageId)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_messages),sessionId,isSending,failedMessageId,failure);

@override
String toString() {
  return 'AdvisorChatState(messages: $messages, sessionId: $sessionId, isSending: $isSending, failedMessageId: $failedMessageId, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$AdvisorChatStateCopyWith<$Res> implements $AdvisorChatStateCopyWith<$Res> {
  factory _$AdvisorChatStateCopyWith(_AdvisorChatState value, $Res Function(_AdvisorChatState) _then) = __$AdvisorChatStateCopyWithImpl;
@override @useResult
$Res call({
 List<AdvisorMessage> messages, String? sessionId, bool isSending, String? failedMessageId, Failure? failure
});




}
/// @nodoc
class __$AdvisorChatStateCopyWithImpl<$Res>
    implements _$AdvisorChatStateCopyWith<$Res> {
  __$AdvisorChatStateCopyWithImpl(this._self, this._then);

  final _AdvisorChatState _self;
  final $Res Function(_AdvisorChatState) _then;

/// Create a copy of AdvisorChatState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? messages = null,Object? sessionId = freezed,Object? isSending = null,Object? failedMessageId = freezed,Object? failure = freezed,}) {
  return _then(_AdvisorChatState(
messages: null == messages ? _self._messages : messages // ignore: cast_nullable_to_non_nullable
as List<AdvisorMessage>,sessionId: freezed == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String?,isSending: null == isSending ? _self.isSending : isSending // ignore: cast_nullable_to_non_nullable
as bool,failedMessageId: freezed == failedMessageId ? _self.failedMessageId : failedMessageId // ignore: cast_nullable_to_non_nullable
as String?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}


}

// dart format on
