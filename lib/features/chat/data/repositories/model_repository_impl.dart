import 'dart:io' if (dart.library.html) 'dart:html';
import 'package:injectable/injectable.dart';
import 'package:flutter/services.dart';
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

    // 앱 에셋에서 기본 모델 추출 시도
    try {
      final success = await _extractModelFromAssets(modelFile.path);
      if (success) {
        return modelFile.path;
      }
    } catch (_) {
      // 에셋이 없을 경우 무시
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
  Future<dynamic> getModelsDirectory() async {
    if (_platform.isWeb) return 'indexed_db_storage';
    
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
    if (_platform.isWeb) return true; // 웹은 항상 리모트/프리셋 보장한다고 가정
    final path = await getModelPath();
    return path != null;
  }

  @override
  Future<List<ModelFileEntity>> getAvailableModels() async {
    if (_platform.isWeb) {
      // 웹 전용 권장 모델 리스트
      return [
        const ModelFileEntity(
          name: 'Llama 3.1 8B (Recommended)',
          path: 'https://huggingface.co/lmstudio-community/Llama-3.1-8B-Lexi-Llama-GGUF/resolve/main/Llama-3.1-8B-Lexi-Llama-Q4_K_M.gguf',
          size: 4920000000,
        ),
        const ModelFileEntity(
          name: 'Phi-3 Mini (Fast)',
          path: 'https://huggingface.co/microsoft/Phi-3-mini-4k-instruct-gguf/resolve/main/Phi-3-mini-4k-instruct-q4.gguf',
          size: 2390000000,
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
    
    // 최신 파일이 위로 오도록 정렬
    models.sort((a, b) => (b.lastModified ?? DateTime(0))
        .compareTo(a.lastModified ?? DateTime(0)));
    return models;
  }

  @override
  Stream<double> copyModelWithProgress(String sourcePath) async* {
    if (_platform.isWeb) {
      // 웹에서는 복사 대신 다운로드 진행률 반환 가능
      yield 1.0;
      return;
    }

    final modelsDir = await getModelsDirectory() as Directory;
    final fileName = p.basename(sourcePath);
    final targetPath = p.join(modelsDir.path, fileName);
    
    final sourceFile = File(sourcePath);
    final totalBytes = await sourceFile.length();
    var copiedBytes = 0;

    final inputStream = sourceFile.openRead();
    final outputSink = File(targetPath).openWrite();

    try {
      await for (final chunk in inputStream) {
        outputSink.add(chunk);
        copiedBytes += chunk.length;
        yield (copiedBytes / totalBytes).clamp(0.0, 1.0);
      }
      await outputSink.flush();
      await outputSink.close();
    } catch (e) {
      await outputSink.close();
      rethrow;
    }
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

  Future<bool> _extractModelFromAssets(String targetPath) async {
    try {
      final assetPath = 'assets/models/$_defaultModelName';
      final data = await rootBundle.load(assetPath);
      final bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(targetPath).writeAsBytes(bytes);
      return true;
    } catch (e) {
      return await _mergePartsFromAssets(targetPath);
    }
  }

  Future<bool> _mergePartsFromAssets(String targetPath) async {
    if (_platform.isWeb) return false;
    
    IOSink? sink;
    bool foundAny = false;
    final alphabet = 'abcdefghijklmnopqrstuvwxyz';
    final List<String> suffixes = [];
    for (var i = 0; i < alphabet.length; i++) {
      suffixes.add('a${alphabet[i]}');
    }

    try {
      for (final suffix in suffixes) {
        final assetPath = 'assets/models/$_defaultModelName.part$suffix';
        try {
          final data = await rootBundle.load(assetPath);
          if (sink == null) {
            final file = File(targetPath);
            if (await file.exists()) await file.delete();
            sink = file.openWrite();
          }
          sink.add(data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
          foundAny = true;
        } catch (e) {
          break;
        }
      }
      await sink?.flush();
      await sink?.close();
      return foundAny;
    } catch (e) {
      await sink?.close();
      return false;
    }
  }
}
