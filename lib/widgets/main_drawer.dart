import 'package:flutter/material.dart';

class MainDrawer extends StatelessWidget {
  Widget _buildListTile(String title, IconData icon, Function onTab) {
    return ListTile(
      leading: Icon(
        icon,
        size: 36,
      ),
      title: Text(
        title,
        style: TextStyle(
            fontFamily: 'RobotoCondensed',
            fontSize: 24,
            fontWeight: FontWeight.bold),
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
          _buildListTile('Profile', Icons.person, () {}),
          _buildListTile('Projects', Icons.category, () {}),
          _buildListTile('Smartroom', Icons.home, () {}),
          _buildListTile('Smartlab', Icons.handyman, () {}),
        ],
      ),
    );
  }
}
