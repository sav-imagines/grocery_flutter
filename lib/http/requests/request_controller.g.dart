// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(getRequestedItems)
const getRequestedItemsProvider = GetRequestedItemsProvider._();

final class GetRequestedItemsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ShortItem>>,
          List<ShortItem>,
          FutureOr<List<ShortItem>>
        >
    with $FutureModifier<List<ShortItem>>, $FutureProvider<List<ShortItem>> {
  const GetRequestedItemsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getRequestedItemsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getRequestedItemsHash();

  @$internal
  @override
  $FutureProviderElement<List<ShortItem>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ShortItem>> create(Ref ref) {
    return getRequestedItems(ref);
  }
}

String _$getRequestedItemsHash() => r'007f2a755b640c484c28f8908a40fe315313c901';

@ProviderFor(requestItem)
const requestItemProvider = RequestItemFamily._();

final class RequestItemProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  const RequestItemProvider._({
    required RequestItemFamily super.from,
    required ShortItem super.argument,
  }) : super(
         retry: null,
         name: r'requestItemProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$requestItemHash();

  @override
  String toString() {
    return r'requestItemProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    final argument = this.argument as ShortItem;
    return requestItem(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is RequestItemProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$requestItemHash() => r'45a7013819ef010494ec6a6a804e71f52715cdcb';

final class RequestItemFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<bool>, ShortItem> {
  const RequestItemFamily._()
    : super(
        retry: null,
        name: r'requestItemProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  RequestItemProvider call(ShortItem requestItem) =>
      RequestItemProvider._(argument: requestItem, from: this);

  @override
  String toString() => r'requestItemProvider';
}

@ProviderFor(updateItems)
const updateItemsProvider = UpdateItemsFamily._();

final class UpdateItemsProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  const UpdateItemsProvider._({
    required UpdateItemsFamily super.from,
    required List<ShortItem> super.argument,
  }) : super(
         retry: null,
         name: r'updateItemsProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$updateItemsHash();

  @override
  String toString() {
    return r'updateItemsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    final argument = this.argument as List<ShortItem>;
    return updateItems(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is UpdateItemsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$updateItemsHash() => r'3bbe00dae9a7feb1b11e73dce3b051c64fac2269';

final class UpdateItemsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<bool>, List<ShortItem>> {
  const UpdateItemsFamily._()
    : super(
        retry: null,
        name: r'updateItemsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  UpdateItemsProvider call(List<ShortItem> items) =>
      UpdateItemsProvider._(argument: items, from: this);

  @override
  String toString() => r'updateItemsProvider';
}

@ProviderFor(deleteAllRequests)
const deleteAllRequestsProvider = DeleteAllRequestsProvider._();

final class DeleteAllRequestsProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  const DeleteAllRequestsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deleteAllRequestsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deleteAllRequestsHash();

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    return deleteAllRequests(ref);
  }
}

String _$deleteAllRequestsHash() => r'9bb0c05e39f41f8d2220003fb376d781ebd5e148';
