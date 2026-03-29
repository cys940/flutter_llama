// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'model_file_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ModelFileEntity {

 String get name; String get path; int get size; DateTime? get lastModified;
/// Create a copy of ModelFileEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ModelFileEntityCopyWith<ModelFileEntity> get copyWith => _$ModelFileEntityCopyWithImpl<ModelFileEntity>(this as ModelFileEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ModelFileEntity&&(identical(other.name, name) || other.name == name)&&(identical(other.path, path) || other.path == path)&&(identical(other.size, size) || other.size == size)&&(identical(other.lastModified, lastModified) || other.lastModified == lastModified));
}


@override
int get hashCode => Object.hash(runtimeType,name,path,size,lastModified);

@override
String toString() {
  return 'ModelFileEntity(name: $name, path: $path, size: $size, lastModified: $lastModified)';
}


}

/// @nodoc
abstract mixin class $ModelFileEntityCopyWith<$Res>  {
  factory $ModelFileEntityCopyWith(ModelFileEntity value, $Res Function(ModelFileEntity) _then) = _$ModelFileEntityCopyWithImpl;
@useResult
$Res call({
 String name, String path, int size, DateTime? lastModified
});




}
/// @nodoc
class _$ModelFileEntityCopyWithImpl<$Res>
    implements $ModelFileEntityCopyWith<$Res> {
  _$ModelFileEntityCopyWithImpl(this._self, this._then);

  final ModelFileEntity _self;
  final $Res Function(ModelFileEntity) _then;

/// Create a copy of ModelFileEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? path = null,Object? size = null,Object? lastModified = freezed,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int,lastModified: freezed == lastModified ? _self.lastModified : lastModified // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [ModelFileEntity].
extension ModelFileEntityPatterns on ModelFileEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ModelFileEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ModelFileEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ModelFileEntity value)  $default,){
final _that = this;
switch (_that) {
case _ModelFileEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ModelFileEntity value)?  $default,){
final _that = this;
switch (_that) {
case _ModelFileEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String path,  int size,  DateTime? lastModified)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ModelFileEntity() when $default != null:
return $default(_that.name,_that.path,_that.size,_that.lastModified);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String path,  int size,  DateTime? lastModified)  $default,) {final _that = this;
switch (_that) {
case _ModelFileEntity():
return $default(_that.name,_that.path,_that.size,_that.lastModified);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String path,  int size,  DateTime? lastModified)?  $default,) {final _that = this;
switch (_that) {
case _ModelFileEntity() when $default != null:
return $default(_that.name,_that.path,_that.size,_that.lastModified);case _:
  return null;

}
}

}

/// @nodoc


class _ModelFileEntity implements ModelFileEntity {
  const _ModelFileEntity({required this.name, required this.path, this.size = 0, this.lastModified});
  

@override final  String name;
@override final  String path;
@override@JsonKey() final  int size;
@override final  DateTime? lastModified;

/// Create a copy of ModelFileEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ModelFileEntityCopyWith<_ModelFileEntity> get copyWith => __$ModelFileEntityCopyWithImpl<_ModelFileEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ModelFileEntity&&(identical(other.name, name) || other.name == name)&&(identical(other.path, path) || other.path == path)&&(identical(other.size, size) || other.size == size)&&(identical(other.lastModified, lastModified) || other.lastModified == lastModified));
}


@override
int get hashCode => Object.hash(runtimeType,name,path,size,lastModified);

@override
String toString() {
  return 'ModelFileEntity(name: $name, path: $path, size: $size, lastModified: $lastModified)';
}


}

/// @nodoc
abstract mixin class _$ModelFileEntityCopyWith<$Res> implements $ModelFileEntityCopyWith<$Res> {
  factory _$ModelFileEntityCopyWith(_ModelFileEntity value, $Res Function(_ModelFileEntity) _then) = __$ModelFileEntityCopyWithImpl;
@override @useResult
$Res call({
 String name, String path, int size, DateTime? lastModified
});




}
/// @nodoc
class __$ModelFileEntityCopyWithImpl<$Res>
    implements _$ModelFileEntityCopyWith<$Res> {
  __$ModelFileEntityCopyWithImpl(this._self, this._then);

  final _ModelFileEntity _self;
  final $Res Function(_ModelFileEntity) _then;

/// Create a copy of ModelFileEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? path = null,Object? size = null,Object? lastModified = freezed,}) {
  return _then(_ModelFileEntity(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int,lastModified: freezed == lastModified ? _self.lastModified : lastModified // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
