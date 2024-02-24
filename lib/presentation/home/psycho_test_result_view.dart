import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:psycho/domains/model/question.dart';
import 'package:psycho/provider/data_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';



// スクロール可能なView
class PsychoTestResultView extends ConsumerStatefulWidget {
  PsychoTestResultView({required this.question, Key? key}) : super(key: key);

  final Question question;
  // final int selectedIndex;

  @override
  _PsychoTestResultViewState createState() => _PsychoTestResultViewState(question: question);
}

class _PsychoTestResultViewState extends ConsumerState<PsychoTestResultView> {
  _PsychoTestResultViewState({required this.question, Key? key});

  final Question question;
  // final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    final selection = question.content.options.firstWhere((element) => element.isSelected == true);
    final selectedIndex = question.content.options.indexWhere((element) => element.isSelected == true);
    // final data = ref.watch(dataProvider);
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
                        '「${selection.text}」を選んだあなたは…\n${selection.answer1}',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                        SizedBox(height: 10,),
                      Text(
                        '${selection.answer2}',
                        style: TextStyle(fontSize: 16),
                      ),
                      ],
                    ),
                  ),
                  Text(AppLocalizations.of(context)!.otherOptions, style: const TextStyle(fontSize: 20),),
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: question.content.options.length,
                    itemBuilder: (BuildContext context, int index) {
                    if (selectedIndex == index) {
                      return Container();
                    } else {
                      return PsychoTestResultOthersCard(option: question.content.options[index],);
                    }
                  }),
                ],
            ),),
            ElevatedButton(onPressed: question.isFavorite ? null : (){
              HapticFeedback.heavyImpact();
              // TODO: お気に入りに追加後にボタンの状態を変更。UIに反映
              ref.read(dataProvider.notifier).updateFavorite(question);
            }, child: Text(AppLocalizations.of(context)!.addFavorite)),
            const SizedBox(height: 20,),
            ElevatedButton(onPressed: (){
              HapticFeedback.heavyImpact();
              Navigator.popUntil(context, ModalRoute.withName('/'));
            }, child: Text(AppLocalizations.of(context)!.close)),
          ]
        ),
          ),
        ),
      ),
    );
  }
}

class PsychoTestResultOthersCard extends StatelessWidget {
  const PsychoTestResultOthersCard({required this.option, Key? key}) : super(key: key);
   final Option option;

  @override
  Widget build(BuildContext context) {
    return Card(
      // color: Colors.white.withOpacity(0.8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      clipBehavior: Clip.antiAlias,
    child:ExpansionTile(
      shape: Border.all(style: BorderStyle.none),
      collapsedBackgroundColor: Colors.white,
      title: Text(option.text, textAlign: TextAlign.center,), 
    children: [
      Container(
        margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 5),
        child: Text(option.answer2),
      ),
    ],),
    );
  }
}