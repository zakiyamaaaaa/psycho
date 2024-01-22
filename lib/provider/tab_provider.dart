import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'tab_provider.g.dart';

enum TabType {
  home,
  history,
  setting
}

@riverpod
class Tab extends _$Tab {

  @override
  TabType build() {
    return TabType.home;
  }

  void switchTab(TabType tabType) {
    state = tabType;
  }
}