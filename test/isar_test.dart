import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:psycho/domains/model/question.dart';
import 'package:psycho/infrastructures/data_source.dart';
import 'package:psycho/provider/data_provider.dart';
import 'package:psycho/provider/isar_provider.dart';
import 'package:isar/isar.dart';

void main() {
  late Isar isar;
  late Data testDataProvider;
  
  /// すべてのテストが始まる前に一度だけ実行される
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await Isar.initializeIsarCore(download: true);
    final dir = await Directory.systemTemp.createTemp();
    // final dir = await getApplicationSupportDirectory();
    // final dir = await getApplicationDocumentsDirectory();
    // TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
    // .setMockMethodCallHandler(const MethodChannel('plugins.flutter.io/path_provider'), (message){
    //   if (message.method == 'getApplicationDocumentsDirectory') {
    //     return Future.value(dir.path);
    //   }
    //   return null;
    // });
    isar = await Isar.open([QuestionSchema], directory: dir.path);
    final container = ProviderContainer(
      overrides: [
        isarProvider.overrideWith((FutureProviderRef<Isar> ref) async => isar),
      ],
    );
    testDataProvider = container.read(dataProvider.notifier);
    testDataProvider.save();
  });

  /// すべてのテストが終了後に実行
  tearDownAll(() async {
    await isar.close();
  });

  group("データベースにデータが存在する", () {
    test("データベースの元が存在する", (){
      expect(dataSource, isA<List<Map<String, dynamic>>>());
    });
    test("Isarインスタンスが存在する", () async {
      expect(isar.isOpen, true);
    });

    test("データベースにデータが存在する", () async {
      debugPrint(testDataProvider.state.toString());
      expect(testDataProvider.state, isA<AsyncLoading>());
      await testDataProvider.future;
      expect(testDataProvider.state, isA<AsyncData>());
      expect(testDataProvider.state.value!.length, greaterThan(0));
      expect(await isar.questions.count(), greaterThan(0));
    });
  });
}