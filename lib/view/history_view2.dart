import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:psycho/provider/data_provider2.dart';
import 'package:psycho/provider/segment_index_provider.dart';
import 'package:psycho/view/home_view.dart';
import 'package:psycho/view/home_view2.dart';

class HistoryView2 extends ConsumerStatefulWidget {
  const HistoryView2({super.key});

  @override
  _HistoryViewState2 createState() => _HistoryViewState2();
}

class _HistoryViewState2 extends ConsumerState<HistoryView2> {

  final segmentedOption = ['テスト履歴', 'お気に入り'];
  @override
  void initState() {
    debugPrint('initState in history view2');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int selectedIndex = ref.watch(segmentedIndexProvider);
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          // height: double.infinity,
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
                    segmentedOption[0]: Text(segmentedOption[0]),
                    segmentedOption[1]: Text(segmentedOption[1]),
                  },
                  onValueChanged: (value) {
                    if (value != null) {
                      ref.read(segmentedIndexProvider.notifier).update(segmentedOption.indexOf(value));
                      setState(() {
                        // ref.invalidate(answeredQuestionsProvider);
                        // ref.invalidate(favoriteQuestionsProvider);
                        
                        // selectedIndex = segmentedOption.indexOf(value);
                      });
                    }
                  },
                ),
              ],
            ),
            ),
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
  
  final int selectedIndex;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final answeredQuestions = ref.watch(answeredQuestionsProvider);
    final favoriteQuestions = ref.watch(favoriteQuestionsProvider);
    switch (selectedIndex) {
      case 0:
      return answeredQuestions.when(data: (data){
        return ListView.builder(
              physics: ScrollPhysics(),
              shrinkWrap: true,
              itemCount: data.length,
              itemBuilder: (BuildContext context, int index) {
                final question = data[index];
                return ExpansionTile(
            title: Text(question.title),
            childrenPadding: const EdgeInsets.all(20),
            subtitle: Text('あなたの回答\n${question.content.options.firstWhere((element) => element.isSelected).answer1}'),
            children: [
              Text(question.content.options.firstWhere((element) => element.isSelected).answer2),
              const SizedBox(height: 10,),
              Text("回答日：${question.answeredDate}", textAlign: TextAlign.right,),
            ]
            );
              },
          );
      }, error: (e,s){
        return const Center(
          child: Text('テスト履歴がありません'),
        );
      }, loading: (){
        // loading widget
        return CircularProgressIndicator();
      });
      case 1:
      return favoriteQuestions.when(data: (favorites){
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
        return const Center(
          child: Text('テスト履歴がありません'),
        );
      }, loading: (){
        // loading widget
        return CircularProgressIndicator();
      });
      default:
        return Container();
    }
    

    // switch (selectedIndex) {
    //   case 0:
    //     answeredQuestions.when(
    //       data: (data){
    //         debugPrint('answered data fetched in history view2');
    //         return ListView.builder(
    //           shrinkWrap: true,
    //           itemCount: data.length,
    //           itemBuilder: (BuildContext context, int index) {
    //             final question = data[index];
    //             return PsychoTestContainer2(question: question);
    //           },
    //         );
    //       },
    //       error: (e,s){
    //         return const Center(
    //           child: Text('テスト履歴がありません'),
    //         );
    //       },
    //       loading: (){
    //         return const Center(
    //           child: Text('読み込み中'),
    //         );
    //       }
    //     );
    //     return Container();
    //   case 1:
    //     favoriteQuestions.when(
    //       data: (data){
    //         return ListView.builder(
    //           shrinkWrap: true,
    //           itemCount: data.length,
    //           itemBuilder: (BuildContext context, int index) {
    //             final question = data[index];
    //             return PsychoTestContainer2(question: question);
    //           },
    //         );
    //       },
    //       error: (e,s){
    //         return const Center(
    //           child: Text('お気に入りがありません'),
    //         );
    //       },
    //       loading: (){
    //         return const Center(
    //           child: Text('読み込み中'),
    //         );
    //       }
    //     );
    //     return Container();
    //   default:
    //     return Container();
    // }
  }
}