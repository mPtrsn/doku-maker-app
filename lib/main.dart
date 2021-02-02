import 'dart:io';

import 'package:doku_maker/provider/auth_provider.dart';
import 'package:doku_maker/provider/projects_provider.dart';
import 'package:doku_maker/provider/room_provider.dart';
import 'package:doku_maker/screens/auth_screen.dart';
import 'package:doku_maker/screens/project/new_project_screen.dart';
import 'package:doku_maker/screens/project/project_settings_screen.dart';
import 'package:doku_maker/screens/room/room_detail_screen.dart';
import 'package:doku_maker/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/project/project_detail_screen.dart';
import 'screens/project/projects_overview_screen.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  HttpOverrides.global = new MyHttpOverrides();
  runApp(new MyApp());
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
        ),
        ChangeNotifierProxyProvider<AuthProvider, RoomProvider>(
          create: (BuildContext context) => RoomProvider(null),
          update: (context, value, previous) =>
              RoomProvider(previous.smartarea),
        )
      ],
      child: Consumer<AuthProvider>(
        builder: (context, auth, child) => MaterialApp(
          title: 'Doku Maker',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blueGrey,
            accentColor: Colors.amber,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: auth.isAuth
              ? ProjectsOverviewScreen()
              : FutureBuilder(
                  future: auth.tryLogin(),
                  builder: (context, snapshot) =>
                      snapshot.connectionState == ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                ),
          routes: {
            ProjectDetailScreen.routeName: (ctx) => ProjectDetailScreen(),
            NewProjectScreen.routeName: (ctx) => NewProjectScreen(),
            ProjectSettingsScreen.routeName: (ctx) => ProjectSettingsScreen(),
            RoomDetailScreen.routeName: (ctx) => RoomDetailScreen(),
          },
        ),
      ),
    );
  }
}
