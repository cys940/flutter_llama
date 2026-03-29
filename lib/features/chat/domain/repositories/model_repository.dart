import '../entities/model_file_entity.dart';

abstract class ModelRepository {
  /// 로컬 저장소의 모델 파일 경로를 반환합니다.
  /// 파일이 없거나 유효하지 않으면 null을 반환합니다.
  Future<String?> getModelPath();

  /// 모델 저장용 표준 디렉토리가 존재하는지 확인하고 없으면 생성합니다.
  /// 주의: 웹 환경에서는 지원되지 않을 수 있습니다.
  Future<dynamic> getModelsDirectory();

  /// 지정된 경로에 모델 파일이 실제로 존재하는지 확인합니다.
  Future<bool> isModelAvailable();

  /// 현재 사용 가능한 모델 파일 목록을 반환합니다.
  Future<List<ModelFileEntity>> getAvailableModels();

  /// 지정된 경로의 파일을 모델 폴더로 복사하며 진행률(0.0~1.0)을 반환합니다.
  Stream<double> copyModelWithProgress(String sourcePath);

  /// 지정된 경로의 파일을 모델 폴더로 복사하고 기본 모델로 설정합니다 (Legacy).
  Future<void> setDefaultModel(String sourcePath);
}
