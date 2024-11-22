import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../data/footer_items.dart';
import '../utils/constants.dart';
import '../utils/screen_helper.dart';
class FooterPage extends StatelessWidget {
  const FooterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenHelper(
      mobile: _buildUi(ScreenHelper.mobileMaxWidth(context), context),
      tablet: _buildUi(tabletMaxWidth, context),
      desktop: _buildUi(desktopMaxWidth, context),
    );
  }
  Widget _buildUi(double width, BuildContext context)=>Center(
    child: ResponsiveWrapper(
        minWidth: width,
        maxWidth: width,
        child: LayoutBuilder(
            builder: (context, constraints){
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 50),
                    child: Wrap(
                      spacing: 20,
                      runSpacing: 20,
                      children: footerItems
                      .map((footerItem)=> SizedBox(
                        height: 120,
                        width: ScreenHelper.isMobile(context)? constraints.maxWidth/2-20: constraints.maxWidth/4-20,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Image.asset(footerItem.iconPath,width: 25),
                                const SizedBox(width: 15),
                                Text(
                                  footerItem.title,
                                  style: GoogleFonts.oswald(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: 15,),
                            RichText(
                                textAlign: TextAlign.start,
                              text: TextSpan(
                                children:[
                                  TextSpan(
                                    text: '${footerItem.text1}\n',
                                    style: const TextStyle(
                                      color: captionColor,
                                      height: 1.8
                                    )
                                  ),
                                  TextSpan(
                                    text: '${footerItem.text2}\n',
                                      style: const TextStyle(
                                          color: captionColor
                                      )

                                  )
                                ]
                              ),
                            )
                          ],
                        ),

                      )
                      ).toList(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Flex(
                    direction: ScreenHelper.isMobile(context)?Axis.vertical: Axis.horizontal,
                    mainAxisAlignment: ScreenHelper.isMobile(context)? MainAxisAlignment.center: MainAxisAlignment.spaceBetween,
                    children: [
                      const Padding(
                          padding: EdgeInsets.only(bottom: 8),
                          child: Text('Copyright (c) 2024 $name. All rights reserved',
                            style: TextStyle(color: captionColor),

                          ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: (){
                            },
                            child: const MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: Text("Privacy Policy", style: TextStyle(color: captionColor),),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: const Text(
                              '|',
                              style: TextStyle(color: captionColor),
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                            },
                            child: const MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: Text("Terms & condition", style: TextStyle(color: captionColor),),
                            ),
                          )
                        ],
                      )
                    ],
                  )
                ],
              );
            }
        )
    ),
  );
}