import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:llamadart/llamadart.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';
import '../services/platform_service.dart';
import 'injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit()
void configureDependencies() {
  getIt.registerLazySingleton<Talker>(() => TalkerFlutter.init());
  getIt.init();
}

@module
abstract class LlamaModule {
  @lazySingleton
  LlamaEngine llamaEngine(PlatformService platform) {
    if (kIsWeb) {
      // llamadart WebGPU 백엔드 사용 시도시 
      // 실제 패키지 구조에 따라 다를 수 있으나, 기본적으로 LlamaBackend()가 
      // 웹 환경에서 WebGPU를 자동으로 선택하도록 설계되어 있다고 가정
      return LlamaEngine(LlamaBackend());
    }
    return LlamaEngine(LlamaBackend());
  }
}
