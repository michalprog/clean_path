import 'package:clean_path/providers/account_provider.dart';
import 'package:clean_path/widgets/main_addictions_widgets/active_navigation_icon.dart';
import 'package:clean_path/widgets/user_widgets/account_bottom_sheet.dart';
import 'package:clean_path/window_widgets/main_additcion_views/alk_view.dart';
import 'package:clean_path/window_widgets/main_additcion_views/default_view.dart';
import 'package:clean_path/window_widgets/main_additcion_views/fap_view.dart';
import 'package:clean_path/window_widgets/main_additcion_views/pap_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:clean_path/main/drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'main_view.dart';

import '/data_types/record.dart';
import '/enums/enums.dart';
import '/l10n/app_localizations.dart';
import '/providers/database_provider.dart';

class MainWindow extends StatefulWidget {
  const MainWindow({super.key});

  @override
  State<MainWindow> createState() => _MainWindowState();
}

class _MainWindowState extends State<MainWindow> {
  List<Widget> show_view = [];
  int navigationIndex = 4;

  @override
  void initState() {
    super.initState();
    show_view = [FapView(), PapView(), AlkView(), DefaultView(), MainView()];
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDailyWelcome();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        centerTitle: true,
        title: Text(l10n.appTitle),
        backgroundColor: Colors.greenAccent,
        actions: [
          IconButton(
            onPressed: () => showAccountBottomSheet(context),
            icon: Icon(Icons.account_circle_outlined, size: 35),
          ),
        ],
      ),
      drawer: DrawerWidget(index: navigationIndex),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () => changeWindow(4),
        backgroundColor: Colors.purple.shade100,
        shape: CircleBorder(),
        elevation: 5,
        child: const Icon(Icons.home, color: Colors.purple),
      ),
      body: show_view[navigationIndex],
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        color: Colors.purple.shade50,
        elevation: 5,
        child: FutureBuilder<List<Record>>(
          future: context.read<DatabaseProvider>().getActiveRecords(),
          builder: (context, snapshot) {
            final activeTypes = snapshot.data
                ?.where((record) => record.isActive)
                .map((record) => record.type)
                .toSet() ??
                <AddictionTypes>{};
            return Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ActiveNavigationIcon(
                  onPressed: () => changeWindow(0),
                  icon: const FaIcon(FontAwesomeIcons.marsAndVenus),
                  isActive: activeTypes.contains(AddictionTypes.fap),
                ),
                ActiveNavigationIcon(
                  onPressed: () => changeWindow(1),
                  icon: const Icon(Icons.smoking_rooms),
                  isActive: activeTypes.contains(AddictionTypes.smoking),
                ),
                const SizedBox(width: 40),
                ActiveNavigationIcon(
                  onPressed: () => changeWindow(2),
                  icon: const Icon(Icons.liquor),
                  isActive: activeTypes.contains(AddictionTypes.alcochol),
                ),
                ActiveNavigationIcon(
                  onPressed: () => changeWindow(3),
                  icon: const Icon(Icons.question_mark),
                  isActive: activeTypes.contains(AddictionTypes.sweets),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void changeWindow(int page) {
    setState(() {
      navigationIndex = page;
    });
  }
  Future<void> showDailyWelcome() async {
    if (!mounted) return;

    final accountProvider = context.read<AccountProvider>();
    if (!accountProvider.shouldShowDailyWelcome) {
      return;
    }

    accountProvider.consumeDailyWelcomeFlag();

    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Witamy!'),
          content: const Text('Miło Cię widzieć dzisiaj 👋'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void showAccountBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return const AccountBottomSheet();
      },
    );
  }
}

