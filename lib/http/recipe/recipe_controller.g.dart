// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(getAllRecipes)
const getAllRecipesProvider = GetAllRecipesProvider._();

final class GetAllRecipesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<RecipeInfo>>,
          List<RecipeInfo>,
          FutureOr<List<RecipeInfo>>
        >
    with $FutureModifier<List<RecipeInfo>>, $FutureProvider<List<RecipeInfo>> {
  const GetAllRecipesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getAllRecipesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getAllRecipesHash();

  @$internal
  @override
  $FutureProviderElement<List<RecipeInfo>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<RecipeInfo>> create(Ref ref) {
    return getAllRecipes(ref);
  }
}

String _$getAllRecipesHash() => r'f85039ba25101abcad20c7bf6e3c5defe96a27dd';

@ProviderFor(getPicture)
const getPictureProvider = GetPictureFamily._();

final class GetPictureProvider
    extends
        $FunctionalProvider<
          AsyncValue<Uint8List>,
          Uint8List,
          FutureOr<Uint8List>
        >
    with $FutureModifier<Uint8List>, $FutureProvider<Uint8List> {
  const GetPictureProvider._({
    required GetPictureFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'getPictureProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$getPictureHash();

  @override
  String toString() {
    return r'getPictureProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Uint8List> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Uint8List> create(Ref ref) {
    final argument = this.argument as String;
    return getPicture(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is GetPictureProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$getPictureHash() => r'f8cf945985f31f6db31cac691eea821a0288606f';

final class GetPictureFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Uint8List>, String> {
  const GetPictureFamily._()
    : super(
        retry: null,
        name: r'getPictureProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  GetPictureProvider call(String fileName) =>
      GetPictureProvider._(argument: fileName, from: this);

  @override
  String toString() => r'getPictureProvider';
}

@ProviderFor(createRecipe)
const createRecipeProvider = CreateRecipeFamily._();

final class CreateRecipeProvider
    extends
        $FunctionalProvider<
          AsyncValue<RequestResult<void>>,
          RequestResult<void>,
          FutureOr<RequestResult<void>>
        >
    with
        $FutureModifier<RequestResult<void>>,
        $FutureProvider<RequestResult<void>> {
  const CreateRecipeProvider._({
    required CreateRecipeFamily super.from,
    required CreateRecipeModel super.argument,
  }) : super(
         retry: null,
         name: r'createRecipeProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$createRecipeHash();

  @override
  String toString() {
    return r'createRecipeProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<RequestResult<void>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<RequestResult<void>> create(Ref ref) {
    final argument = this.argument as CreateRecipeModel;
    return createRecipe(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is CreateRecipeProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$createRecipeHash() => r'f1a6a4d22aee76380c4ff0aa62d686e06b02f5ab';

final class CreateRecipeFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<RequestResult<void>>,
          CreateRecipeModel
        > {
  const CreateRecipeFamily._()
    : super(
        retry: null,
        name: r'createRecipeProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  CreateRecipeProvider call(CreateRecipeModel recipe) =>
      CreateRecipeProvider._(argument: recipe, from: this);

  @override
  String toString() => r'createRecipeProvider';
}

@ProviderFor(getIngredients)
const getIngredientsProvider = GetIngredientsFamily._();

final class GetIngredientsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ShortItem>>,
          List<ShortItem>,
          FutureOr<List<ShortItem>>
        >
    with $FutureModifier<List<ShortItem>>, $FutureProvider<List<ShortItem>> {
  const GetIngredientsProvider._({
    required GetIngredientsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'getIngredientsProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$getIngredientsHash();

  @override
  String toString() {
    return r'getIngredientsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<ShortItem>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ShortItem>> create(Ref ref) {
    final argument = this.argument as String;
    return getIngredients(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is GetIngredientsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$getIngredientsHash() => r'1cfd58db269f8efd6256e2d2b6114c805ee85ce2';

final class GetIngredientsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<ShortItem>>, String> {
  const GetIngredientsFamily._()
    : super(
        retry: null,
        name: r'getIngredientsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  GetIngredientsProvider call(String recipeId) =>
      GetIngredientsProvider._(argument: recipeId, from: this);

  @override
  String toString() => r'getIngredientsProvider';
}

@ProviderFor(getFullRecipeModels)
const getFullRecipeModelsProvider = GetFullRecipeModelsProvider._();

final class GetFullRecipeModelsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<FullRecipeModel>>,
          List<FullRecipeModel>,
          FutureOr<List<FullRecipeModel>>
        >
    with
        $FutureModifier<List<FullRecipeModel>>,
        $FutureProvider<List<FullRecipeModel>> {
  const GetFullRecipeModelsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getFullRecipeModelsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getFullRecipeModelsHash();

  @$internal
  @override
  $FutureProviderElement<List<FullRecipeModel>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<FullRecipeModel>> create(Ref ref) {
    return getFullRecipeModels(ref);
  }
}

String _$getFullRecipeModelsHash() =>
    r'f2a4562a85eee4f8d2c314635b6401c1710b9c87';
