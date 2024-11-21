import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shivansh_verma4/utils/constants.dart';

import '../data/projects.dart';
import '../utils/screen_helper.dart';
import '../utils/utils.dart';

class ProjectsPage extends StatelessWidget {
  const ProjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenHelper(
      desktop: _buildUi(desktopMaxWidth, context),
      tablet: _buildUi(tabletMaxWidth, context),
      mobile: _buildUi(ScreenHelper.mobileMaxWidth(context), context),
    );
  }
  Widget _buildUi (double width, BuildContext context)=> ResponsiveWrapper(
      maxWidth: width,
    minWidth: width,
    defaultScale: false,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Project',
          style: GoogleFonts.oswald(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            fontSize: 30,
            height: 1.3
          ),
        ),
        const SizedBox(height: 5),
        Wrap(
          children: [
            Container(
              constraints: const BoxConstraints(maxWidth: 400, maxHeight: 700),
              child: const Text(
                'These are my best projects made in love with flutter',
                style: TextStyle(color: Colors.white , fontSize: 20),
                
              ),
            )
          ],
        ),
        SizedBox(height: 40),
        LayoutBuilder(builder: (context, constraints){
          return Wrap(
            spacing: 20,
              runSpacing: 20,
            children: projects.map(
                (project)=> SizedBox(
                  width: constraints.maxWidth/2-20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(project.image),
                      const SizedBox(height: 5,),
                      Text(
                        project.description,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: captionColor,
                          fontSize: 20
                        ),
                      ),
                      IconButton(
                          onPressed: ()=> Utils.launchURL('github.com/sarvadashiv'),
                          icon: const FaIcon(FontAwesomeIcons.github),
                        color: Colors.white70,
                        iconSize: 24,
                      )
                    ],
                  ),
                )
            ).toList(),
          );
        })
      ],
    ),
  );
}