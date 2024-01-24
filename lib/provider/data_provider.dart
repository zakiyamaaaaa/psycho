import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:psycho/mock/mock_data.dart';
import 'package:psycho/model/question.dart';

part 'data_provider.g.dart';

@Riverpod(keepAlive: true)
class Data extends _$Data {
  List<Question> build() {
    final question = mockData.map((e) => Question()
      ..id = e['id'] as int
      ..title = e['title'] as String
      ..description = e['description'] as String
      ..category = Category.values[e['Category'] as int]
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
    return question;
  }

  Question? getCurrentQuestion() {
    // answeredDateが一番新しいものを取得
    final answeredQuestions = state.where((element) => element.isAnswered == true).toList();
    if (answeredQuestions.isEmpty) {
      return null;
    }
    answeredQuestions.sort((a, b) => b.answeredDate!.compareTo(a.answeredDate!));
    return answeredQuestions.first;
  }

  void updateFavorite(Question question) {
    question.isFavorite = !question.isFavorite;
    state = [...state];
  }

  void updateAnswered(Question question) {
    question.isAnswered = true;
    question.answeredDate = DateTime.now();
    state = [...state];
  }

  int getAnsweredCount() {
    return state.where((element) => element.isAnswered == true).length;
  }

  List<Question> getQuestions() {
    state = [...state];
    return state;
  }

  List<Question> getAnsweredQuestions() {
    return state.where((element) => element.isAnswered == true).toList();
  }

  List<Question> getFavoriteQuestions() {
    return state.where((element) => element.isFavorite == true).toList();
  }
}