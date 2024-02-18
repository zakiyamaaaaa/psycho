import 'package:flutter/cupertino.dart';
import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:psycho/infrastructures/data_source.dart';
import 'package:psycho/domains/model/question.dart';
import 'package:psycho/provider/isar_provider.dart';

part 'data_provider.g.dart';

@Riverpod(keepAlive: true)
class Data extends _$Data {
  @override
  Future<List<Question>> build() async {
    final isar = await ref.read(isarProvider.future);
    var questions = await isar.questions.where().findAll();
    while(questions.isEmpty) {
      state = const AsyncValue.loading();
      // questionsが取得できるまで待機
      await Future.delayed(const Duration(milliseconds: 500));
      questions = await isar.questions.where().findAll();
    }
    state = AsyncValue.data(questions);
    return Future.value(questions);
  }

  Future<void> save() async {
    debugPrint("save action");
    final isar = await ref.read(isarProvider.future);
    final questions = await isar.questions.where().findAll();
    debugPrint("questions length: ${questions.length}");
    final lastId = dataSource.last['id'] as int;
    debugPrint("lastId: $lastId");
    if (questions.isEmpty) {
      final questionData = dataSource.map((e) => Question()
      ..id = e['id'] as int
      ..title = e['title'] as String
      ..description = e['description'] as String
      ..category = Category.values[e['Category'] as int]
      ..createdDate = DateTime.now()
      ..answeredDate = null
      ..content = Content()
      ..imagePath = e['imagePath'] as String
      ..content.explanation = e['content']['explanation'] as String
      ..content.options = (e['content']['options'] as List<dynamic>)
          .map((e) => Option()
            ..text = e['text'] as String
            ..answer1 = e['answer1'] as String
            ..answer2 = e['answer2'] as String)
          .toList())
        .toList();
      isar.writeTxn(() async {
        await isar.questions.putAll(questionData);
      });
    } else if ( lastId > questions.last.id) {
      final lastId = questions.last.id;
      final addQuestionData = dataSource.where((element) => element['id'] > lastId).toList();
      debugPrint("addQuestionData length: ${addQuestionData.length}");
      final additionalQuestions = addQuestionData.map((e) => Question()
        ..id = e['id'] as int
        ..title = e['title'] as String
        ..description = e['description'] as String
        ..category = Category.values[e['Category'] as int]
        ..createdDate = DateTime.now()
        ..answeredDate = null
        ..content = Content()
        ..imagePath = e['imagePath'] as String
        ..content.explanation = e['content']['explanation'] as String
        ..content.options = (e['content']['options'] as List<dynamic>)
            .map((e) => Option()
              ..text = e['text'] as String
              ..answer1 = e['answer1'] as String
              ..answer2 = e['answer2'] as String)
            .toList())
            .toList();
        isar.writeTxn(() async {
          await isar.questions.putAll(additionalQuestions);
        });
    } else if(lastId == questions.last.id) {
      return;
    }
  }

  Future<Question?> getCurrentQuestion() async {
    final isar = await ref.read(isarProvider.future);
    final currentAnsweredQuestion = await isar.questions.where().filter().isAnsweredEqualTo(true).findFirst();
    return currentAnsweredQuestion;
  }

  FutureOr<void> updateFavorite(Question question) async {
    final isar = await ref.read(isarProvider.future);
    state.when(data: (data){
      final index = data.indexWhere((element) => element.id == question.id);
      data[index].isFavorite = !data[index].isFavorite;
      isar.writeTxn(() async {
        await isar.questions.put(data[index]);
        state = AsyncValue.data(await isar.questions.where().findAll());
      });
    }, error: (e,t){}, loading: (){});
  }

  void updateAnswered(Question question) async {
    final isar = await ref.read(isarProvider.future);
    
    state.when(data: (data){
      final index = data.indexWhere((element) => element.id == question.id);
      data[index].isAnswered = !data[index].isAnswered;
      data[index].answeredDate = DateTime.now();
      isar.writeTxn(() async {
        await isar.questions.put(data[index]);
      });
    }, error: (e,t){}, loading: (){});
  }
  Future<void> removeAll() async {
    final isar = await ref.read(isarProvider.future);
    isar.writeTxn(() async {
      await isar.questions.clear();
      debugPrint("Remove all");
    });
  }

  Future<int> getAnsweredCount() async {
    final isar = await ref.read(isarProvider.future);
    final answeredQuestions = await isar.questions.where().filter().isAnsweredEqualTo(true).findAll();
    // stateの中からisAnsweredがtrueのものの数を返す
    return answeredQuestions.length;
  }

  Future<List<Question>> getAnsweredQuestions() async {
    final isar = await ref.read(isarProvider.future);
    final answeredQuestions = await isar.questions.where().filter().isAnsweredEqualTo(true).findAll();
    return answeredQuestions;
  }

  Future<List<Question>> getFavoriteQuestions() async {
    final isar = await ref.read(isarProvider.future);
    final favoriteQuestions = await isar.questions.where().filter().isFavoriteEqualTo(true).findAll();
    return favoriteQuestions;
  }
}

@riverpod
Future<Question?> currentQuestion(CurrentQuestionRef ref) async {
  final isar = await ref.read(isarProvider.future);
  // isAnswered = trueがない場合
  final answeredQuestions = await isar.questions.where().filter().isAnsweredEqualTo(true).findAll();
  if (answeredQuestions.isEmpty) {
    return null;
  }
  // answerDateが一番新しいものを取得
  final currentAnsweredQuestion = await isar.questions.where().filter().isAnsweredEqualTo(true).sortByAnsweredDateDesc().findFirst();
  return currentAnsweredQuestion;
}

@riverpod
Future<List<Question>> answeredQuestions(AnsweredQuestionsRef ref) async {
  final questions = ref.watch(dataProvider).value;
  final answeredQuestions = questions?.where((element) => element.isAnswered).toList();
  return answeredQuestions ?? [];
}

@riverpod
Future<List<Question>> favoriteQuestions(FavoriteQuestionsRef ref) async {
  final questions = ref.watch(dataProvider).value;
  final favorites = questions?.where((element) => element.isFavorite).toList();
  return favorites ?? [];
}