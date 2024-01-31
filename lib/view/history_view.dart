import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:psycho/provider/data_provider.dart';
import 'package:psycho/provider/segment_index_provider.dart';
import 'package:psycho/view/home_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lottie/lottie.dart';

class HistoryView extends ConsumerStatefulWidget {
  const HistoryView({super.key});

  @override
  _HistoryViewState2 createState() => _HistoryViewState2();
}

class _HistoryViewState2 extends ConsumerState<HistoryView> {

  
  @override
  void initState() {
    debugPrint('initState in history view2');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final segmentedOption = [AppLocalizations.of(context)!.testHistory, AppLocalizations.of(context)!.favorites];
    int selectedIndex = ref.watch(segmentedIndexProvider);
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(20),
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/backgroundimage_home.png'),
              fit: BoxFit.cover,
            ),
          ),
          // child: SingleChildScrollView(
          child: Column(
          children: [
            CupertinoPageScaffold(
            child: Column(
              children: [
                CupertinoSlidingSegmentedControl(
                  groupValue: segmentedOption[selectedIndex],
                  children: {
                    segmentedOption[0]: Text(segmentedOption[0], style: selectedIndex == 0 ? TextStyle(color: Colors.orange.shade900, fontWeight: FontWeight.bold): const TextStyle(color: Colors.black),),
                    segmentedOption[1]: Text(segmentedOption[1], style: selectedIndex == 1 ? TextStyle(color: Colors.orange.shade900, fontWeight: FontWeight.bold): const TextStyle(color: Colors.black),),
                  },
                  onValueChanged: (value) {
                    if (value != null) {
                      ref.read(segmentedIndexProvider.notifier).update(segmentedOption.indexOf(value));
                      setState(() {
                      });
                    }
                  },
                ),
              ],
            ),
            ),
            const SizedBox(height: 20,),
            Expanded(
              child: SingleChildScrollView(
                physics: ScrollPhysics(),
                child: HistoryExpansionTile2(selectedIndex: selectedIndex),
              ),
            ),
          ]
        ),
        ),
      ),
      // ),
    );
  }
}

class HistoryExpansionTile2 extends ConsumerWidget {
  const HistoryExpansionTile2({required this.selectedIndex, Key? key}) : super(key: key);

  String dateFormat(DateTime? date) {
    if (date == null) {
      return '';
    }
    DateFormat format = DateFormat('yyyy/MM/dd/HH:mm');
    return format.format(date);
  }

  final int selectedIndex;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final answeredQuestions = ref.watch(answeredQuestionsProvider);
    final favoriteQuestions = ref.watch(favoriteQuestionsProvider);
    switch (selectedIndex) {
      case 0:
      return answeredQuestions.when(data: (data){
        if (data.isEmpty) {
          return Center(
            // Fix: センターにしたいが、うまくいかないので一旦これで。
            heightFactor: 2.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children:
              [
                Lottie.asset('assets/crying.json', width: 200, height: 200),
                Text(AppLocalizations.of(context)!.noTestHistory),
              ],
            ),
          );
        }
        return ListView.builder(
              physics: ScrollPhysics(),
              shrinkWrap: true,
              itemCount: data.length,
              // itemCount= 0のときはCenterにテスト履歴がありませんを表示
              itemBuilder: (BuildContext context, int index) {
                final question = data[index];
                debugPrint('answered question: ${data.length}');
                return ExpansionTile(
            title: Text(question.title),
            expandedCrossAxisAlignment: CrossAxisAlignment.end,
            childrenPadding: const EdgeInsets.all(20),
            subtitle: Text('診断結果\n${question.content.options.firstWhere((element) => element.isSelected).answer1}'),
            children: [
              Text(question.content.options.firstWhere((element) => element.isSelected).answer2),
              const SizedBox(height: 10,),
              Text("回答日：${dateFormat(question.answeredDate)}", textAlign: TextAlign.right, style: const TextStyle(color: Colors.black54),),
            ]
            );
              },
          );
      }, error: (e,s){
        return Center(
          child: Text(AppLocalizations.of(context)!.noTestHistory),
        );
      }, loading: (){
        // loading widget
        return CircularProgressIndicator();
      });
      case 1:
      return favoriteQuestions.when(data: (favorites){
        if (favorites.isEmpty) {
          return Center(
            // Fix: センターにしたいが、うまくいかないので一旦これで。
            heightFactor: 2.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children:
              [
                Lottie.asset('assets/making.json', width: 200, height: 200),
                Text(AppLocalizations.of(context)!.noFavorites),
              ],
            ),
          );
        }
        if (favoriteQuestions.isRefreshing) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView.builder(
          physics: ScrollPhysics(),
          shrinkWrap: true,
          itemCount: favorites.length,
          itemBuilder: (BuildContext context, int index) {
            final question = favorites[index];
            debugPrint('favorite question: ${question.title}');
            return PsychoTestContainer2(question: question);
          },
        );
      }, error: (e,s){
        return Center(
          child: Text(AppLocalizations.of(context)!.noFavorites),
        );
      }, loading: (){
        // loading widget
        return CircularProgressIndicator();
      });
      default:
        return Container(child: Text(AppLocalizations.of(context)!.noFavorites));
    }
  }
}