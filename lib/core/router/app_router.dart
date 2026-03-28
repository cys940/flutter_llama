import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../features/chat/presentation/screens/chat_screen.dart';
import 'route_names.dart';

part 'app_router.g.dart';

@riverpod
GoRouter appRouter(Ref ref) {
  return GoRouter(
    initialLocation: RouteNames.chat,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: RouteNames.chat,
        builder: (context, state) => const ChatScreen(),
      ),
      // 추후 설정 화면 등을 이곳에 추가할 수 있습니다.
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page not found: ${state.uri}'),
      ),
    ),
  );
}
