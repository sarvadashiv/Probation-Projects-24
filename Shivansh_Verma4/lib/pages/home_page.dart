import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../utils/globals.dart';
import '../widgets/top_bar_contents.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final itemScrollController=ItemScrollController();
  final pageController = PageController(initialPage: 0);
  final itemPositionListener= ItemPositionsListener.create();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: Globals.scaffoldKey,
      appBar: PreferredSize(
          preferredSize: const Size(100,100),
          child: TopBarContents(
            opacity: 0,
            itemsScrollController: itemScrollController,
          ),
      ),
    );
  }
}