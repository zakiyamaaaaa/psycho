import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:psycho/provider/data_provider.dart';
import 'package:psycho/view/home_view.dart';

class HistoryView extends ConsumerStatefulWidget {
  const HistoryView({super.key});

  @override
  _HistoryViewState createState() => _HistoryViewState();
}

class _HistoryViewState extends ConsumerState<HistoryView> {

  final segmentedOption = ['テスト履歴', 'お気に入り'];
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/backgroundimage_home.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: SingleChildScrollView(
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
                      setState(() {
                        selectedIndex = segmentedOption.indexOf(value);
                      });
                    }
                  },
                ),
              ],
            ),
            ),
            HistoryExpansionTile(selectedIndex: selectedIndex),
          ]
        ),
        ),
      ),
      ),
    );
  }
}

class HistoryExpansionTile extends ConsumerWidget {
  const HistoryExpansionTile({required this.selectedIndex, Key? key}) : super(key: key);
  
  final int selectedIndex;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final answeredQuestions = ref.watch(dataProvider.notifier).getAnsweredQuestions();
    final favoriteQuestions = ref.watch(dataProvider.notifier).getFavoriteQuestions();
    // final answeredQuestions = ref.watch(dataProvider).where((element) => element.isAnswered = false).toList();
    // final favoriteQuestions = ref.watch(dataProvider).where((element) => element.isFavorite = false).toList();
    switch (selectedIndex) {
      case 0:
      switch (answeredQuestions.isEmpty) {
        case true:
          return const Center(
            child: Text('テスト履歴がありません'),
          );
        case false:
          return ListView.builder(
              shrinkWrap: true,
              itemCount: answeredQuestions.length,
              itemBuilder: (BuildContext context, int index) {
                final question = answeredQuestions[index];
                return ExpansionTile(
            title: Text(question.title),
            childrenPadding: const EdgeInsets.all(20),
            subtitle: Text('あなたの回答\n${question.content.options.firstWhere((element) => element.isSelected).answer1}'),
            children: [
              Text(question.content.options.firstWhere((element) => element.isSelected).answer2),
            ]
            );
              },
          );
      }
      case 1:
        switch (favoriteQuestions.isEmpty) {
          case true:
            return const Center(
              child: Text('お気に入りがありません'),
            );
          case false:
          return ListView.builder(
              shrinkWrap: true,
              itemCount: favoriteQuestions.length,
              itemBuilder: (BuildContext context, int index) {
                final question = favoriteQuestions[index];
                return PsychoTestContainer(question: question);
              },
          );
        }
      default:
        return Container();
    }
  }
}