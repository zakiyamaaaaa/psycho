// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_provider2.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$currentQuestionHash() => r'46563a8db94741b8fc03437ad2dc849a80eb87b0';

/// See also [currentQuestion].
@ProviderFor(currentQuestion)
final currentQuestionProvider = AutoDisposeFutureProvider<Question>.internal(
  currentQuestion,
  name: r'currentQuestionProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentQuestionHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef CurrentQuestionRef = AutoDisposeFutureProviderRef<Question>;
String _$data2Hash() => r'1d9738bf20c4a61b9d4119c60a942499b2c2e8d4';

/// See also [Data2].
@ProviderFor(Data2)
final data2Provider = AsyncNotifierProvider<Data2, List<Question>>.internal(
  Data2.new,
  name: r'data2Provider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$data2Hash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Data2 = AsyncNotifier<List<Question>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
