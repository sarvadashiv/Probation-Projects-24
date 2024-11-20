import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shivansh_verma4/utils/constants.dart';
import 'pages/home_page.dart';
import 'package:responsive_framework/responsive_framework.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: name,
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: Theme.of(context).copyWith(
        platform: TargetPlatform.android,
        scaffoldBackgroundColor: backgroundColor,
        primaryColor: primaryColor,
        canvasColor: backgroundColor,
        textTheme: GoogleFonts.latoTextTheme(),
      ),
      builder: (context, widget) => ResponsiveWrapper.builder(
        BouncingScrollWrapper.builder(context, widget!),
        defaultScale:true,
        breakpoints:[
          const ResponsiveBreakpoint.resize(450, name: MOBILE),
          const ResponsiveBreakpoint.resize(450, name: TABLET),
          const ResponsiveBreakpoint.resize(450, name: DESKTOP),
        ]
      ),
      home: HomePage(),
    );
  }
}