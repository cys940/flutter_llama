import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../features/chat/presentation/screens/chat_screen.dart';
import 'route_names.dart';

import '../../features/chat/presentation/screens/settings_screen.dart';
import '../../features/chat/presentation/screens/history_screen.dart';
import '../../features/chat/presentation/screens/meeting_dashboard_screen.dart';

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
      GoRoute(
        path: RouteNames.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: RouteNames.history,
        builder: (context, state) => const HistoryScreen(),
      ),
      GoRoute(
        path: RouteNames.meetingReport,
        builder: (context, state) => const MeetingDashboardScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page not found: ${state.uri}'),
      ),
    ),
  );
}
