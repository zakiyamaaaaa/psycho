import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:psycho/presentation/home/home_view.dart';
import 'package:psycho/presentation/history/history_view.dart';
import 'package:psycho/provider/data_provider.dart';
import 'package:psycho/presentation/setting/setting_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:psycho/domains/model/shared_preferences_manager.dart';
import 'package:psycho/domains/model/user_repository.dart';
import 'package:psycho/provider/tab_provider.dart' show tabProvider, TabType;
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SharedPreferencesManager.isFirstLaunch().then((value) {
    switch (value) {
      case true:
        break;
      case false:
      // Userデータの作成
      final userRepo = UserRepository(ref);
      () async {
        await userRepo.create();
      }();
        SharedPreferencesManager.writeFirstLaunch();
        break;
    }
  });
    return MaterialApp(
      theme: ThemeData(
        dialogTheme: const DialogTheme(
          backgroundColor: Colors.white,
          titleTextStyle: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
          contentTextStyle: TextStyle(color: Colors.black, fontSize: 16),
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
final pages = [HomeView(), HistoryView(), SettingView()];
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
              ref.invalidate(dataProvider);
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
