import 'package:doku_maker/provider/auth_provider.dart';
import 'package:doku_maker/screens/room/room_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainDrawer extends StatelessWidget {
  Widget _buildListTile(String title, IconData icon, Function onTab,
      [TextStyle style]) {
    return ListTile(
      leading: Icon(
        icon,
        size: 36,
      ),
      title: Text(
        title,
        style: style == null
            ? TextStyle(
                fontFamily: 'RobotoCondensed',
                fontSize: 24,
                fontWeight: FontWeight.bold,
              )
            : style,
      ),
      onTap: onTab,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 80,
          ),
          _buildListTile(
              Provider.of<AuthProvider>(context, listen: false).userId,
              Icons.person,
              null,
              TextStyle(
                fontSize: 16,
              )),
          Divider(
            thickness: 2,
          ),
          _buildListTile(
            'Projects',
            Icons.dashboard,
            () => Navigator.of(context).pushReplacementNamed('/'),
          ),
          _buildListTile(
            'Smartarea Logbook',
            Icons.book,
            () => Navigator.of(context)
                .pushReplacementNamed(RoomDetailScreen.routeName),
          ),
          Spacer(),
          ListTile(
              title: Text(
                'Logout',
                style: TextStyle(fontSize: 26),
              ),
              onTap: () {
                Provider.of<AuthProvider>(context, listen: false).logout();
                Navigator.of(context).pushReplacementNamed("/");
              })
        ],
      ),
    );
  }
}
