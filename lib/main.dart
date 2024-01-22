import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:psycho/view/home_view.dart';
import 'package:psycho/view/setting_view.dart';
import 'package:psycho/provider/tab_provider.dart' show tabProvider, TabType;

void main() {
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.orange,
        primarySwatch: Colors.orange,
      ),
      home: DefaultTabController(length: pages.length, child: TabBarViews(), initialIndex: 0)
    );
  }
}
final pages = [HomeView(), HomeView2(), SettingView()];
class TabBarViews extends ConsumerWidget {
  TabBarViews({super.key});
  

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tab = ref.watch(tabProvider);
    return Scaffold(
      body: pages[tab.index],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.abc_outlined), label: 'History'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Setting'),
          ],
          currentIndex: tab.index,
          onTap: (index) {
            ref.read(tabProvider.notifier).switchTab(TabType.values[index]);
          },
      ),
    );
  }
}
