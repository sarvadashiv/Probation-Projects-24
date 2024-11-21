import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

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
                      .map,
                    ),
                  )
                ],
              );
            }
        )
    ),
  );
}
