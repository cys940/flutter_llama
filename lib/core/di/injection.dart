import 'package:injectable/injectable.dart';
import 'package:llamadart/llamadart.dart';
import 'package:get_it/get_it.dart';
import 'injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async {
  await getIt.init();
}

@module
abstract class LlamaModule {
  @lazySingleton
  LlamaEngine get llamaEngine => LlamaEngine(LlamaBackend());
}
