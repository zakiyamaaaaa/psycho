import 'package:flutter/material.dart';
import 'package:psycho/model/question.dart';
import 'package:psycho/provider/data_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// スクロール可能なView
class PsychoTestResultView extends ConsumerWidget {
  PsychoTestResultView({required this.question, required this.selectedIndex, Key? key}) : super(key: key);

  final Question question;
  final int selectedIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selection = question.content.options[selectedIndex];
    final data = ref.watch(dataProvider);
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [Color(0xFFFF7640), Colors.white], begin: Alignment.topCenter, end: Alignment.bottomCenter)
          ),
        child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Text(
                '${selection.text}を選んだあなたは・・・\n${selection.answer1}のタイプです',
                style: TextStyle(fontSize: 40),
              ),
            ),
            Container(
              child: Text(
                '${selection.answer2}',
                style: TextStyle(fontSize: 20),
              ),
            ),
            Text("その他の項目について"),
            ListView.builder(
              shrinkWrap: true,
              itemCount: question.content.options.length - 1,
              itemBuilder: (BuildContext context, int index) {
              // selectedIndex == indexの場合は表示しない
              if (selectedIndex == index) {
                return Container();
              } else {
                return PsychoTestResultOthersContainer(option: question.content.options[index],);
              }
            }),
            ElevatedButton(onPressed: (){
              ref.read(dataProvider.notifier).updateFavorite(question);
            }, child: Text('お気に入りに追加')),
            ElevatedButton(onPressed: (){
              ref.read(dataProvider.notifier).updateAnswered(question);
              Navigator.popUntil(context, ModalRoute.withName('/'));
            }, child: Text('閉じる')),
            // List.generate(question.content.options.length - 1, (index) => PsychoTestResultOthersContainer())
          ],
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
          child: Text(
            option.text,
            style: TextStyle(fontSize: 40),
          ),
        ),
        Container(
          child: Text(
            option.answer2,
            style: TextStyle(fontSize: 20),
          ),
        ),
      ]
    );
  }
}