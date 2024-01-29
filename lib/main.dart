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
      theme: ThemeData(
        dialogTheme: DialogTheme(
          backgroundColor: Colors.white,
          titleTextStyle: const TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
          contentTextStyle: const TextStyle(color: Colors.black, fontSize: 16),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        colorScheme: ColorScheme.fromSwatch(
          backgroundColor: Colors.white,
          primarySwatch: Colors.orange,
        )
      ),
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
        items: [
          BottomNavigationBarItem(icon: const Icon(Icons.home), label: AppLocalizations.of(context)!.home),
          BottomNavigationBarItem(icon: const Icon(Icons.auto_awesome), label: AppLocalizations.of(context)!.history),
          BottomNavigationBarItem(icon: const Icon(Icons.settings), label: AppLocalizations.of(context)!.setting),
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
