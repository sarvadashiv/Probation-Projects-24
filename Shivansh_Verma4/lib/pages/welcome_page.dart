import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shivansh_verma4/utils/constants.dart';

import '../utils/screen_helper.dart';
class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  List<MaterialColor> colorizeColors=[
    Colors.brown,Colors.purple,Colors.amber,Colors.cyan
  ];
  @override
  Widget build(BuildContext context) =>ScreenHelper(
      desktop: _buildUi(desktopMaxWidth),
      tablet : _buildUi(tabletMaxWidth),
      mobile: _buildUi(ScreenHelper.mobileMaxWidth(context))
    );
    _buildUi(double width)=> Container(
      height: MediaQuery.of(context).size.height,
      child: Center(
        child: LayoutBuilder(
            builder: (context, constraints){
              return ResponsiveWrapper(
                maxWidth: width,
                  minWidth: width,
                  child: Flex(
                      direction: ScreenHelper.isMobile(context)? Axis.vertical: Axis.horizontal,
                    children: [
                      Expanded(
                          flex: ScreenHelper.isMobile(context)? 0:3,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(height: 24),
                              const Text(
                                helloTag,
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w100,
                                  color: Colors.white
                                ),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                name,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 50,
                                  color: Colors.white
                              ),
                              ),
                              SizedBox(
                                  height: 60,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      const Text(
                                        'I\'m',
                                        style: TextStyle(
                                          fontFamily: 'Horizon',
                                          fontSize: 40,
                                          color: Colors.white
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      DefaultTextStyle(
                                          style: const TextStyle(
                                              fontFamily: 'Horizon',
                                              fontSize: 40,
                                              color: Colors.white
                                          ),
                                          child: AnimatedTextKit(
                                              repeatForever: true,
                                              animatedTexts: [
                                                RotateAnimatedText('Passionate'),
                                                RotateAnimatedText('HardWorking'),
                                                RotateAnimatedText('Flutter Dev')
                                              ]
                                          )
                                      )
                                    ],
                                  )
                              ),
                              const SizedBox(height: 16),
                              const Padding(
                                  padding: EdgeInsets.only(left: 16, right: 16),
                                  child: Text(
                                    miniDescription,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white70
                                    ),
                                  ),
                              ),
                              const SizedBox(height: 30),
                              ElevatedButton(
                                  onPressed: (){},
                                  style: ElevatedButton.styleFrom(
                                    side: const BorderSide(
                                      width: 3,
                                      color: Colors.white
                                    ),
                                    backgroundColor: Colors.transparent,
                                    padding: const EdgeInsets.all(20)
                                  ),
                                  child: AnimatedTextKit(
                                    repeatForever: true,
                                      animatedTexts: [
                                        ColorizeAnimatedText(
                                            "Download CV",
                                            textStyle: TextStyle(
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold
                                            ),
                                            colors: colorizeColors)])

                              )
                            ],
                          ),
                      ),
                      SizedBox(width: 30),
                      Expanded(
                          flex: ScreenHelper.isMobile(context)?0:3,
                          child: Lottie.asset('assets/animation/yoga.json', width: 300),
                      ),
                      SizedBox(height: 40,)
                    ],
                  )
              );
            }
        ),
      ),
    );
}