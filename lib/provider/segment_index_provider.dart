import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'segment_index_provider.g.dart';

@riverpod
class SegmentedIndex extends _$SegmentedIndex {
  int build() {
    return 0;
  }

  void update(int index) {
    state = index;
  }
}