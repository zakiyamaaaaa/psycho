import 'package:flutter/material.dart';
import 'package:psycho/domains/model/question.dart';

import 'package:psycho/presentation/home/psycho_test_page_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:psycho/provider/data_provider.dart';

class DescriptionView extends ConsumerStatefulWidget {
  const DescriptionView({required this.question, Key? key}) : super(key: key);
  final Question question;

  @override
  _DescriptionViewState createState() => _DescriptionViewState(question: question);
}

class _DescriptionViewState extends ConsumerState<DescriptionView> {
  _DescriptionViewState({required this.question});
  
  final Question question;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                ref.read(dataProvider.notifier).updateFavorite(question);
              });
            },
            icon: Icon(
              size: 30,
                        question.isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: Colors.pink[200],
                      ),
          ),
        ],
      ),
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
            child: Text(AppLocalizations.of(context)!.play, style: const TextStyle(color: Colors.black87),)),
          ],
      ),
        ),
    ),
    );
  }
}