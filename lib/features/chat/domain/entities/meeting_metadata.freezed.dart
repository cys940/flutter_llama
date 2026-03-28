// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'meeting_metadata.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MeetingMetadata {

 String get summary; List<ActionItem> get actionItems; String get fullTranscript; Duration get duration; DateTime? get startTime; DateTime? get endTime;
/// Create a copy of MeetingMetadata
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MeetingMetadataCopyWith<MeetingMetadata> get copyWith => _$MeetingMetadataCopyWithImpl<MeetingMetadata>(this as MeetingMetadata, _$identity);

  /// Serializes this MeetingMetadata to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MeetingMetadata&&(identical(other.summary, summary) || other.summary == summary)&&const DeepCollectionEquality().equals(other.actionItems, actionItems)&&(identical(other.fullTranscript, fullTranscript) || other.fullTranscript == fullTranscript)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,summary,const DeepCollectionEquality().hash(actionItems),fullTranscript,duration,startTime,endTime);

@override
String toString() {
  return 'MeetingMetadata(summary: $summary, actionItems: $actionItems, fullTranscript: $fullTranscript, duration: $duration, startTime: $startTime, endTime: $endTime)';
}


}

/// @nodoc
abstract mixin class $MeetingMetadataCopyWith<$Res>  {
  factory $MeetingMetadataCopyWith(MeetingMetadata value, $Res Function(MeetingMetadata) _then) = _$MeetingMetadataCopyWithImpl;
@useResult
$Res call({
 String summary, List<ActionItem> actionItems, String fullTranscript, Duration duration, DateTime? startTime, DateTime? endTime
});




}
/// @nodoc
class _$MeetingMetadataCopyWithImpl<$Res>
    implements $MeetingMetadataCopyWith<$Res> {
  _$MeetingMetadataCopyWithImpl(this._self, this._then);

  final MeetingMetadata _self;
  final $Res Function(MeetingMetadata) _then;

/// Create a copy of MeetingMetadata
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? summary = null,Object? actionItems = null,Object? fullTranscript = null,Object? duration = null,Object? startTime = freezed,Object? endTime = freezed,}) {
  return _then(_self.copyWith(
summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String,actionItems: null == actionItems ? _self.actionItems : actionItems // ignore: cast_nullable_to_non_nullable
as List<ActionItem>,fullTranscript: null == fullTranscript ? _self.fullTranscript : fullTranscript // ignore: cast_nullable_to_non_nullable
as String,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as Duration,startTime: freezed == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as DateTime?,endTime: freezed == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [MeetingMetadata].
extension MeetingMetadataPatterns on MeetingMetadata {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MeetingMetadata value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MeetingMetadata() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MeetingMetadata value)  $default,){
final _that = this;
switch (_that) {
case _MeetingMetadata():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MeetingMetadata value)?  $default,){
final _that = this;
switch (_that) {
case _MeetingMetadata() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String summary,  List<ActionItem> actionItems,  String fullTranscript,  Duration duration,  DateTime? startTime,  DateTime? endTime)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MeetingMetadata() when $default != null:
return $default(_that.summary,_that.actionItems,_that.fullTranscript,_that.duration,_that.startTime,_that.endTime);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String summary,  List<ActionItem> actionItems,  String fullTranscript,  Duration duration,  DateTime? startTime,  DateTime? endTime)  $default,) {final _that = this;
switch (_that) {
case _MeetingMetadata():
return $default(_that.summary,_that.actionItems,_that.fullTranscript,_that.duration,_that.startTime,_that.endTime);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String summary,  List<ActionItem> actionItems,  String fullTranscript,  Duration duration,  DateTime? startTime,  DateTime? endTime)?  $default,) {final _that = this;
switch (_that) {
case _MeetingMetadata() when $default != null:
return $default(_that.summary,_that.actionItems,_that.fullTranscript,_that.duration,_that.startTime,_that.endTime);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MeetingMetadata implements MeetingMetadata {
  const _MeetingMetadata({required this.summary, required final  List<ActionItem> actionItems, required this.fullTranscript, required this.duration, required this.startTime, required this.endTime}): _actionItems = actionItems;
  factory _MeetingMetadata.fromJson(Map<String, dynamic> json) => _$MeetingMetadataFromJson(json);

@override final  String summary;
 final  List<ActionItem> _actionItems;
@override List<ActionItem> get actionItems {
  if (_actionItems is EqualUnmodifiableListView) return _actionItems;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_actionItems);
}

@override final  String fullTranscript;
@override final  Duration duration;
@override final  DateTime? startTime;
@override final  DateTime? endTime;

/// Create a copy of MeetingMetadata
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MeetingMetadataCopyWith<_MeetingMetadata> get copyWith => __$MeetingMetadataCopyWithImpl<_MeetingMetadata>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MeetingMetadataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MeetingMetadata&&(identical(other.summary, summary) || other.summary == summary)&&const DeepCollectionEquality().equals(other._actionItems, _actionItems)&&(identical(other.fullTranscript, fullTranscript) || other.fullTranscript == fullTranscript)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,summary,const DeepCollectionEquality().hash(_actionItems),fullTranscript,duration,startTime,endTime);

@override
String toString() {
  return 'MeetingMetadata(summary: $summary, actionItems: $actionItems, fullTranscript: $fullTranscript, duration: $duration, startTime: $startTime, endTime: $endTime)';
}


}

/// @nodoc
abstract mixin class _$MeetingMetadataCopyWith<$Res> implements $MeetingMetadataCopyWith<$Res> {
  factory _$MeetingMetadataCopyWith(_MeetingMetadata value, $Res Function(_MeetingMetadata) _then) = __$MeetingMetadataCopyWithImpl;
@override @useResult
$Res call({
 String summary, List<ActionItem> actionItems, String fullTranscript, Duration duration, DateTime? startTime, DateTime? endTime
});




}
/// @nodoc
class __$MeetingMetadataCopyWithImpl<$Res>
    implements _$MeetingMetadataCopyWith<$Res> {
  __$MeetingMetadataCopyWithImpl(this._self, this._then);

  final _MeetingMetadata _self;
  final $Res Function(_MeetingMetadata) _then;

/// Create a copy of MeetingMetadata
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? summary = null,Object? actionItems = null,Object? fullTranscript = null,Object? duration = null,Object? startTime = freezed,Object? endTime = freezed,}) {
  return _then(_MeetingMetadata(
summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String,actionItems: null == actionItems ? _self._actionItems : actionItems // ignore: cast_nullable_to_non_nullable
as List<ActionItem>,fullTranscript: null == fullTranscript ? _self.fullTranscript : fullTranscript // ignore: cast_nullable_to_non_nullable
as String,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as Duration,startTime: freezed == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as DateTime?,endTime: freezed == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
