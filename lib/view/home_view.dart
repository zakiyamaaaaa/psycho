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

  
  @override
  Widget build(BuildContext context) {
    final data = ref.watch(dataProvider);
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/backgroundimage_home.png'),
              fit: BoxFit.cover,
            ),
          ),
          padding :const EdgeInsets.all(20),
          width: double.infinity,
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
                    Text('あなたの最近のテスト結果', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                    Text('恋愛モード1', style: TextStyle(color: Colors.white, ),),
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
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        'ヘッダー',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
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
                  color: Colors.white,
                  
                ),
                child: Column(
                  children: [
                    
                    // Container(
                    //   width: double.infinity,
                    //   margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    //   height: 100,
                    //   decoration: BoxDecoration(
                    //     border: Border.all(color: Colors.white),
                    //     borderRadius: BorderRadius.circular(10),
                    //     // color: Colors.grey[1],
                    //   ),
                    //   child: ElevatedButton(
                    //     onPressed: () {  },
                    //     style: ElevatedButton.styleFrom(
                    //       elevation: 5,
                    //       shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(10),
                            
                    //       ),
                    //       backgroundColor: Colors.grey[200],
                    //     ),
                    //     child: 
                    //       Row(
                    //         children: [
                    //           Expanded(
                    //             child: Column(
                    //               mainAxisAlignment: MainAxisAlignment.center,
                    //               crossAxisAlignment: CrossAxisAlignment.start,
                    //               children: [
                    //                 Text(data[0].title, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
                    //                 Text('#性格診断', style: TextStyle(color: Colors.black, ),),
                    //               ],
                    //             ),
                    //           ),
                    //           Icon(Icons.arrow_forward_ios, color: Colors.black,),
                    //         ],
                    //       ),
                    //     ),
                    // ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return PsychoTestContainer(question: data[index],);
                      },
                    ),
                  ],
                ),
              ),
            ],
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

class PsychoTestContainer extends StatelessWidget {
  const PsychoTestContainer({required this.question, Key? key}) : super(key: key);
  final Question question;

  @override
  Widget build(BuildContext context) {
    return Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      height: 100,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(10),
                        // color: Colors.grey[1],
                      ),
                      child: ElevatedButton(
                        onPressed: () {  
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => DescriptionView(question: question)),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            
                          ),
                          backgroundColor: Colors.grey[200],
                        ),
                        child: 
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(question.title, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
                                    Text(question.category.name, style: TextStyle(color: Colors.black, ),),
                                  ],
                                ),
                              ),
                              Icon(Icons.arrow_forward_ios, color: Colors.black,),
                            ],
                          ),
                        ),
                    );
  }
}

class $ {
}