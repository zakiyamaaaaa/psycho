import 'package:flutter/material.dart';
import 'package:psycho/model/question.dart';

import 'package:psycho/view/psycho_test_page_view.dart';

class DescriptionView extends StatelessWidget {
  const DescriptionView({required this.question, Key? key}) : super(key: key);

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
        child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:  [
            Text(
              question.title,
              style: TextStyle(fontSize: 40),
            ),
            Text(
              question.description,
              style: TextStyle(fontSize: 20),
            ),
            ElevatedButton(onPressed: (){
              Navigator.push(context, 
              MaterialPageRoute(
                builder: (context) => PsychoTestPageView(question: question),
                fullscreenDialog: true,
              )
              );
            },
            child: Text('テストする')),
          ],
        ),
      ),
    ),
    );
  }
}