import 'package:flutter/material.dart';
import 'package:pet_adoption/utils/themes.dart';
import 'package:pet_adoption/view_models/descriptionViewModel.dart';
import 'package:pet_adoption/view_models/homeViewModel.dart';
import 'package:pet_adoption/views/SplashScreen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  Brightness? _brightness;
  @override
  void didChangePlatformBrightness() {
    if (mounted) {
      setState(() {
        _brightness = WidgetsBinding.instance?.window.platformBrightness;
      });
    }
    super.didChangePlatformBrightness();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    _brightness = WidgetsBinding.instance.window.platformBrightness;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
        ChangeNotifierProvider(create: (_) => DescriptionViewModel()),
      ],
      child: MaterialApp(
        title: 'Pet Adopt',
        theme: MyThemes.lightTheme(context),
        darkTheme: MyThemes.darkTheme(context),
        debugShowCheckedModeBanner: false,
        routes: {
          "/": (context) => const SplashScreen(),
        },
      ),
    );
  }
}
