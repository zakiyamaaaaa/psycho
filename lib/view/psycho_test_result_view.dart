import 'package:flutter/material.dart';
import 'package:psycho/model/question.dart';
import 'package:psycho/provider/data_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// スクロール可能なView
class PsychoTestResultView extends ConsumerWidget {
  PsychoTestResultView({required this.question, Key? key}) : super(key: key);

  final Question question;
  // final int selectedIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selection = question.content.options.firstWhere((element) => element.isSelected == true);
    final selectedIndex = question.content.options.indexWhere((element) => element.isSelected == true);
    final data = ref.watch(dataProvider);
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [Color(0xFFFF7640), Colors.white], begin: Alignment.topCenter, end: Alignment.bottomCenter)
          ),
        child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
          children: [ 
            Container(
              margin: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(15),
                    margin: const EdgeInsets.only(bottom: 20),
                    // 背景白
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Text(
                        '${selection.text}を選んだあなたは・・・\n${selection.answer1}のタイプです',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                      Text(
                        '${selection.answer2}',
                        style: TextStyle(fontSize: 16),
                      ),
                      ],
                    ),
                  ),
                  const Text("その他の項目について", style: TextStyle(fontSize: 20),),
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: question.content.options.length,
                    itemBuilder: (BuildContext context, int index) {
                    // selectedIndex == indexの場合は表示しない
                    if (selectedIndex == index) {
                      return Container();
                    } else {
                      return PsychoTestResultOthersContainer(option: question.content.options[index],);
                    }
                  }),
                ],
            ),),
            ElevatedButton(onPressed: (){
              ref.read(dataProvider.notifier).updateFavorite(question);
            }, child: Text('お気に入りに追加')),
            ElevatedButton(onPressed: (){
              ref.read(dataProvider.notifier).updateAnswered(question);
              Navigator.popUntil(context, ModalRoute.withName('/'));
            }, child: Text('閉じる')),
            // List.generate(question.content.options.length - 1, (index) => PsychoTestResultOthersContainer())
          ]
        ),
        
      ),
    ),
      ),
    );
  }
}

class PsychoTestResultOthersContainer extends StatelessWidget {
  PsychoTestResultOthersContainer({required this.option, Key? key}) : super(key: key);
   final Option option;

  @override
  Widget build(BuildContext context) {
    return Column(
      children:[
        Container(
          padding: const EdgeInsets.all(5),
          margin: const EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 10),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(
            option.text,
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
        Container(
          child: Text(
            option.answer2,
            style: TextStyle(fontSize: 16),
          ),
        ),
      ]
    );
  }
}