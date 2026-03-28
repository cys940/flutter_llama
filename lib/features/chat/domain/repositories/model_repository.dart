import 'dart:io';

abstract class ModelRepository {
  /// 로컬 저장소의 모델 파일 경로를 반환합니다.
  /// 파일이 없거나 유효하지 않으면 null을 반환합니다.
  Future<String?> getModelPath();

  /// 모델 저장용 표준 디렉토리가 존재하는지 확인하고 없으면 생성합니다.
  Future<Directory> getModelsDirectory();

  /// 지정된 경로에 모델 파일이 실제로 존재하는지 확인합니다.
  Future<bool> isModelAvailable();
}
