// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getChatHash() => r'78c6520b8a70033445a8f9a65620d5a026d0d007';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [getChat].
@ProviderFor(getChat)
const getChatProvider = GetChatFamily();

/// See also [getChat].
class GetChatFamily extends Family<AsyncValue<List<Mensaje>>> {
  /// See also [getChat].
  const GetChatFamily();

  /// See also [getChat].
  GetChatProvider call(String usuarioId) {
    return GetChatProvider(usuarioId);
  }

  @override
  GetChatProvider getProviderOverride(covariant GetChatProvider provider) {
    return call(provider.usuarioId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'getChatProvider';
}

/// See also [getChat].
class GetChatProvider extends FutureProvider<List<Mensaje>> {
  /// See also [getChat].
  GetChatProvider(String usuarioId)
    : this._internal(
        (ref) => getChat(ref as GetChatRef, usuarioId),
        from: getChatProvider,
        name: r'getChatProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$getChatHash,
        dependencies: GetChatFamily._dependencies,
        allTransitiveDependencies: GetChatFamily._allTransitiveDependencies,
        usuarioId: usuarioId,
      );

  GetChatProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.usuarioId,
  }) : super.internal();

  final String usuarioId;

  @override
  Override overrideWith(
    FutureOr<List<Mensaje>> Function(GetChatRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetChatProvider._internal(
        (ref) => create(ref as GetChatRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        usuarioId: usuarioId,
      ),
    );
  }

  @override
  FutureProviderElement<List<Mensaje>> createElement() {
    return _GetChatProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetChatProvider && other.usuarioId == usuarioId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, usuarioId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GetChatRef on FutureProviderRef<List<Mensaje>> {
  /// The parameter `usuarioId` of this provider.
  String get usuarioId;
}

class _GetChatProviderElement extends FutureProviderElement<List<Mensaje>>
    with GetChatRef {
  _GetChatProviderElement(super.provider);

  @override
  String get usuarioId => (origin as GetChatProvider).usuarioId;
}

String _$usuarioParaHash() => r'fb80984a3b82bcf10229757bac7027149663c17c';

/// See also [UsuarioPara].
@ProviderFor(UsuarioPara)
final usuarioParaProvider = NotifierProvider<UsuarioPara, Usuario>.internal(
  UsuarioPara.new,
  name: r'usuarioParaProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$usuarioParaHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$UsuarioPara = Notifier<Usuario>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
