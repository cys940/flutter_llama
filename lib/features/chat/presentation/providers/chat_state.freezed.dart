// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ChatState {

 List<MessageEntity> get messages; List<SessionEntity> get sessions; List<ModelFileEntity> get availableModels; bool get isLoading; bool get isModelLoaded; bool get isCopying; bool get isVerifying; double get copyProgress; double? get totalDiskSpace; double? get freeDiskSpace; String? get modelError; String? get error; String? get modelPath; String? get sessionId;
/// Create a copy of ChatState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatStateCopyWith<ChatState> get copyWith => _$ChatStateCopyWithImpl<ChatState>(this as ChatState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatState&&const DeepCollectionEquality().equals(other.messages, messages)&&const DeepCollectionEquality().equals(other.sessions, sessions)&&const DeepCollectionEquality().equals(other.availableModels, availableModels)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isModelLoaded, isModelLoaded) || other.isModelLoaded == isModelLoaded)&&(identical(other.isCopying, isCopying) || other.isCopying == isCopying)&&(identical(other.isVerifying, isVerifying) || other.isVerifying == isVerifying)&&(identical(other.copyProgress, copyProgress) || other.copyProgress == copyProgress)&&(identical(other.totalDiskSpace, totalDiskSpace) || other.totalDiskSpace == totalDiskSpace)&&(identical(other.freeDiskSpace, freeDiskSpace) || other.freeDiskSpace == freeDiskSpace)&&(identical(other.modelError, modelError) || other.modelError == modelError)&&(identical(other.error, error) || other.error == error)&&(identical(other.modelPath, modelPath) || other.modelPath == modelPath)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(messages),const DeepCollectionEquality().hash(sessions),const DeepCollectionEquality().hash(availableModels),isLoading,isModelLoaded,isCopying,isVerifying,copyProgress,totalDiskSpace,freeDiskSpace,modelError,error,modelPath,sessionId);

@override
String toString() {
  return 'ChatState(messages: $messages, sessions: $sessions, availableModels: $availableModels, isLoading: $isLoading, isModelLoaded: $isModelLoaded, isCopying: $isCopying, isVerifying: $isVerifying, copyProgress: $copyProgress, totalDiskSpace: $totalDiskSpace, freeDiskSpace: $freeDiskSpace, modelError: $modelError, error: $error, modelPath: $modelPath, sessionId: $sessionId)';
}


}

