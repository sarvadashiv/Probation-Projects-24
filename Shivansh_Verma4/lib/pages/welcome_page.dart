import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shivansh_verma4/utils/constants.dart';

import '../utils/screen_helper.dart';
class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
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
                                  )
                              ),
                            ],
                          ),
                      )
                    ],
                  )
              );
            }
        ),
      ),
    );
}