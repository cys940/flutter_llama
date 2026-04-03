import 'package:injectable/injectable.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit()
void configureDependencies() {
  getIt.registerLazySingleton<Talker>(() => TalkerFlutter.init());
  getIt.init();
}