/// @nodoc
abstract mixin class $ChatStateCopyWith<$Res>  {
  factory $ChatStateCopyWith(ChatState value, $Res Function(ChatState) _then) = _$ChatStateCopyWithImpl;
@useResult
$Res call({
 List<MessageEntity> messages, List<SessionEntity> sessions, List<ModelFileEntity> availableModels, bool isLoading, bool isModelLoaded, bool isCopying, bool isVerifying, double copyProgress, double? totalDiskSpace, double? freeDiskSpace, String? modelError, String? error, String? modelPath, String? sessionId
});




}
/// @nodoc
class _$ChatStateCopyWithImpl<$Res>
    implements $ChatStateCopyWith<$Res> {
  _$ChatStateCopyWithImpl(this._self, this._then);

  final ChatState _self;
  final $Res Function(ChatState) _then;

/// Create a copy of ChatState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? messages = null,Object? sessions = null,Object? availableModels = null,Object? isLoading = null,Object? isModelLoaded = null,Object? isCopying = null,Object? isVerifying = null,Object? copyProgress = null,Object? totalDiskSpace = freezed,Object? freeDiskSpace = freezed,Object? modelError = freezed,Object? error = freezed,Object? modelPath = freezed,Object? sessionId = freezed,}) {
  return _then(_self.copyWith(
messages: null == messages ? _self.messages : messages // ignore: cast_nullable_to_non_nullable
as List<MessageEntity>,sessions: null == sessions ? _self.sessions : sessions // ignore: cast_nullable_to_non_nullable
as List<SessionEntity>,availableModels: null == availableModels ? _self.availableModels : availableModels // ignore: cast_nullable_to_non_nullable
as List<ModelFileEntity>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isModelLoaded: null == isModelLoaded ? _self.isModelLoaded : isModelLoaded // ignore: cast_nullable_to_non_nullable
as bool,isCopying: null == isCopying ? _self.isCopying : isCopying // ignore: cast_nullable_to_non_nullable
as bool,isVerifying: null == isVerifying ? _self.isVerifying : isVerifying // ignore: cast_nullable_to_non_nullable
as bool,copyProgress: null == copyProgress ? _self.copyProgress : copyProgress // ignore: cast_nullable_to_non_nullable
as double,totalDiskSpace: freezed == totalDiskSpace ? _self.totalDiskSpace : totalDiskSpace // ignore: cast_nullable_to_non_nullable
as double?,freeDiskSpace: freezed == freeDiskSpace ? _self.freeDiskSpace : freeDiskSpace // ignore: cast_nullable_to_non_nullable
as double?,modelError: freezed == modelError ? _self.modelError : modelError // ignore: cast_nullable_to_non_nullable
as String?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,modelPath: freezed == modelPath ? _self.modelPath : modelPath // ignore: cast_nullable_to_non_nullable
as String?,sessionId: freezed == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatState].
extension ChatStatePatterns on ChatState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatState value)  $default,){
final _that = this;
switch (_that) {
case _ChatState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatState value)?  $default,){
final _that = this;
switch (_that) {
case _ChatState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<MessageEntity> messages,  List<SessionEntity> sessions,  List<ModelFileEntity> availableModels,  bool isLoading,  bool isModelLoaded,  bool isCopying,  bool isVerifying,  double copyProgress,  double? totalDiskSpace,  double? freeDiskSpace,  String? modelError,  String? error,  String? modelPath,  String? sessionId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatState() when $default != null:
return $default(_that.messages,_that.sessions,_that.availableModels,_that.isLoading,_that.isModelLoaded,_that.isCopying,_that.isVerifying,_that.copyProgress,_that.totalDiskSpace,_that.freeDiskSpace,_that.modelError,_that.error,_that.modelPath,_that.sessionId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<MessageEntity> messages,  List<SessionEntity> sessions,  List<ModelFileEntity> availableModels,  bool isLoading,  bool isModelLoaded,  bool isCopying,  bool isVerifying,  double copyProgress,  double? totalDiskSpace,  double? freeDiskSpace,  String? modelError,  String? error,  String? modelPath,  String? sessionId)  $default,) {final _that = this;
switch (_that) {
case _ChatState():
return $default(_that.messages,_that.sessions,_that.availableModels,_that.isLoading,_that.isModelLoaded,_that.isCopying,_that.isVerifying,_that.copyProgress,_that.totalDiskSpace,_that.freeDiskSpace,_that.modelError,_that.error,_that.modelPath,_that.sessionId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<MessageEntity> messages,  List<SessionEntity> sessions,  List<ModelFileEntity> availableModels,  bool isLoading,  bool isModelLoaded,  bool isCopying,  bool isVerifying,  double copyProgress,  double? totalDiskSpace,  double? freeDiskSpace,  String? modelError,  String? error,  String? modelPath,  String? sessionId)?  $default,) {final _that = this;
switch (_that) {
case _ChatState() when $default != null:
return $default(_that.messages,_that.sessions,_that.availableModels,_that.isLoading,_that.isModelLoaded,_that.isCopying,_that.isVerifying,_that.copyProgress,_that.totalDiskSpace,_that.freeDiskSpace,_that.modelError,_that.error,_that.modelPath,_that.sessionId);case _:
  return null;

}
}

}

/// @nodoc


class _ChatState implements ChatState {
  const _ChatState({final  List<MessageEntity> messages = const [], final  List<SessionEntity> sessions = const [], final  List<ModelFileEntity> availableModels = const [], this.isLoading = false, this.isModelLoaded = false, this.isCopying = false, this.isVerifying = false, this.copyProgress = 0.0, this.totalDiskSpace, this.freeDiskSpace, this.modelError, this.error, this.modelPath, this.sessionId}): _messages = messages,_sessions = sessions,_availableModels = availableModels;
  

 final  List<MessageEntity> _messages;
@override@JsonKey() List<MessageEntity> get messages {
  if (_messages is EqualUnmodifiableListView) return _messages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_messages);
}

 final  List<SessionEntity> _sessions;
@override@JsonKey() List<SessionEntity> get sessions {
  if (_sessions is EqualUnmodifiableListView) return _sessions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sessions);
}

 final  List<ModelFileEntity> _availableModels;
@override@JsonKey() List<ModelFileEntity> get availableModels {
  if (_availableModels is EqualUnmodifiableListView) return _availableModels;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_availableModels);
}

@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  bool isModelLoaded;
@override@JsonKey() final  bool isCopying;
@override@JsonKey() final  bool isVerifying;
@override@JsonKey() final  double copyProgress;
@override final  double? totalDiskSpace;
@override final  double? freeDiskSpace;
@override final  String? modelError;
@override final  String? error;
@override final  String? modelPath;
@override final  String? sessionId;

