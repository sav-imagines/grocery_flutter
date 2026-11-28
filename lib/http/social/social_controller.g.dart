// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'social_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(getOwnGroup)
const getOwnGroupProvider = GetOwnGroupProvider._();

final class GetOwnGroupProvider
    extends
        $FunctionalProvider<
          AsyncValue<GroupInfo>,
          GroupInfo,
          FutureOr<GroupInfo>
        >
    with $FutureModifier<GroupInfo>, $FutureProvider<GroupInfo> {
  const GetOwnGroupProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getOwnGroupProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getOwnGroupHash();

  @$internal
  @override
  $FutureProviderElement<GroupInfo> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<GroupInfo> create(Ref ref) {
    return getOwnGroup(ref);
  }
}

String _$getOwnGroupHash() => r'b95ffc8441fcb2e25cc6655af8f34379fab587fa';

@ProviderFor(getMyInfo)
const getMyInfoProvider = GetMyInfoProvider._();

final class GetMyInfoProvider
    extends
        $FunctionalProvider<AsyncValue<UserInfo>, UserInfo, FutureOr<UserInfo>>
    with $FutureModifier<UserInfo>, $FutureProvider<UserInfo> {
  const GetMyInfoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getMyInfoProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getMyInfoHash();

  @$internal
  @override
  $FutureProviderElement<UserInfo> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<UserInfo> create(Ref ref) {
    return getMyInfo(ref);
  }
}

String _$getMyInfoHash() => r'9ea2d7d915d8b7f27ed295a8db25aecbf684048a';

@ProviderFor(getUsersByName)
const getUsersByNameProvider = GetUsersByNameFamily._();

final class GetUsersByNameProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<UserInfo>>,
          List<UserInfo>,
          FutureOr<List<UserInfo>>
        >
    with $FutureModifier<List<UserInfo>>, $FutureProvider<List<UserInfo>> {
  const GetUsersByNameProvider._({
    required GetUsersByNameFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'getUsersByNameProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$getUsersByNameHash();

  @override
  String toString() {
    return r'getUsersByNameProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<UserInfo>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<UserInfo>> create(Ref ref) {
    final argument = this.argument as String;
    return getUsersByName(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is GetUsersByNameProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$getUsersByNameHash() => r'2f2a4289e0b8775497a630d4f462a3202777e11d';

final class GetUsersByNameFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<UserInfo>>, String> {
  const GetUsersByNameFamily._()
    : super(
        retry: null,
        name: r'getUsersByNameProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  GetUsersByNameProvider call(String name) =>
      GetUsersByNameProvider._(argument: name, from: this);

  @override
  String toString() => r'getUsersByNameProvider';
}

@ProviderFor(getMyInvites)
const getMyInvitesProvider = GetMyInvitesProvider._();

final class GetMyInvitesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Invite>>,
          List<Invite>,
          FutureOr<List<Invite>>
        >
    with $FutureModifier<List<Invite>>, $FutureProvider<List<Invite>> {
  const GetMyInvitesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getMyInvitesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getMyInvitesHash();

  @$internal
  @override
  $FutureProviderElement<List<Invite>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Invite>> create(Ref ref) {
    return getMyInvites(ref);
  }
}

String _$getMyInvitesHash() => r'26a96bff40d8345fca05e048a8f4eb70cc40fbe9';

@ProviderFor(getSentInvites)
const getSentInvitesProvider = GetSentInvitesProvider._();

final class GetSentInvitesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Invite>>,
          List<Invite>,
          FutureOr<List<Invite>>
        >
    with $FutureModifier<List<Invite>>, $FutureProvider<List<Invite>> {
  const GetSentInvitesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getSentInvitesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getSentInvitesHash();

  @$internal
  @override
  $FutureProviderElement<List<Invite>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Invite>> create(Ref ref) {
    return getSentInvites(ref);
  }
}

String _$getSentInvitesHash() => r'3c698c0309e0c4c51dfbc1ce4be045c4f4f15fab';

@ProviderFor(isInvited)
const isInvitedProvider = IsInvitedFamily._();

final class IsInvitedProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  const IsInvitedProvider._({
    required IsInvitedFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'isInvitedProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$isInvitedHash();

  @override
  String toString() {
    return r'isInvitedProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    final argument = this.argument as String;
    return isInvited(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is IsInvitedProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$isInvitedHash() => r'c4540d6042c3bece8445a5d5df4477feff294d68';

final class IsInvitedFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<bool>, String> {
  const IsInvitedFamily._()
    : super(
        retry: null,
        name: r'isInvitedProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  IsInvitedProvider call(String id) =>
      IsInvitedProvider._(argument: id, from: this);

  @override
  String toString() => r'isInvitedProvider';
}
