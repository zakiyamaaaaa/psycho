// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$currentQuestionHash() => r'e713a45d0d4460b4d57a043fd9f38e5a3cfad415';

/// See also [currentQuestion].
@ProviderFor(currentQuestion)
final currentQuestionProvider = AutoDisposeFutureProvider<Question?>.internal(
  currentQuestion,
  name: r'currentQuestionProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentQuestionHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef CurrentQuestionRef = AutoDisposeFutureProviderRef<Question?>;
String _$answeredQuestionsHash() => r'fb98f647011a4b0fde349ed7249d4b173629ed2a';

/// See also [answeredQuestions].
@ProviderFor(answeredQuestions)
final answeredQuestionsProvider =
    AutoDisposeFutureProvider<List<Question>>.internal(
  answeredQuestions,
  name: r'answeredQuestionsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$answeredQuestionsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AnsweredQuestionsRef = AutoDisposeFutureProviderRef<List<Question>>;
String _$favoriteQuestionsHash() => r'992a19a9d1550bc1025d4fc87bf22dd2bcea945b';

/// See also [favoriteQuestions].
@ProviderFor(favoriteQuestions)
final favoriteQuestionsProvider =
    AutoDisposeFutureProvider<List<Question>>.internal(
  favoriteQuestions,
  name: r'favoriteQuestionsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$favoriteQuestionsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef FavoriteQuestionsRef = AutoDisposeFutureProviderRef<List<Question>>;
String _$dataHash() => r'1fefd7ec7502bf63de15829fc79c78142313cc7f';

/// See also [Data].
@ProviderFor(Data)
final dataProvider = AsyncNotifierProvider<Data, List<Question>>.internal(
  Data.new,
  name: r'dataProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$dataHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Data = AsyncNotifier<List<Question>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
