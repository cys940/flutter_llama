// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:local_ai_chat/core/database/database_helper.dart' as _i1071;
import 'package:local_ai_chat/core/services/meeting_summary_service.dart'
    as _i292;
import 'package:local_ai_chat/core/services/platform_service.dart' as _i115;
import 'package:local_ai_chat/core/services/stt_service.dart' as _i42;
import 'package:local_ai_chat/features/chat/data/datasources/chat_local_data_source.dart'
    as _i149;
import 'package:local_ai_chat/features/chat/data/datasources/chat_local_data_source_impl.dart'
    as _i546;
import 'package:local_ai_chat/features/chat/data/datasources/llama_data_source.dart'
    as _i154;
import 'package:local_ai_chat/features/chat/data/repositories/chat_repository_impl.dart'
    as _i880;
import 'package:local_ai_chat/features/chat/data/repositories/model_repository_impl.dart'
    as _i1010;
import 'package:local_ai_chat/features/chat/domain/repositories/chat_repository.dart'
    as _i674;
import 'package:local_ai_chat/features/chat/domain/repositories/model_repository.dart'
    as _i426;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.lazySingleton<_i1071.DatabaseHelper>(() => _i1071.DatabaseHelper());
    gh.lazySingleton<_i115.PlatformService>(() => _i115.PlatformService());
    gh.lazySingleton<_i42.SttService>(() => _i42.SttService());
    gh.lazySingleton<_i154.LlamaDataSource>(() => _i154.LlamaDataSource());
    gh.lazySingleton<_i292.MeetingSummaryService>(
      () => _i292.MeetingSummaryService(gh<_i154.LlamaDataSource>()),
    );
    gh.lazySingleton<_i426.ModelRepository>(
      () => _i1010.ModelRepositoryImpl(gh<_i115.PlatformService>()),
    );
    gh.lazySingleton<_i149.ChatLocalDataSource>(
      () => _i546.ChatLocalDataSourceImpl(gh<_i1071.DatabaseHelper>()),
    );
    gh.lazySingleton<_i674.ChatRepository>(
      () => _i880.ChatRepositoryImpl(
        localDataSource: gh<_i149.ChatLocalDataSource>(),
        llamaDataSource: gh<_i154.LlamaDataSource>(),
      ),
    );
    return this;
  }
}
