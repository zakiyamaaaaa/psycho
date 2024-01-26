import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:psycho/view/home_view.dart';
import 'package:psycho/view/home_view2.dart';
import 'package:psycho/view/history_view.dart';
import 'package:psycho/view/history_view2.dart';
import 'package:psycho/provider/data_provider2.dart';
import 'package:psycho/view/setting_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:psycho/provider/tab_provider.dart' show tabProvider, TabType;
void main() {
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: DefaultTabController(length: pages.length, child: TabBarViews(), initialIndex: 0)
    );
  }
}
final pages = [HomeView2(), HistoryView2(), SettingView()];
class TabBarViews extends ConsumerWidget {
  const TabBarViews({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tab = ref.watch(tabProvider);
    return Scaffold(
      body: IndexedStack(
        index: tab.index,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.orange,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.abc_outlined), label: 'History'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Setting'),
          ],
          currentIndex: tab.index,
          onTap: (index) {
            if (index == TabType.home.index) {
              ref.invalidate(data2Provider);
            } else if (index == TabType.history.index) {
              ref.invalidate(answeredQuestionsProvider);
              ref.invalidate(favoriteQuestionsProvider);
            }
            ref.read(tabProvider.notifier).switchTab(TabType.values[index]);
          },
      ),
    );
  }
}
