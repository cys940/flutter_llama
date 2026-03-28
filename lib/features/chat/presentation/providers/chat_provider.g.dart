// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(llamaDataSource)
final llamaDataSourceProvider = LlamaDataSourceProvider._();

final class LlamaDataSourceProvider
    extends
        $FunctionalProvider<LlamaDataSource, LlamaDataSource, LlamaDataSource>
    with $Provider<LlamaDataSource> {
  LlamaDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'llamaDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$llamaDataSourceHash();

  @$internal
  @override
  $ProviderElement<LlamaDataSource> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LlamaDataSource create(Ref ref) {
    return llamaDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LlamaDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LlamaDataSource>(value),
    );
  }
}

String _$llamaDataSourceHash() => r'e0f9736226e0bb9e1dae560d33c2bb2647ad2cff';

@ProviderFor(chatRepository)
final chatRepositoryProvider = ChatRepositoryProvider._();

final class ChatRepositoryProvider
    extends $FunctionalProvider<ChatRepository, ChatRepository, ChatRepository>
    with $Provider<ChatRepository> {
  ChatRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatRepositoryHash();

  @$internal
  @override
  $ProviderElement<ChatRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ChatRepository create(Ref ref) {
    return chatRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ChatRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ChatRepository>(value),
    );
  }
}

String _$chatRepositoryHash() => r'39976163d5bbaddc90d1e590415b60dfdaa4e02a';

@ProviderFor(ChatNotifier)
final chatProvider = ChatNotifierProvider._();

final class ChatNotifierProvider
    extends $NotifierProvider<ChatNotifier, ChatState> {
  ChatNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatNotifierHash();

  @$internal
  @override
  ChatNotifier create() => ChatNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ChatState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ChatState>(value),
    );
  }
}

String _$chatNotifierHash() => r'f4d53d57626f3fcc65f961aa408bda418fdc71c2';

abstract class _$ChatNotifier extends $Notifier<ChatState> {
  ChatState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<ChatState, ChatState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ChatState, ChatState>,
              ChatState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
