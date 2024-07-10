import 'package:findovio_business/main.dart';
import 'package:findovio_business/screens/chat/chat_list_screen.dart';
import 'package:findovio_business/screens/main_menu/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import '../schedule/calendar_view_screen.dart';
import '../settings/settings_screen.dart';
import '../wallet/wallet_screen.dart';

class MinimalExample extends StatefulWidget {
  MinimalExample({Key? key}) : super(key: minimalExampleKey);
  @override
  State<MinimalExample> createState() => MinimalExampleState();
}

class MinimalExampleState extends State<MinimalExample> {
  final PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);
  @override
  void initState() {
    super.initState();
  }

  List<PersistentTabConfig> _tabs() => [
        PersistentTabConfig(
          screen: const MainScreen(),
          item: ItemConfig(
            icon: Icon(MdiIcons.home),
            title: "Salon",
          ),
        ),
        PersistentTabConfig(
          screen: CalendarViewScreen(
            isFullScreen: false,
          ),
          item: ItemConfig(
            icon: Icon(MdiIcons.calendar),
            title: "Kalendarz",
          ),
        ),
        PersistentTabConfig(
          screen: const WalletScreen(),
          item: ItemConfig(
            icon: Icon(MdiIcons.wallet),
            title: "Portfel",
          ),
        ),
        PersistentTabConfig(
          screen: const ChatListScreen(),
          item: ItemConfig(
            icon: const Icon(Icons.chat),
            title: "Wiadomości",
          ),
        ),
        PersistentTabConfig(
          screen: const SettingsScreen(),
          item: ItemConfig(
            icon: const Icon(Icons.settings),
            title: "Ustawienia",
          ),
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      controller: _controller,
      tabs: _tabs(),
      navBarBuilder: (navBarConfig) => Style2BottomNavBar(
        navBarConfig: navBarConfig,
        navBarDecoration: const NavBarDecoration(),
      ),
    );
  }

  void changeTab(int index) {
    _controller.jumpToTab(index);
  }
}
