
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:psycho/view/setting/privacy_policy_view.dart';
import 'package:psycho/view/setting/term_view.dart';
import 'package:psycho/view/setting/contact_form_view.dart';
import 'package:share_plus/share_plus.dart';
import 'package:psycho/provider/data_provider2.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum SettingViewType {
    contact,
    term,
    privacyPolicy,
    shareApp,
    evaluateApp,
    resetData,
}

class SettingView extends ConsumerWidget {

  Widget customAvatar(SettingViewType type) {
    IconData icon;
    switch (type){
      case SettingViewType.contact:
        icon = Icons.mail;
      case SettingViewType.term:
        icon = Icons.assignment_rounded;
      case SettingViewType.privacyPolicy:
        icon = Icons.privacy_tip_rounded;
      case SettingViewType.shareApp:
        icon = Icons.ios_share;
      case SettingViewType.evaluateApp:
        icon = Icons.thumb_up;
      case SettingViewType.resetData:
        icon = Icons.delete;
    }
    
    return CircleAvatar(
      backgroundColor: Colors.orange.shade400,
      child: Icon(icon, color: Colors.white,));
  }
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
            leading: customAvatar(SettingViewType.contact),
            title: Text(AppLocalizations.of(context)!.contact),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ContactFormView()));
            },
          ),
          const Divider(height: 0,),
          ListTile(
            leading:customAvatar(SettingViewType.term),
            title: Text(AppLocalizations.of(context)!.termOfUsage),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => TermView()));
            },
          ),
          const Divider(height: 0,),
          ListTile(
            leading: customAvatar(SettingViewType.privacyPolicy),
            title: Text(AppLocalizations.of(context)!.privacyPolicy),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => PrivacyPolicyView()));
            },
          ),
          const Divider(height: 0,),
          ListTile(
            leading: customAvatar(SettingViewType.shareApp),
            title: Text(AppLocalizations.of(context)!.shareApp),
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
                        subject: AppLocalizations.of(context)!.qrCode
                      );
                    },
                    child: Text(AppLocalizations.of(context)!.qrCode),
                  ),
                ],
                cancelButton: CupertinoActionSheetAction(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(AppLocalizations.of(context)!.cancel),
                ),
              ),
              );
            },
          ),
          Divider(height: 0,),
          ListTile(
            leading: customAvatar(SettingViewType.evaluateApp),
            title: Text(AppLocalizations.of(context)!.evaluateApp),
            onTap: () {
              // TODO: not yet implemented
              Navigator.pushNamed(context, '/account');
            },
          ),
          Divider(height: 0,),
          ListTile(
            leading: customAvatar(SettingViewType.resetData),
            title: Text(AppLocalizations.of(context)!.resetDataTitle),
            onTap: () {
              showDialog(
                context: context, 
                builder: (_){
                  return CupertinoAlertDialog(
                    title: Text(AppLocalizations.of(context)!.resetData, style: const TextStyle(color: Colors.red),),
                    content: Text(AppLocalizations.of(context)!.resetDataWarning),
                    actions: [
                      CupertinoDialogAction(
                        textStyle: const TextStyle(color: Colors.black),
                        child: Text(AppLocalizations.of(context)!.cancel),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      CupertinoDialogAction(
                        textStyle: const TextStyle(color: Colors.red),
                        child: Text(AppLocalizations.of(context)!.reset),
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
                          ref.invalidate(data2Provider);
                          ref.invalidate(currentQuestionProvider);
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