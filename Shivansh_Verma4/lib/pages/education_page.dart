import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shivansh_verma4/utils/constants.dart';
import '../data/educations.dart';

import '../utils/screen_helper.dart';
class EducationPage extends StatelessWidget {
  const EducationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenHelper(
      mobile: _buildUi(ScreenHelper.mobileMaxWidth(context), context),
      tablet: _buildUi(tabletMaxWidth, context),
      desktop: _buildUi(desktopMaxWidth, context),
    );
  }
  Widget _buildUi(double width, BuildContext context)=> SizedBox(
    height: MediaQuery.of(context).size.height,
    child: Padding(
        padding: const EdgeInsets.only(top:100),
      child: ResponsiveWrapper(
        defaultScale: false,
          maxWidth: width,
          minWidth: width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  "EDUCATION",
              style: GoogleFonts.oswald(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 30,
                height: 1.3
              ),

              ),
              const SizedBox(height: 5,),
              Wrap(
                children:const [
                  Text(
                    education,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20
                    ),
                  )
                ],
              ),
              const SizedBox(height: 40,),
              LayoutBuilder(builder: (context, constraints){
                return Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  children: educations
                      .map((education)=>SizedBox(
                    width: constraints.maxWidth/2-20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          education.period,
                          style: GoogleFonts.oswald(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 5,),
                        Text(
                          education.description,
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: captionColor,
                            fontSize: 20
                          ),
                        )
                      ],
                    ),
                  ) ).toList(),
                );
              })
            ],
          )
      ),
    ),
  );
}
