import 'package:isar/isar.dart';
import 'package:psycho/domains/model/user.dart';
import 'package:psycho/domains/model/question.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:path_provider/path_provider.dart';

part 'isar_provider.g.dart';

@Riverpod(keepAlive: true)
Future<Isar> isar(IsarRef ref) async {
  final dir = await getApplicationDocumentsDirectory();
  return Isar.open([UserSchema, QuestionSchema], directory: dir.path, inspector: true);
}