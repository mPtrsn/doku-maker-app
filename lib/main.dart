import 'package:doku_maker/provider/auth_provider.dart';
import 'package:doku_maker/provider/projects_provider.dart';
import 'package:doku_maker/screens/new_project_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/project_detail_screen.dart';
import './screens/projects_overview_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: AuthProvider()),
        ChangeNotifierProxyProvider<AuthProvider, ProjectsProvider>(
          create: (BuildContext context) => ProjectsProvider('', []),
          update: (context, value, previous) =>
              ProjectsProvider(value.userId, previous.projects),
        )
      ],
      child: Consumer<AuthProvider>(
        builder: (context, value, child) => MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blueGrey,
            accentColor: Colors.amber,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          initialRoute: '/',
          routes: {
            '/': (ctx) => ProjectsOverviewScreen(),
            ProjectDetailScreen.routeName: (ctx) => ProjectDetailScreen(),
            NewProjectScreen.routeName: (ctx) => NewProjectScreen(),
          },
        ),
      ),
    );
  }
}
