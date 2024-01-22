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
        height:double.infinity,
        decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/backgroundimage_home.png'),
              fit: BoxFit.cover,
            ),
          ),
        
        child: SingleChildScrollView(
          child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children:  [
            Container(
              child: Image.asset(question.imagePath),
            ),
            Container(
              margin: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    question.title,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.visible,
                  ),
                  Text(
                    question.description,
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
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