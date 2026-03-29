import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'core/di/injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 폰트 고유 설정 (오프라인 환경 및 로컬 번들링 지원 시 false로 변경)
  // 현재 assets/fonts/에 폰트 파일이 없으므로, 빌드 에러 방지를 위해 pubspec.yaml에서 폰트 섹션을 주석 처리했습니다.
  // 실제 서비스 시에는 폰트 파일을 추가하고 아래 설정을 false로 바꾼 뒤 pubspec 주석을 해제하세요.
  GoogleFonts.config.allowRuntimeFetching = true;

  // 의존성 주입 초기화
  await configureDependencies();

  runApp(
    const ProviderScope(
      child: LocalAiChatApp(),
    ),
  );
}

class LocalAiChatApp extends ConsumerWidget {
  const LocalAiChatApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    
    return MaterialApp.router(
      title: 'Local AI Chat',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      routerConfig: router,
    );
  }
}
