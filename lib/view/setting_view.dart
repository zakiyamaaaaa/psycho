
import 'package:flutter/material.dart';

class SettingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Setting'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: CircleAvatar(child: Icon(Icons.star)),
            title: Text('アップグレードする'),
            onTap: () {
              Navigator.pushNamed(context, '/account');
            },
          ),
          Divider(height: 0,),
          ListTile(
            leading: CircleAvatar(child: Icon(Icons.mail)),
            title: Text('問い合わせ'),
            onTap: () {
              Navigator.pushNamed(context, '/account');
            },
          ),
          Divider(height: 0,),
          ListTile(
            leading: CircleAvatar(child: Icon(Icons.assignment_rounded)),
            title: Text('利用規約'),
            onTap: () {
              Navigator.pushNamed(context, '/account');
            },
          ),
          Divider(height: 0,),
          ListTile(
            leading: CircleAvatar(child: Icon(Icons.privacy_tip_rounded)),
            title: Text('プライバシーポリシー'),
            onTap: () {
              Navigator.pushNamed(context, '/account');
            },
          ),
          Divider(height: 0,),
          ListTile(
            leading: CircleAvatar(child: Icon(Icons.ios_share)),
            title: Text('アプリを共有する'),
            onTap: () {
              Navigator.pushNamed(context, '/account');
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
            title: Text('データを削除する'),
            onTap: () {
              Navigator.pushNamed(context, '/account');
            },
          ),
        ],
      ),
    );
  }
}