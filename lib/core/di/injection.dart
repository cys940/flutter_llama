import 'package:injectable/injectable.dart';
import 'package:llamadart/llamadart.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async {
  // Register Talker first for logging during initialization
  getIt.registerLazySingleton<Talker>(() => TalkerFlutter.init());
  
  await getIt.init();
}

@module
abstract class LlamaModule {
  @lazySingleton
  LlamaEngine get llamaEngine => LlamaEngine(LlamaBackend());
}
