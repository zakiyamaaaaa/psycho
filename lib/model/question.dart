import 'package:isar/isar.dart';

part 'question.g.dart';

@collection
class Question {
  Id id = Isar.autoIncrement;
  late String title;
  late String description;
  @enumerated
  late Category category;
  late bool isAnswered;
  late bool isFavorite;
  late DateTime createdDate;
  late Content content;
}

@embedded
class Content {
  late String explanation;
  late List<Option> options;
}

@embedded
class Option {
  late String text;
  late String answer1;
  late String answer2;
}

enum Category {
  love(0),
  business(1),
  relationship(2);

  const Category(this.num);

  final int num;
}