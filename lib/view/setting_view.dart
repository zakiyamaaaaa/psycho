
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:psycho/view/setting/privacy_policy_view.dart';
import 'package:psycho/view/setting/term_view.dart';
import 'package:psycho/view/setting/contact_form_view.dart';
import 'package:share_plus/share_plus.dart';

import 'package:psycho/provider/data_provider2.dart';

class SettingView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Container(
        margin: const EdgeInsets.all(20),
        // height: double.,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          ListTile(
            leading: CircleAvatar(child: Icon(Icons.star)),
            title: Text('アップグレードする'),
            onTap: () {
              Navigator.pushNamed(context, '/account');
            },
          ),
          const Divider(height: 0,),
          ListTile(
            leading: CircleAvatar(child: Icon(Icons.mail)),
            title: Text('問い合わせ'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ContactFormView()));
            },
          ),
          const Divider(height: 0,),
          ListTile(
            leading: CircleAvatar(child: Icon(Icons.assignment_rounded)),
            title: Text('利用規約'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => TermView()));
            },
          ),
          const Divider(height: 0,),
          ListTile(
            leading: const CircleAvatar(child: Icon(Icons.privacy_tip_rounded)),
            title: Text('プライバシーポリシー'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => PrivacyPolicyView()));
            },
          ),
          const Divider(height: 0,),
          ListTile(
            leading: const CircleAvatar(child: Icon(Icons.ios_share)),
            title: Text('アプリを共有する'),
            onTap: () {
              // Share.share('hogehoge');
              showCupertinoModalPopup(
                context: context, 
                builder: (BuildContext context) =>
              CupertinoActionSheet(
                actions: [
                  CupertinoActionSheetAction(
                    onPressed: () async {
                      Share.share('URL: hogehoge');
                      // Share.share('hogehoge');
                    },
                    child: const Text('テキスト'),
                  ),
                  CupertinoActionSheetAction(
                    onPressed: () async {
                      final image = await rootBundle.load('images/qrcode.png');
                      final buffer = image.buffer;
                      Share.shareXFiles(
                        [
                        XFile.fromData(buffer.asUint8List(image.offsetInBytes, image.lengthInBytes), name: 'photo.png', mimeType: 'image/png')
                        ],
                        subject: 'QRコード'
                      );
                    },
                    child: const Text('QRコード'),
                  ),
                ],
                cancelButton: CupertinoActionSheetAction(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('キャンセル'),
                ),
              ),
              );
            },
          ),
          Divider(height: 0,),
          ListTile(
            leading: CircleAvatar(child: Icon(Icons.thumb_up)),
            title: Text('アプリを評価する'),
            onTap: () {
              Navigator.pushNamed(context, '/account');
            },
          ),
          Divider(height: 0,),
          ListTile(
            leading: CircleAvatar(child: Icon(Icons.delete)),
            title: Text('データをリセットする'),
            onTap: () {
              showDialog(
                context: context, 
                builder: (_){
                  return CupertinoAlertDialog(
                    title: Text('データをリセットしますか？'),
                    content: Text('データをリセットすると、お気に入りや診断結果が削除されます。'),
                    actions: [
                      CupertinoDialogAction(
                        child: Text('キャンセル'),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      CupertinoDialogAction(
                        child: Text('リセット'),
                        onPressed: () async {
                          // 処理が終わるまでローディングビューを表示
                          showDialog(
                            context: context, 
                            builder: (_){
                              return const Center(child: CircularProgressIndicator(),);
                            },
                          );
                          await ref.read(data2Provider.notifier).removeAll();
                          await Future.delayed(Duration(seconds: 1), () async {
                            await ref.read(data2Provider.notifier).save();
                            debugPrint("save in setting_view");
                          });
                          ref.refresh(data2Provider);
                          await Future.delayed(Duration(seconds: 1), () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          });
                        },
                      ),
                    ],
                  );
                });
            },
          ),
        ],
      ),
      ),
      ),
    );
  }
}