import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:psycho/domains/model/question.dart';
import 'package:psycho/presentation/home/psycho_test_result_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:psycho/provider/data_provider.dart';
import 'package:psycho/presentation/home/description_view.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  /// 診断済みを表示するかどうかのフラグ
  bool _isToggle = false;
  
  Future<List<Question>>? questionsList;

  @override
  void initState() {
    super.initState();
    // _loadJSON().then((_) => Future.delayed(const Duration(seconds: 1), () => _getQuestions()));
    _getQuestions();
  }

  Future<void> _getQuestions() async {
    setState(() {
      questionsList = ref.read(dataProvider.future);
    });
  }

  Future<void> _loadJSON() async {
    await ref.read(dataProvider.notifier).save();
  }

  @override
  Widget build(BuildContext context) {

    final questions = ref.watch(dataProvider);
    final category = ref.watch(categoriesProvider);
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/backgroundimage_home.png'),
              fit: BoxFit.cover,
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
          // padding :const EdgeInsets.all(20),
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const YourCurrentAnswerContainer(),
              TestFilterHeader(),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                  color: Colors.white.withOpacity(0.6),
                ),
                child: questions.when(data: (data) {
                  if (questions.isRefreshing) {
                    // return const Center(child: CircularProgressIndicator(),);
                    return Container();
                  }
                  return ListView.builder(
                    key: const PageStorageKey('home'),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return PsychoTestContainer(question: data[index], isDoneFlag: _isToggle, category: category,);
                    },
                  );
                },
                error: (e, s) => Center(child: Text(AppLocalizations.of(context)!.errorOccurred),
                ),
                loading:
                () => const Center(child: CircularProgressIndicator(),),
                ),
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }
}

/// 最近のテスト結果を表示するコンテナ
/// テストをまだ受けてない場合は非表示
/// コンテナをタップすると、結果画面に遷移
class YourCurrentAnswerContainer extends ConsumerWidget {
  const YourCurrentAnswerContainer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = ref.watch(currentQuestionProvider);
    return Container(
        // グラデーションカラー
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.9),
              spreadRadius: 0,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
          borderRadius: BorderRadius.circular(10),
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color(0xFFFF9900),
              Color(0xFFFFCC7F),
            ],
          ),
        ),
        // height: 80,
        child: current.when(
            data: (data) {
              // 診断済みの質問を取得、まだ無い場合はnull
              if (data == null || current.isRefreshing) {
                return Container();
              }
              return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          fullscreenDialog: true,
                          builder: (context) =>
                              PsychoTestResultView(question: data)),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      // 左寄せ
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 白いテキスト
                        Text(
                          AppLocalizations.of(context)!.yourCurrentAnswer,
                          style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                        Text(
                          data.title,
                          style: TextStyle(color: Colors.black87),
                        ),
                        Text(
                          data.content.options
                              .firstWhere(
                                  (element) => element.isSelected == true)
                              .answer1,
                          style: TextStyle(
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ));
            },
            error: (e, s) => Center(
                  child: Text(AppLocalizations.of(context)!.errorOccurred),
                ),
            loading: () {
              return Center(
                child: Text(AppLocalizations.of(context)!.loadingText),
              );
            }));
  }
}

/// テストのカードを表示するエリアのヘッダー
/// カテゴリーのドロップダウンと、診断済みのみ表示するトグルボタンでフィルター出来る
//ignore: must_be_immutable
class TestFilterHeader extends ConsumerWidget {
  TestFilterHeader({Key? key}) : super(key: key);
  bool _isToggle = false;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<DropdownMenuItem<Category>> dropDownMenuItems =
        Category.values.map((category) {
      return DropdownMenuItem(
        value: category,
        child: Text(category == Category.none
            ? AppLocalizations.of(context)!.all
            : category.displayText(context)),
      );
    }).toList();
    return Container(
      width: double.infinity,
      height: 80,
      margin: const EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.orange, width: 2),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
        color: Colors.orange.shade200,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Text(
            AppLocalizations.of(context)!.category,
            style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          Container(
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.orange),
              color: Colors.white.withAlpha(100),
            ),
            child: DropdownButton(
              style: const TextStyle(fontSize: 14, color: Colors.black),
              focusColor: Colors.grey,
              dropdownColor: Colors.white,
              value: ref.read(categoriesProvider),
              iconSize: 20,
              underline: Container(),
              borderRadius: BorderRadius.circular(10),
              items: dropDownMenuItems,
              onChanged: (value) {
                if (value != null) {
                  // dropdownValue = value;
                  ref.read(categoriesProvider.notifier).select(value);
                }
                ref.invalidate(dataProvider);
              },
            ),
          ),
          const Spacer(),
          Text(
            AppLocalizations.of(context)!.exception,
          ),
          CupertinoSwitch(
              activeColor: Colors.orange,
              value: _isToggle,
              onChanged: (value) {
                _isToggle = value;
                ref.invalidate(dataProvider);
              }),
        ],
      ),
    );
  }
}
/// 診断テストのコンテナ
/// タップしたら、詳細画面に遷移
class PsychoTestContainer extends ConsumerWidget {
  const PsychoTestContainer(
      {required this.question,
      this.isDoneFlag = false,
      this.category = Category.none,
      Key? key})
      : super(key: key);
  final Question question;
  final bool isDoneFlag;
  final Category category;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // imageCache.clear();
    imageCache.clearLiveImages();
    return ((isDoneFlag && question.isAnswered) ||
            (category != Category.none && category != question.category))
        ? Container()
        : Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            // width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white),
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey[20],
            ),
            child: Stack(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              DescriptionView(question: question)),
                    );
                    ref.invalidate(currentQuestionProvider);
                    ref.invalidate(answeredQuestionsProvider);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(0),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: Colors.grey[10],
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: 150,
                        width: double.infinity,
                        // child: Image(image: image),
                        child: Image.asset(
                          question.imagePath,
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    question.title,
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(bottom: 5),
                                    child: Text(
                                      "#${question.category.displayText(context)}",
                                      style: TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned.fill(
                  child: IgnorePointer(
                    ignoring: true,
                    child: question.isAnswered
                        ? Container(
                            // width: double.infinity,
                            height: 150,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          )
                        : Container(),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: IconButton(
                    onPressed: () {
                      ref.read(dataProvider.notifier).updateFavorite(question);
                      ref.invalidate(answeredQuestionsProvider);
                    },
                    icon: Icon(
                      size: 30,
                      question.isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: Colors.pink[200],
                    ),
                  ),
                ),
                // 三角形のコンテナ

                question.isAnswered
                    ? Positioned(
                        top: 10,
                        left: 10,
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            AppLocalizations.of(context)!.done,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    : Container(),
              ],
            ),
          );
  }
}
