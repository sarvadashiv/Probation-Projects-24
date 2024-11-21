import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../data/skill_list.dart';
import '../utils/constants.dart';
import '../utils/screen_helper.dart';
class SkillPage extends StatelessWidget {
  const SkillPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenHelper(
      mobile: _buildUi(ScreenHelper.mobileMaxWidth(context), context),
      tablet: _buildUi(tabletMaxWidth, context),
      desktop: _buildUi(desktopMaxWidth, context),
    );
  }
  Widget _buildUi(double width, BuildContext context)=>ResponsiveWrapper(
      maxWidth: width,
      minWidth: width,
      child:Flex(
          direction:ScreenHelper.isMobile(context)?Axis.vertical:Axis.horizontal,
        children: [
          Expanded(
            flex: ScreenHelper.isMobile(context)?0:2,
              child: Lottie.asset('assets/animation/skills.json',width: 500),

          ),
          const SizedBox(width: 40,),
          Expanded(
            flex: ScreenHelper.isMobile(context)?0:4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('SKILLS',
                  style: GoogleFonts.oswald(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 28,
                    height: 1.3
                  ),
                  ),
                  const SizedBox(height: 12,),
                  const Text(
                    skill,
                    style: TextStyle(fontSize: 20,color: captionColor),
                  ),
                  const SizedBox(height: 16),
                  Column(
                    children: skills
                        .map(
                            (skill)=> Container(
                              margin: EdgeInsets.only(bottom: 16),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: skill.percentage,
                                      child: Container(
                                        padding: EdgeInsets.only(left: 12),
                                        alignment: Alignment.centerLeft,
                                        height: 38,
                                        color: Colors.white,
                                        child: Text(skill.skill),
                                      )
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    flex: 100-skill.percentage,
                                      child: const Divider(color: Colors.white),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    '${skill.percentage}%',
                                    style: const TextStyle(
                                      color: Colors.white,fontSize: 16
                                    ),
                                  )
                                ],
                              ),
                            )).toList()
                  )
                ],
              )
          )
        ],
      ));
}