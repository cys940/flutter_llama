import 'dart:io';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import '../../domain/repositories/model_repository.dart';

@LazySingleton(as: ModelRepository)
class ModelRepositoryImpl implements ModelRepository {
  static const String _modelFolderName = 'models';
  static const String _defaultModelName = 'model.gguf';

  @override
  Future<String?> getModelPath() async {
    final modelsDir = await getModelsDirectory();
    final modelFile = File(p.join(modelsDir.path, _defaultModelName));

    if (await modelFile.exists()) {
      return modelFile.path;
    }

    // fallback: models 폴러 내의 첫 번째 .gguf 파일 찾기
    final entities = await modelsDir.list().toList();
    for (final entity in entities) {
      if (entity is File && entity.path.endsWith('.gguf')) {
        return entity.path;
      }
    }

    return null;
  }

  @override
  Future<Directory> getModelsDirectory() async {
    final appDocDir = await getApplicationDocumentsDirectory();
    final modelsDirPath = p.join(appDocDir.path, _modelFolderName);
    final modelsDir = Directory(modelsDirPath);

    if (!await modelsDir.exists()) {
      await modelsDir.create(recursive: true);
    }
    return modelsDir;
  }

  @override
  Future<bool> isModelAvailable() async {
    final path = await getModelPath();
    return path != null;
  }
}
