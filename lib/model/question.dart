import 'package:isar/isar.dart';

part 'question.g.dart';

@collection
class Question {
  Id id = Isar.autoIncrement;
  late String title;
  late String description;
  @enumerated
  late Category category;
  bool isAnswered = false;
  bool isFavorite = false;
  late String imagePath;
  late DateTime createdDate;
  late DateTime answeredDate;
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
  bool isSelected = false;
}

enum Category {
  love(0),
  business(1),
  relationship(2),
  character(3);

  const Category(this.num);

  final int num;
}