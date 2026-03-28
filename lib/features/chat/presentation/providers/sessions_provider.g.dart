// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sessions_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Sessions)
final sessionsProvider = SessionsProvider._();

final class SessionsProvider
    extends $AsyncNotifierProvider<Sessions, List<SessionEntity>> {
  SessionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sessionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sessionsHash();

  @$internal
  @override
  Sessions create() => Sessions();
}

String _$sessionsHash() => r'a5bc9bf95931863276b0823bc0b4d4f543d381fa';

abstract class _$Sessions extends $AsyncNotifier<List<SessionEntity>> {
  FutureOr<List<SessionEntity>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<SessionEntity>>, List<SessionEntity>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<SessionEntity>>, List<SessionEntity>>,
              AsyncValue<List<SessionEntity>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
