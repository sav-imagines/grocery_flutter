// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(getItemsInGroup)
const getItemsInGroupProvider = GetItemsInGroupProvider._();

final class GetItemsInGroupProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<CategoryModel>>,
          List<CategoryModel>,
          FutureOr<List<CategoryModel>>
        >
    with
        $FutureModifier<List<CategoryModel>>,
        $FutureProvider<List<CategoryModel>> {
  const GetItemsInGroupProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getItemsInGroupProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getItemsInGroupHash();

  @$internal
  @override
  $FutureProviderElement<List<CategoryModel>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<CategoryModel>> create(Ref ref) {
    return getItemsInGroup(ref);
  }
}

String _$getItemsInGroupHash() => r'4e7ca576492e2696e23d6f0fd8c62ec815e8b599';

@ProviderFor(searchItems)
const searchItemsProvider = SearchItemsFamily._();

final class SearchItemsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<GroceryListItemDisplay>>,
          List<GroceryListItemDisplay>,
          FutureOr<List<GroceryListItemDisplay>>
        >
    with
        $FutureModifier<List<GroceryListItemDisplay>>,
        $FutureProvider<List<GroceryListItemDisplay>> {
  const SearchItemsProvider._({
    required SearchItemsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'searchItemsProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$searchItemsHash();

  @override
  String toString() {
    return r'searchItemsProvider'
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
    return searchItems(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SearchItemsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$searchItemsHash() => r'f2d34237bdb1a66d1368cb65d9dd93eb16e52920';

final class SearchItemsFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<GroceryListItemDisplay>>,
          String
        > {
  const SearchItemsFamily._()
    : super(
        retry: null,
        name: r'searchItemsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  SearchItemsProvider call(String query) =>
      SearchItemsProvider._(argument: query, from: this);

  @override
  String toString() => r'searchItemsProvider';
}
