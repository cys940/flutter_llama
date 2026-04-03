// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChatSettings {

 double get temperature; double get topP; int get maxTokens; String get systemPrompt; bool get autoTitle;
/// Create a copy of ChatSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatSettingsCopyWith<ChatSettings> get copyWith => _$ChatSettingsCopyWithImpl<ChatSettings>(this as ChatSettings, _$identity);

  /// Serializes this ChatSettings to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatSettings&&(identical(other.temperature, temperature) || other.temperature == temperature)&&(identical(other.topP, topP) || other.topP == topP)&&(identical(other.maxTokens, maxTokens) || other.maxTokens == maxTokens)&&(identical(other.systemPrompt, systemPrompt) || other.systemPrompt == systemPrompt)&&(identical(other.autoTitle, autoTitle) || other.autoTitle == autoTitle));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,temperature,topP,maxTokens,systemPrompt,autoTitle);

@override
String toString() {
  return 'ChatSettings(temperature: $temperature, topP: $topP, maxTokens: $maxTokens, systemPrompt: $systemPrompt, autoTitle: $autoTitle)';
}


}

/// @nodoc
abstract mixin class $ChatSettingsCopyWith<$Res>  {
  factory $ChatSettingsCopyWith(ChatSettings value, $Res Function(ChatSettings) _then) = _$ChatSettingsCopyWithImpl;
@useResult
$Res call({
 double temperature, double topP, int maxTokens, String systemPrompt, bool autoTitle
});




}
/// @nodoc
class _$ChatSettingsCopyWithImpl<$Res>
    implements $ChatSettingsCopyWith<$Res> {
  _$ChatSettingsCopyWithImpl(this._self, this._then);

  final ChatSettings _self;
  final $Res Function(ChatSettings) _then;

/// Create a copy of ChatSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? temperature = null,Object? topP = null,Object? maxTokens = null,Object? systemPrompt = null,Object? autoTitle = null,}) {
  return _then(_self.copyWith(
temperature: null == temperature ? _self.temperature : temperature // ignore: cast_nullable_to_non_nullable
as double,topP: null == topP ? _self.topP : topP // ignore: cast_nullable_to_non_nullable
as double,maxTokens: null == maxTokens ? _self.maxTokens : maxTokens // ignore: cast_nullable_to_non_nullable
as int,systemPrompt: null == systemPrompt ? _self.systemPrompt : systemPrompt // ignore: cast_nullable_to_non_nullable
as String,autoTitle: null == autoTitle ? _self.autoTitle : autoTitle // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatSettings].
extension ChatSettingsPatterns on ChatSettings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatSettings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatSettings value)  $default,){
final _that = this;
switch (_that) {
case _ChatSettings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatSettings value)?  $default,){
final _that = this;
switch (_that) {
case _ChatSettings() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double temperature,  double topP,  int maxTokens,  String systemPrompt,  bool autoTitle)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatSettings() when $default != null:
return $default(_that.temperature,_that.topP,_that.maxTokens,_that.systemPrompt,_that.autoTitle);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double temperature,  double topP,  int maxTokens,  String systemPrompt,  bool autoTitle)  $default,) {final _that = this;
switch (_that) {
case _ChatSettings():
return $default(_that.temperature,_that.topP,_that.maxTokens,_that.systemPrompt,_that.autoTitle);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double temperature,  double topP,  int maxTokens,  String systemPrompt,  bool autoTitle)?  $default,) {final _that = this;
switch (_that) {
case _ChatSettings() when $default != null:
return $default(_that.temperature,_that.topP,_that.maxTokens,_that.systemPrompt,_that.autoTitle);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatSettings implements ChatSettings {
  const _ChatSettings({this.temperature = 0.7, this.topP = 0.9, this.maxTokens = 2048, this.systemPrompt = 'You are a helpful AI assistant.', this.autoTitle = true});
  factory _ChatSettings.fromJson(Map<String, dynamic> json) => _$ChatSettingsFromJson(json);

@override@JsonKey() final  double temperature;
@override@JsonKey() final  double topP;
@override@JsonKey() final  int maxTokens;
@override@JsonKey() final  String systemPrompt;
@override@JsonKey() final  bool autoTitle;

/// Create a copy of ChatSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatSettingsCopyWith<_ChatSettings> get copyWith => __$ChatSettingsCopyWithImpl<_ChatSettings>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatSettingsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatSettings&&(identical(other.temperature, temperature) || other.temperature == temperature)&&(identical(other.topP, topP) || other.topP == topP)&&(identical(other.maxTokens, maxTokens) || other.maxTokens == maxTokens)&&(identical(other.systemPrompt, systemPrompt) || other.systemPrompt == systemPrompt)&&(identical(other.autoTitle, autoTitle) || other.autoTitle == autoTitle));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,temperature,topP,maxTokens,systemPrompt,autoTitle);

@override
String toString() {
  return 'ChatSettings(temperature: $temperature, topP: $topP, maxTokens: $maxTokens, systemPrompt: $systemPrompt, autoTitle: $autoTitle)';
}


}

/// @nodoc
abstract mixin class _$ChatSettingsCopyWith<$Res> implements $ChatSettingsCopyWith<$Res> {
  factory _$ChatSettingsCopyWith(_ChatSettings value, $Res Function(_ChatSettings) _then) = __$ChatSettingsCopyWithImpl;
@override @useResult
$Res call({
 double temperature, double topP, int maxTokens, String systemPrompt, bool autoTitle
});




}
/// @nodoc
class __$ChatSettingsCopyWithImpl<$Res>
    implements _$ChatSettingsCopyWith<$Res> {
  __$ChatSettingsCopyWithImpl(this._self, this._then);

  final _ChatSettings _self;
  final $Res Function(_ChatSettings) _then;

/// Create a copy of ChatSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? temperature = null,Object? topP = null,Object? maxTokens = null,Object? systemPrompt = null,Object? autoTitle = null,}) {
  return _then(_ChatSettings(
temperature: null == temperature ? _self.temperature : temperature // ignore: cast_nullable_to_non_nullable
as double,topP: null == topP ? _self.topP : topP // ignore: cast_nullable_to_non_nullable
as double,maxTokens: null == maxTokens ? _self.maxTokens : maxTokens // ignore: cast_nullable_to_non_nullable
as int,systemPrompt: null == systemPrompt ? _self.systemPrompt : systemPrompt // ignore: cast_nullable_to_non_nullable
as String,autoTitle: null == autoTitle ? _self.autoTitle : autoTitle // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
