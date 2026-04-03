// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meeting_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(MeetingNotifier)
final meetingProvider = MeetingNotifierProvider._();

final class MeetingNotifierProvider
    extends $NotifierProvider<MeetingNotifier, MeetingState> {
  MeetingNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'meetingProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$meetingNotifierHash();

  @$internal
  @override
  MeetingNotifier create() => MeetingNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MeetingState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MeetingState>(value),
    );
  }
}

String _$meetingNotifierHash() => r'e45d5f22df4ec17eb5e6ab7e079a8d81858733d3';

abstract class _$MeetingNotifier extends $Notifier<MeetingState> {
  MeetingState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<MeetingState, MeetingState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<MeetingState, MeetingState>,
              MeetingState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
