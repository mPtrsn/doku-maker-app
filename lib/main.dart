import 'package:flutter/material.dart';

import './screens/project_detail_screen.dart';
import './screens/projects_overview_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        accentColor: Colors.amber,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (ctx) => ProjectsOverviewScreen(),
        ProjectDetailScreen.routeName: (ctx) => ProjectDetailScreen(),
      },
    );
  }
}