/// Create a copy of ChatState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatStateCopyWith<_ChatState> get copyWith => __$ChatStateCopyWithImpl<_ChatState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatState&&const DeepCollectionEquality().equals(other._messages, _messages)&&const DeepCollectionEquality().equals(other._sessions, _sessions)&&const DeepCollectionEquality().equals(other._availableModels, _availableModels)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isModelLoaded, isModelLoaded) || other.isModelLoaded == isModelLoaded)&&(identical(other.isCopying, isCopying) || other.isCopying == isCopying)&&(identical(other.isVerifying, isVerifying) || other.isVerifying == isVerifying)&&(identical(other.copyProgress, copyProgress) || other.copyProgress == copyProgress)&&(identical(other.totalDiskSpace, totalDiskSpace) || other.totalDiskSpace == totalDiskSpace)&&(identical(other.freeDiskSpace, freeDiskSpace) || other.freeDiskSpace == freeDiskSpace)&&(identical(other.modelError, modelError) || other.modelError == modelError)&&(identical(other.error, error) || other.error == error)&&(identical(other.modelPath, modelPath) || other.modelPath == modelPath)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_messages),const DeepCollectionEquality().hash(_sessions),const DeepCollectionEquality().hash(_availableModels),isLoading,isModelLoaded,isCopying,isVerifying,copyProgress,totalDiskSpace,freeDiskSpace,modelError,error,modelPath,sessionId);

@override
String toString() {
  return 'ChatState(messages: $messages, sessions: $sessions, availableModels: $availableModels, isLoading: $isLoading, isModelLoaded: $isModelLoaded, isCopying: $isCopying, isVerifying: $isVerifying, copyProgress: $copyProgress, totalDiskSpace: $totalDiskSpace, freeDiskSpace: $freeDiskSpace, modelError: $modelError, error: $error, modelPath: $modelPath, sessionId: $sessionId)';
}


}

/// @nodoc
abstract mixin class _$ChatStateCopyWith<$Res> implements $ChatStateCopyWith<$Res> {
  factory _$ChatStateCopyWith(_ChatState value, $Res Function(_ChatState) _then) = __$ChatStateCopyWithImpl;
@override @useResult
$Res call({
 List<MessageEntity> messages, List<SessionEntity> sessions, List<ModelFileEntity> availableModels, bool isLoading, bool isModelLoaded, bool isCopying, bool isVerifying, double copyProgress, double? totalDiskSpace, double? freeDiskSpace, String? modelError, String? error, String? modelPath, String? sessionId
});




}
/// @nodoc
class __$ChatStateCopyWithImpl<$Res>
    implements _$ChatStateCopyWith<$Res> {
  __$ChatStateCopyWithImpl(this._self, this._then);

  final _ChatState _self;
  final $Res Function(_ChatState) _then;

/// Create a copy of ChatState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? messages = null,Object? sessions = null,Object? availableModels = null,Object? isLoading = null,Object? isModelLoaded = null,Object? isCopying = null,Object? isVerifying = null,Object? copyProgress = null,Object? totalDiskSpace = freezed,Object? freeDiskSpace = freezed,Object? modelError = freezed,Object? error = freezed,Object? modelPath = freezed,Object? sessionId = freezed,}) {
  return _then(_ChatState(
messages: null == messages ? _self._messages : messages // ignore: cast_nullable_to_non_nullable
as List<MessageEntity>,sessions: null == sessions ? _self._sessions : sessions // ignore: cast_nullable_to_non_nullable
as List<SessionEntity>,availableModels: null == availableModels ? _self._availableModels : availableModels // ignore: cast_nullable_to_non_nullable
as List<ModelFileEntity>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isModelLoaded: null == isModelLoaded ? _self.isModelLoaded : isModelLoaded // ignore: cast_nullable_to_non_nullable
as bool,isCopying: null == isCopying ? _self.isCopying : isCopying // ignore: cast_nullable_to_non_nullable
as bool,isVerifying: null == isVerifying ? _self.isVerifying : isVerifying // ignore: cast_nullable_to_non_nullable
as bool,copyProgress: null == copyProgress ? _self.copyProgress : copyProgress // ignore: cast_nullable_to_non_nullable
as double,totalDiskSpace: freezed == totalDiskSpace ? _self.totalDiskSpace : totalDiskSpace // ignore: cast_nullable_to_non_nullable
as double?,freeDiskSpace: freezed == freeDiskSpace ? _self.freeDiskSpace : freeDiskSpace // ignore: cast_nullable_to_non_nullable
as double?,modelError: freezed == modelError ? _self.modelError : modelError // ignore: cast_nullable_to_non_nullable
as String?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,modelPath: freezed == modelPath ? _self.modelPath : modelPath // ignore: cast_nullable_to_non_nullable
as String?,sessionId: freezed == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
