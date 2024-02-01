import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:psycho/domains/model/question.dart';
import 'package:psycho/presentation/home/psycho_test_result_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:psycho/provider/data_provider.dart';

class PsychoTestPageView extends ConsumerStatefulWidget {
  const PsychoTestPageView({required this.question, Key? key}) : super(key: key);
  final Question question;
  @override
  _PsychoTestPageViewState createState() => _PsychoTestPageViewState(question: question);
}

class _PsychoTestPageViewState extends ConsumerState<PsychoTestPageView> {
  // questionを初期化
  _PsychoTestPageViewState({required this.question});
  int selectedIndex = -1;
  final Question question;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Description View')),
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/backgroundimage_home.png'),
              fit: BoxFit.cover,
            ),
          ),
        child: Container(
        margin: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children:  [
            Text(
              question.title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              question.content.explanation,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            ListView.builder(
              shrinkWrap: true,
              itemCount: question.content.options.length,
              itemBuilder: (BuildContext context, int index) {
                return SelectButton(
                  text: question.content.options[index].text,
                  isSelected: selectedIndex == index,
                  onPressed: () {
                    setState(() {
                      selectedIndex = index;
                    });
                  },
                  );
              },
            ),
            ElevatedButton(onPressed: selectedIndex < 0 ? null : (){
              // 選択されたoptionならtrue,それ以外はfalse
              question.content.options.forEach((element) {
                if (element == question.content.options[selectedIndex]) {
                  element.isSelected = true;
                } else {
                  element.isSelected = false;
                }
              });
              ref.read(dataProvider.notifier).updateAnswered(question);

              Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => PsychoTestResultView(question: question)),
                          );
            },
            child: Text(AppLocalizations.of(context)!.showResult, style: const TextStyle(fontWeight: FontWeight.bold),)),
          ],
        ),
      ),
    ),
    );
  }
}

// class SelectButton extends StatefulWidget {
//   SelectButton({required this.text, Key? key}) : super(key: key);
//   final String text;
//   final bool isSelected = false;

//   @override
//   _SelectButtonState createState() => _SelectButtonState();
// }

// class _SelectButtonState extends State<SelectButton> {
//   bool isSelected = false;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 20),
//       child: ElevatedButton(
//         style: ElevatedButton.styleFrom(
//           shape: const StadiumBorder(),
//           backgroundColor: isSelected ? Colors.green : Colors.white,
//           side: BorderSide(
//             color: Colors.black,
//             width: isSelected ? 3 : 0,
//           ),
//         ),
//         onPressed: () {
//           setState(() {
//             isSelected = !isSelected;
//           });
//         },
//         child: Text(widget.text, style: TextStyle(color: Colors.black)),
//       ),
//     );
//   }
// }

class SelectButton extends StatelessWidget {
  SelectButton({required this.text, required this.isSelected, required this.onPressed, Key? key}) : super(key: key);
  final String text;
  final bool isSelected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 20),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: const StadiumBorder(),
          backgroundColor: Colors.white,
          side:BorderSide(
            color: Colors.black,
            width:  isSelected ? 3 : 0,
          ),
        ),
        onPressed: () {
          onPressed();
          // isSelected = true;
        },
        child: Text(text, style: TextStyle(color: Colors.black)),
      ),
    );
  }
}