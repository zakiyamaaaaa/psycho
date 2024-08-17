import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:psycho/presentation/home/home_view.dart';
import 'package:psycho/presentation/history/history_view.dart';
import 'package:psycho/provider/data_provider.dart';
import 'package:psycho/presentation/setting/setting_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:psycho/main_viewmodel.dart';
import 'package:psycho/provider/tab_provider.dart' show tabProvider, TabType;
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

final _pages = [const HomeView(), const HistoryView(), SettingView()];
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  OneSignal.initialize("98879576-dfb1-444f-bf15-444f5eb3c961");

  OneSignal.Notifications.requestPermission(true);
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    MainViewModel(ref).checkFirstLaunch();
    return MaterialApp(
        theme: ThemeData(
            dialogTheme: const DialogTheme(
              backgroundColor: Colors.white,
              titleTextStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
              contentTextStyle: TextStyle(color: Colors.black, fontSize: 16),
            ),
            iconTheme: const IconThemeData(color: Colors.white),
            colorScheme: ColorScheme.fromSwatch(
              backgroundColor: Colors.white,
              primarySwatch: Colors.orange,
            )),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: DefaultTabController(
            length: _pages.length, initialIndex: 0, child: _TabBarViews()));
  }
}

class _TabBarViews extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tab = ref.watch(tabProvider);
    return Scaffold(
      body: IndexedStack(
        index: tab.index,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.orange,
        items: [
          BottomNavigationBarItem(
              icon: const Icon(Icons.home),
              label: AppLocalizations.of(context)!.home),
          BottomNavigationBarItem(
              icon: const Icon(Icons.auto_awesome),
              label: AppLocalizations.of(context)!.history),
          BottomNavigationBarItem(
              icon: const Icon(Icons.settings),
              label: AppLocalizations.of(context)!.setting),
        ],
        currentIndex: tab.index,
        onTap: (index) {
          if (index == TabType.home.index) {
            // ref.invalidate(dataProvider);
            // _pages.first;
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
