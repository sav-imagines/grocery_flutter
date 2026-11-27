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
        isAutoDispose: true,
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

String _$getItemsInGroupHash() => r'ed5d9bb0241df12d6ba2aad0a3bac5da17e27ed9';

@ProviderFor(createItem)
const createItemProvider = CreateItemFamily._();

final class CreateItemProvider
    extends $FunctionalProvider<AsyncValue<String>, String, FutureOr<String>>
    with $FutureModifier<String>, $FutureProvider<String> {
  const CreateItemProvider._({
    required CreateItemFamily super.from,
    required CreateItemModel super.argument,
  }) : super(
         retry: null,
         name: r'createItemProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$createItemHash();

  @override
  String toString() {
    return r'createItemProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<String> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<String> create(Ref ref) {
    final argument = this.argument as CreateItemModel;
    return createItem(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is CreateItemProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$createItemHash() => r'87fe7dd2d2d9ead04dc2fb71e57d6c381b367369';

final class CreateItemFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<String>, CreateItemModel> {
  const CreateItemFamily._()
    : super(
        retry: null,
        name: r'createItemProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  CreateItemProvider call(CreateItemModel newItem) =>
      CreateItemProvider._(argument: newItem, from: this);

  @override
  String toString() => r'createItemProvider';
}

@ProviderFor(searchItems)
const searchItemsProvider = SearchItemsFamily._();

final class SearchItemsProvider
    extends
        $FunctionalProvider<
          AsyncValue<RequestResult<List<GroceryListItemDisplay>>>,
          RequestResult<List<GroceryListItemDisplay>>,
          FutureOr<RequestResult<List<GroceryListItemDisplay>>>
        >
    with
        $FutureModifier<RequestResult<List<GroceryListItemDisplay>>>,
        $FutureProvider<RequestResult<List<GroceryListItemDisplay>>> {
  const SearchItemsProvider._({
    required SearchItemsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'searchItemsProvider',
         isAutoDispose: true,
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
  $FutureProviderElement<RequestResult<List<GroceryListItemDisplay>>>
  $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<RequestResult<List<GroceryListItemDisplay>>> create(Ref ref) {
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

String _$searchItemsHash() => r'dd03a46e96a237a0bc444422f21f09158f552a9e';

final class SearchItemsFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<RequestResult<List<GroceryListItemDisplay>>>,
          String
        > {
  const SearchItemsFamily._()
    : super(
        retry: null,
        name: r'searchItemsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SearchItemsProvider call(String query) =>
      SearchItemsProvider._(argument: query, from: this);

  @override
  String toString() => r'searchItemsProvider';
}
