import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:psycho/mock/mock_data.dart';
import 'package:psycho/model/question.dart';

part 'data_provider.g.dart';

@Riverpod(keepAlive: true)
class Data extends _$Data {
  List<Question> build() {
    final question = mockData.map((e) => Question()
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

  void updateFavorite(Question question) {
    question.isFavorite = !question.isFavorite;
  }

  void updateAnswered(Question question) {
    question.isAnswered = true;
  }
}