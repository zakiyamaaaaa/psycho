import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:psycho/domains/model/user.dart';
import 'package:psycho/provider/isar_provider.dart';

// staticクラスを作成
class UserRepository {
  UserRepository(this.ref);
  WidgetRef ref;

  Future<void> create() async {
    final isar = await ref.read(isarProvider.future);
    final user = User()
      ..createdDate = DateTime.now();
    await isar.writeTxn(() async {
      await isar.users.put(user);
    });
  }
}