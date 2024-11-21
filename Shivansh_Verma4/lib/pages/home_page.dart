import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:shivansh_verma4/pages/projects_page.dart';
import 'package:shivansh_verma4/pages/skill_page.dart';
import 'package:shivansh_verma4/pages/welcome_page.dart';
import 'package:shivansh_verma4/widgets/drawer_widget.dart';
import '../utils/globals.dart';
import '../widgets/top_bar_contents.dart';
import 'about_page.dart';
import 'education_page.dart';
import 'footer_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Widget> pages= [
    WelcomePage(),
    AboutPage(),
    ProjectsPage(),
    EducationPage(),
    SkillPage(),
    FooterPage()
  ];
  final itemScrollController=ItemScrollController();
  final pageController = PageController(initialPage: 0);
  final itemPositionListener= ItemPositionsListener.create();
  @override
  void dispose(){
    pageController.dispose();
    super.dispose();
  }
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
      endDrawer: DrawerWidget(itemController: itemScrollController),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/back.jpeg'),
            fit: BoxFit.cover
          )
        ),
        child: ScrollablePositionedList.builder(
          initialScrollIndex: 0,
            shrinkWrap: true,
            itemPositionsListener: itemPositionListener,
            itemScrollController: itemScrollController,
            itemCount: pages.length,
            itemBuilder: (context,index){
              final page= pages[index];
              return page;
            }),
      ),
    );
  }
}