// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'meeting_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MeetingState {

 bool get isRecording; String get transcript; DateTime? get startTime; bool get isAnalyzing; MeetingMetadata? get metadata; String? get error;
/// Create a copy of MeetingState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MeetingStateCopyWith<MeetingState> get copyWith => _$MeetingStateCopyWithImpl<MeetingState>(this as MeetingState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MeetingState&&(identical(other.isRecording, isRecording) || other.isRecording == isRecording)&&(identical(other.transcript, transcript) || other.transcript == transcript)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.isAnalyzing, isAnalyzing) || other.isAnalyzing == isAnalyzing)&&(identical(other.metadata, metadata) || other.metadata == metadata)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,isRecording,transcript,startTime,isAnalyzing,metadata,error);

@override
String toString() {
  return 'MeetingState(isRecording: $isRecording, transcript: $transcript, startTime: $startTime, isAnalyzing: $isAnalyzing, metadata: $metadata, error: $error)';
}


}

/// @nodoc
abstract mixin class $MeetingStateCopyWith<$Res>  {
  factory $MeetingStateCopyWith(MeetingState value, $Res Function(MeetingState) _then) = _$MeetingStateCopyWithImpl;
@useResult
$Res call({
 bool isRecording, String transcript, DateTime? startTime, bool isAnalyzing, MeetingMetadata? metadata, String? error
});


$MeetingMetadataCopyWith<$Res>? get metadata;

}
/// @nodoc
class _$MeetingStateCopyWithImpl<$Res>
    implements $MeetingStateCopyWith<$Res> {
  _$MeetingStateCopyWithImpl(this._self, this._then);

  final MeetingState _self;
  final $Res Function(MeetingState) _then;

/// Create a copy of MeetingState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isRecording = null,Object? transcript = null,Object? startTime = freezed,Object? isAnalyzing = null,Object? metadata = freezed,Object? error = freezed,}) {
  return _then(_self.copyWith(
isRecording: null == isRecording ? _self.isRecording : isRecording // ignore: cast_nullable_to_non_nullable
as bool,transcript: null == transcript ? _self.transcript : transcript // ignore: cast_nullable_to_non_nullable
as String,startTime: freezed == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as DateTime?,isAnalyzing: null == isAnalyzing ? _self.isAnalyzing : isAnalyzing // ignore: cast_nullable_to_non_nullable
as bool,metadata: freezed == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as MeetingMetadata?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of MeetingState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MeetingMetadataCopyWith<$Res>? get metadata {
    if (_self.metadata == null) {
    return null;
  }

  return $MeetingMetadataCopyWith<$Res>(_self.metadata!, (value) {
    return _then(_self.copyWith(metadata: value));
  });
}
}


/// Adds pattern-matching-related methods to [MeetingState].
extension MeetingStatePatterns on MeetingState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MeetingState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MeetingState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MeetingState value)  $default,){
final _that = this;
switch (_that) {
case _MeetingState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MeetingState value)?  $default,){
final _that = this;
switch (_that) {
case _MeetingState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isRecording,  String transcript,  DateTime? startTime,  bool isAnalyzing,  MeetingMetadata? metadata,  String? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MeetingState() when $default != null:
return $default(_that.isRecording,_that.transcript,_that.startTime,_that.isAnalyzing,_that.metadata,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isRecording,  String transcript,  DateTime? startTime,  bool isAnalyzing,  MeetingMetadata? metadata,  String? error)  $default,) {final _that = this;
switch (_that) {
case _MeetingState():
return $default(_that.isRecording,_that.transcript,_that.startTime,_that.isAnalyzing,_that.metadata,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isRecording,  String transcript,  DateTime? startTime,  bool isAnalyzing,  MeetingMetadata? metadata,  String? error)?  $default,) {final _that = this;
switch (_that) {
case _MeetingState() when $default != null:
return $default(_that.isRecording,_that.transcript,_that.startTime,_that.isAnalyzing,_that.metadata,_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _MeetingState implements MeetingState {
  const _MeetingState({this.isRecording = false, this.transcript = '', this.startTime, this.isAnalyzing = false, this.metadata, this.error});
  

@override@JsonKey() final  bool isRecording;
@override@JsonKey() final  String transcript;
@override final  DateTime? startTime;
@override@JsonKey() final  bool isAnalyzing;
@override final  MeetingMetadata? metadata;
@override final  String? error;

/// Create a copy of MeetingState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MeetingStateCopyWith<_MeetingState> get copyWith => __$MeetingStateCopyWithImpl<_MeetingState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MeetingState&&(identical(other.isRecording, isRecording) || other.isRecording == isRecording)&&(identical(other.transcript, transcript) || other.transcript == transcript)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.isAnalyzing, isAnalyzing) || other.isAnalyzing == isAnalyzing)&&(identical(other.metadata, metadata) || other.metadata == metadata)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,isRecording,transcript,startTime,isAnalyzing,metadata,error);

@override
String toString() {
  return 'MeetingState(isRecording: $isRecording, transcript: $transcript, startTime: $startTime, isAnalyzing: $isAnalyzing, metadata: $metadata, error: $error)';
}


}

/// @nodoc
abstract mixin class _$MeetingStateCopyWith<$Res> implements $MeetingStateCopyWith<$Res> {
  factory _$MeetingStateCopyWith(_MeetingState value, $Res Function(_MeetingState) _then) = __$MeetingStateCopyWithImpl;
@override @useResult
$Res call({
 bool isRecording, String transcript, DateTime? startTime, bool isAnalyzing, MeetingMetadata? metadata, String? error
});


@override $MeetingMetadataCopyWith<$Res>? get metadata;

}
/// @nodoc
class __$MeetingStateCopyWithImpl<$Res>
    implements _$MeetingStateCopyWith<$Res> {
  __$MeetingStateCopyWithImpl(this._self, this._then);

  final _MeetingState _self;
  final $Res Function(_MeetingState) _then;

/// Create a copy of MeetingState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isRecording = null,Object? transcript = null,Object? startTime = freezed,Object? isAnalyzing = null,Object? metadata = freezed,Object? error = freezed,}) {
  return _then(_MeetingState(
isRecording: null == isRecording ? _self.isRecording : isRecording // ignore: cast_nullable_to_non_nullable
as bool,transcript: null == transcript ? _self.transcript : transcript // ignore: cast_nullable_to_non_nullable
as String,startTime: freezed == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as DateTime?,isAnalyzing: null == isAnalyzing ? _self.isAnalyzing : isAnalyzing // ignore: cast_nullable_to_non_nullable
as bool,metadata: freezed == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as MeetingMetadata?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of MeetingState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MeetingMetadataCopyWith<$Res>? get metadata {
    if (_self.metadata == null) {
    return null;
  }

  return $MeetingMetadataCopyWith<$Res>(_self.metadata!, (value) {
    return _then(_self.copyWith(metadata: value));
  });
}
}

// dart format on
