import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:psycho/model/question.dart';

import 'package:psycho/provider/data_provider.dart';
import 'package:psycho/view/description_view.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  bool _isToggle = false;
  
  @override
  Widget build(BuildContext context) {
    final data = ref.watch(dataProvider);
    final current = ref.read(dataProvider.notifier).getCurrentQuestion();
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/backgroundimage_home.png'),
              fit: BoxFit.cover,
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
          // padding :const EdgeInsets.all(20),
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                height: 80,
                child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    
                  ),
                  backgroundColor: Colors.orange
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeView2()),
                  );
                },

                child: Column(
                  // 左寄せ
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  
                  children: [
                    // 白いテキスト
                    Text(current != null ? 'あなたの最近のテスト結果': "テストを受けよう！", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                    Text(current != null ? current.content.options.firstWhere((element) => element.isSelected == true).answer1 : "", style: TextStyle(color: Colors.white, ),),
                  ],
                ),
                ),
              ),
              Container(
                width: double.infinity,
                height: 80,
                margin: const EdgeInsets.only(top: 20),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                  color: Colors.orange[700],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                          const Spacer(),
                          Text("ヘッダー"),
                          const Spacer(),
                          Text("診断済みを除外"),
                          CupertinoSwitch(value: _isToggle, onChanged: (value) => setState(() {
                            _isToggle = value;
                            ref.read(dataProvider.notifier).getQuestions();
                          })),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                  color: Colors.white.withOpacity(0.6),
                ),
                child: Column(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return PsychoTestContainer(question: data[index], isDoneFlag: _isToggle,);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }
}

class HomeView2 extends ConsumerStatefulWidget {
  const HomeView2({Key? key}) : super(key: key);

  @override
  _HomeViewState2 createState() => _HomeViewState2();
}

class _HomeViewState2 extends ConsumerState<HomeView2> {

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomeView2'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'HomeView2',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
    );
  }
}

class PsychoTestContainer extends ConsumerWidget {
  const PsychoTestContainer({required this.question, this.isDoneFlag = false, Key? key}) : super(key: key);
  final Question question;
  final bool isDoneFlag;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return (isDoneFlag && question.isAnswered) ? Container() : Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              // width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[1],
              ),
              
              child: Stack(
                children: [
                  ElevatedButton( onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DescriptionView(question: question)),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(0),
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: Colors.grey[100],
                    ),
                  child:
                  Column(
                    children: [
                        Container(
                      height: 150,
                      width: double.infinity,
                      child: Image.asset(
                        question.imagePath,
                        colorBlendMode: BlendMode.overlay,
                        fit: BoxFit.fitWidth,),
                      ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(question.title, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
                              Container(
                                margin: const EdgeInsets.only(bottom: 5),
                                child: Text("#${question.category.name}", style: TextStyle(color: Colors.black, ),),
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.arrow_forward_ios, color: Colors.black,),
                      ],
                    ),
                    ),
                    ],
                    ),
                  ),
                  Positioned.fill(
                  child: IgnorePointer(
                    ignoring: true,
                    child: question.isAnswered ? Container(
                      // width: double.infinity,
                      height: 150,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ) : Container(),
                  ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: IconButton(
                      onPressed: (){
                        ref.read(dataProvider.notifier).updateFavorite(question);
                      },
                      icon: Icon(
                        question.isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: Colors.pink[200],
                      ),
                    ),
                  ),
                  // 三角形のコンテナ

                  question.isAnswered ? Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const Text(
                        '診断済み',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ) : Container(),
                ],
              ),
            );
  }
}