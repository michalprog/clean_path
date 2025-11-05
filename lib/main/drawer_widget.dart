import 'package:flutter/material.dart';

import '/statistc_views/main_Statistic.dart';
import '/window_widgets/acievement_view.dart';

class DrawerWidget extends StatelessWidget {
  final int index;
  const DrawerWidget({super.key, required this.index,});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xFF3B5E3B), // ciemnozielony/oliwkowy
            ),
            child: Text(
              'Options',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ListTile(
            leading: Icon(Icons.show_chart),
            title: Text('Statistics'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MainStatistic(index: index,)),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.forum),
            title: Text('Forum'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.emoji_events),
            title: Text('Achievements'),
            onTap:  () {
    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => AchievementView()),
    );
    },
          ),
        ],
      ),
    );
  }

}
