import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
part 'question.g.dart';

@collection
class Question {
  late Id id ;
  late String title;
  late String description;
  @enumerated
  late Category category;
  bool isAnswered = false;
  bool isFavorite = false;
  late String imagePath;
  late DateTime createdDate;
  late DateTime? answeredDate;
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
  character(1),
  relationship(2),
  fortune(3),
  none(-1);
  

  const Category(
    this.num
    // this.numによってdisplayTextを返す
    );

  final int num;

  // Stringで返すときにlocalaizeする
  String displayText(BuildContext context) {
    switch (this) {
      case Category.love:
        return AppLocalizations.of(context)!.love;
      case Category.relationship:
        return AppLocalizations.of(context)!.relationship;
      case Category.character:
        return AppLocalizations.of(context)!.character;
      case Category.fortune:
        return AppLocalizations.of(context)!.fortune;
      default:
        return '未分類';
    }
  }
}