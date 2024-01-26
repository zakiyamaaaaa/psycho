import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:psycho/model/question.dart';
import 'package:psycho/view/psycho_test_result_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:psycho/provider/data_provider2.dart';
import 'package:psycho/view/description_view.dart';

class HomeView2 extends ConsumerStatefulWidget {
  const HomeView2({Key? key}) : super(key: key);

  @override
  _HomeViewState2 createState() => _HomeViewState2();
}

class _HomeViewState2 extends ConsumerState<HomeView2> {
  bool _isToggle = false;
  Category dropdownValue = Category.none;
  Future<List<Question>>? questionsList;

  @override
  void initState() {
    super.initState();
    debugPrint('initState in home view2');
    _loadJSON().then((_) => Future.delayed(const Duration(seconds: 1), () => _getQuestions()));
  }

  Future<void> _getQuestions() async {
    setState(() {
      questionsList = ref.read(data2Provider.future);
    });
  }

  Future<void> _loadJSON() async {
    await ref.read(data2Provider.notifier).save();
  }

  @override
  Widget build(BuildContext context) {
    final List<DropdownMenuItem<Category>> _dropDownMenuItems = Category.values.map((category) {
    return DropdownMenuItem(
      value: category,
      child: Text(category == Category.none ? "すべて" : category.displayText(context)),
    );
  }).toList();
    final dataProvider = ref.watch(data2Provider);
    // final current = ref.watch(data2Provider.notifier).getCurrentQuestion();
    final current2 = ref.watch(currentQuestionProvider);
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
              Container(
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
                child: current2.when(data:
                (data) {
                  // 診断済みの質問を取得、まだ無い場合はnull
                  if (data == null || current2.isRefreshing) {
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
                  // グラデーションカラー
                  // backgroundColor: Colors.orange
                ),
                onPressed: () {
                  // if (data == null) return;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      fullscreenDialog: true,
                      builder: (context) => PsychoTestResultView(question: data)),
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
                    Text(AppLocalizations.of(context)!.yourCurrentAnswer, style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 20),),
                    Text(data.title, style: TextStyle(color: Colors.black54),),
                    Text(data.content.options.firstWhere((element) => element.isSelected == true).answer1, style: TextStyle(color: Colors.black54, ),),
                  ],
                ),
                )
                  );
                }
                ,
                error: (e,s)=> Center(child: Text(AppLocalizations.of(context)!.errorOccurred),),
                loading: (){
                  return Center(child: Text(AppLocalizations.of(context)!.loadingText),);
                })
              ),
              Container(
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
                          Text(AppLocalizations.of(context)!.category, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
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
                            value: dropdownValue,
                            iconSize: 20,
                            underline: Container(),
                            borderRadius: BorderRadius.circular(10),
                            items: _dropDownMenuItems,
                            onChanged: (value) {
                              setState(() {
                                if(value != null) dropdownValue = value;
                                ref.invalidate(data2Provider);
                              });
                            },
                          ),
                          ),
                          const Spacer(),
                          Text(AppLocalizations.of(context)!.exception,),
                          // CupertinoSwitch(value: _isToggle, onChanged: (value) => setState(() {
                          //   _isToggle = value;
                          //   // ref.refresh(data2Provider.future);
                          // })),
                          CupertinoSwitch(
                            activeColor: Colors.orange,
                            value: _isToggle,
                            onChanged: (value){
                            setState(() {
                              _isToggle = value;
                              ref.invalidate(data2Provider);
                            });

                          }),
                  ],
                ),
              ),
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
                child: dataProvider.when(data: (data) {
                  if (dataProvider.isRefreshing) {
                    // return const Center(child: CircularProgressIndicator(),);
                    return Container();
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return PsychoTestContainer2(question: data[index], isDoneFlag: _isToggle, category: dropdownValue,);
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

class PsychoTestContainer2 extends ConsumerStatefulWidget {
  const PsychoTestContainer2({required this.question, this.isDoneFlag = false, this.category = Category.none, Key? key}) : super(key: key);
  final Question question;
  final bool isDoneFlag;
  final Category category;

  @override
  _PsychoTestContainerState2 createState() => _PsychoTestContainerState2(question: question, isDoneFlag: isDoneFlag, category: category);
}

class _PsychoTestContainerState2 extends ConsumerState<PsychoTestContainer2> {
  _PsychoTestContainerState2({required this.question, this.isDoneFlag = false, this.category = Category.none, Key? key});
  final Question question;
  final bool isDoneFlag;
  final Category category;

  @override
  Widget build(BuildContext context) {
    // switch (category) {
    //   case Category.none:
    //     switch (isDoneFlag) {
    //       case true:
    //         switch (question.isAnswered) {
    //           case true:
    //             return Container();
    //           case false:
    //             return 
    //         }
    //     }
    // }
    return ((isDoneFlag && question.isAnswered) || (category != Category.none && category != question.category)) ? Container() : 
    Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              // width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[20],
              ),
              child: Stack(
                children: [
                  ElevatedButton( onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DescriptionView(question: question)),
                      );
                      setState(() {
                        ref.invalidate(currentQuestionProvider);
                        ref.invalidate(answeredQuestionsProvider);
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(0),
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: Colors.grey[10],
                    ),
                  child:
                  Column(
                    children: [
                        Container(
                      height: 150,
                      width: double.infinity,
                      child: Image.asset(
                        question.imagePath,
                        colorBlendMode: BlendMode.overlay,
                        fit: BoxFit.fitWidth,),
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
                              Text(question.title, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
                              Container(
                                margin: const EdgeInsets.only(bottom: 5),
                                child: Text("#${question.category.displayText(context)}", style: TextStyle(color: Colors.black, ),),
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.arrow_forward_ios, color: Colors.black,),
                      ],
                    ),
                    ),
                    ],
                    ),
                  ),
                  Positioned.fill(
                  child: IgnorePointer(
                    ignoring: true,
                    child: question.isAnswered ? Container(
                      // width: double.infinity,
                      height: 150,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ) : Container(),
                  ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: IconButton(
                      onPressed: () async {
                        await ref.read(data2Provider.notifier).updateFavorite(question);
                        ref.invalidate(answeredQuestionsProvider);
                        ref.invalidate(favoriteQuestionsProvider);
                        // ref.invalidate(data2Provider);
                        setState(() {
                        });
                      },
                      icon: Icon(
                        question.isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: Colors.pink[200],
                      ),
                    ),
                  ),
                  // 三角形のコンテナ

                  question.isAnswered ? Positioned(
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
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ) : Container(),
                ],
              ),
            );
  }
}