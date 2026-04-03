import 'package:freezed_annotation/freezed_annotation.dart';

part 'model_file_entity.freezed.dart';

@freezed
abstract class ModelFileEntity with _$ModelFileEntity {
  const factory ModelFileEntity({
    required String name,
    required String path,
    @Default(0) int size,
    DateTime? lastModified,
  }) = _ModelFileEntity;
}
