// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grocery_list_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(getAllLists)
const getAllListsProvider = GetAllListsProvider._();

final class GetAllListsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<GroceryListDisplay>>,
          List<GroceryListDisplay>,
          FutureOr<List<GroceryListDisplay>>
        >
    with
        $FutureModifier<List<GroceryListDisplay>>,
        $FutureProvider<List<GroceryListDisplay>> {
  const GetAllListsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getAllListsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getAllListsHash();

  @$internal
  @override
  $FutureProviderElement<List<GroceryListDisplay>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<GroceryListDisplay>> create(Ref ref) {
    return getAllLists(ref);
  }
}

String _$getAllListsHash() => r'3009c34094ab5fb15c6a503c168539e50b3752d5';

@ProviderFor(getListInfo)
const getListInfoProvider = GetListInfoFamily._();

final class GetListInfoProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<GroceryListItemDisplay>>,
          List<GroceryListItemDisplay>,
          FutureOr<List<GroceryListItemDisplay>>
        >
    with
        $FutureModifier<List<GroceryListItemDisplay>>,
        $FutureProvider<List<GroceryListItemDisplay>> {
  const GetListInfoProvider._({
    required GetListInfoFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'getListInfoProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$getListInfoHash();

  @override
  String toString() {
    return r'getListInfoProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<GroceryListItemDisplay>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<GroceryListItemDisplay>> create(Ref ref) {
    final argument = this.argument as String;
    return getListInfo(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is GetListInfoProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$getListInfoHash() => r'453484aab73c17e88b6b374162630f7db766ba06';

final class GetListInfoFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<GroceryListItemDisplay>>,
          String
        > {
  const GetListInfoFamily._()
    : super(
        retry: null,
        name: r'getListInfoProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  GetListInfoProvider call(String listId) =>
      GetListInfoProvider._(argument: listId, from: this);

  @override
  String toString() => r'getListInfoProvider';
}
