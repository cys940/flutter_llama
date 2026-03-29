import 'dart:io' if (dart.library.html) 'dart:html';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import '../../domain/repositories/model_repository.dart';
import '../../domain/entities/model_file_entity.dart';
import '../../../../core/services/platform_service.dart';

@LazySingleton(as: ModelRepository)
class ModelRepositoryImpl implements ModelRepository {
  final PlatformService _platform;
  
  static const String _modelFolderName = 'models';
  static const String _defaultModelName = 'model.gguf';

  ModelRepositoryImpl(this._platform);

  @override
  Future<String?> getModelPath() async {
    if (_platform.isWeb) {
      // 웹에서는 프리셋 모델 URL 또는 IndexedDB 패스 반환
      return 'https://huggingface.co/lmstudio-community/Llama-3.1-8B-Lexi-Llama-GGUF/resolve/main/Llama-3.1-8B-Lexi-Llama-Q4_K_M.gguf';
    }

    final modelsDir = await getModelsDirectory() as Directory;
    final modelFile = File(p.join(modelsDir.path, _defaultModelName));

    if (await modelFile.exists()) {
      return modelFile.path;
    }

    // fallback: models 폴더 내의 첫 번째 .gguf 파일 찾기
    final entities = await modelsDir.list().toList();
    for (final entity in entities) {
      if (entity is File && entity.path.endsWith('.gguf')) {
        return entity.path;
      }
    }

    return null;
  }

  @override
  Future<dynamic> getModelsDirectory() async {
    if (_platform.isWeb) return 'indexed_db_storage';
    
    Directory? baseDir;
    if (_platform.isAndroid) {
      baseDir = await getExternalStorageDirectory();
    }
    baseDir ??= await getApplicationDocumentsDirectory();

    final modelsDirPath = p.join(baseDir.path, _modelFolderName);
    final modelsDir = Directory(modelsDirPath);

    if (!await modelsDir.exists()) {
      await modelsDir.create(recursive: true);
    }
    return modelsDir;
  }

  @override
  Future<bool> isModelAvailable() async {
    if (_platform.isWeb) return true;
    final path = await getModelPath();
    return path != null;
  }

  @override
  Future<List<ModelFileEntity>> getAvailableModels() async {
    if (_platform.isWeb) {
      return [
        const ModelFileEntity(
          name: 'Llama 3.1 8B (Recommended)',
          path: 'https://huggingface.co/lmstudio-community/Llama-3.1-8B-Lexi-Llama-GGUF/resolve/main/Llama-3.1-8B-Lexi-Llama-Q4_K_M.gguf',
          size: 4920000000,
        ),
      ];
    }

    final modelsDir = await getModelsDirectory() as Directory;
    final entities = await modelsDir.list().toList();
    final List<ModelFileEntity> models = [];
    
    for (final entity in entities) {
      if (entity is File && entity.path.endsWith('.gguf')) {
        final stat = await entity.stat();
        models.add(ModelFileEntity(
          name: p.basename(entity.path),
          path: entity.path,
          size: stat.size,
          lastModified: stat.modified,
        ));
      }
    }
    
    models.sort((a, b) => (b.lastModified ?? DateTime(0))
        .compareTo(a.lastModified ?? DateTime(0)));
    return models;
  }

  @override
  Stream<double> copyModelWithProgress(String sourcePath) async* {
    // 사용자가 직접 파일을 넣는 방식이므로 복사 로직은 빈 스트림 반환하거나 에러 처리
    yield 1.0;
  }

  @override
  Future<void> setDefaultModel(String sourcePath) async {
    if (_platform.isWeb) return;

    final modelsDir = await getModelsDirectory() as Directory;
    final targetPath = p.join(modelsDir.path, _defaultModelName);
    
    final sourceFile = File(sourcePath);
    if (await sourceFile.exists()) {
      await sourceFile.copy(targetPath);
    }
  }
}
