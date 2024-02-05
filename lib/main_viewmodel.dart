
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:psycho/domains/model/shared_preferences_manager.dart';
import 'package:psycho/domains/model/user_repository.dart';
import 'package:psycho/provider/data_provider.dart';

/// main.dartに使用するViewModel

class MainViewModel {
  MainViewModel(this.ref);
  WidgetRef ref;

  // 初回起動時にUserデータを作成
  void checkFirstLaunch() {
    SharedPreferencesManager.isFirstLaunch().then((value) {
    switch (value) {
      case true:
        break;
      case false:
      // Userデータの作成
      final userRepo = UserRepository(ref);
      _loadJSON();
      () async {
        await userRepo.create();
      }();
        SharedPreferencesManager.writeFirstLaunch();
        break;
    }
  });
  }

  Future<void> _loadJSON() async {
    await ref.read(dataProvider.notifier).save();
  }
}