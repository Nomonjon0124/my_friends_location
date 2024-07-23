import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_friends_location/presentation/pages/friends_screen/friends_screen.dart';
import 'package:my_friends_location/presentation/pages/register_screen/register_screen.dart';
import 'package:my_friends_location/util/theme.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import 'data/local/shared_pref_helper.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AndroidYandexMap.useAndroidViewSurface = false;
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await SharedPrefHelper.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: lightMode/*ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      )*/,
      darkTheme: darkMode,
      home: FriendsScreen()/*(!SharedPrefHelper.isLoggedIn())? const RegisterScreen():const FriendsScreen()*/,

    );
  }
}
