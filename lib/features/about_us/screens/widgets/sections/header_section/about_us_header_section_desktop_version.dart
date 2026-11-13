import 'package:flutter/material.dart';

import '../../../../../../core/ui/sections/page_header_section.dart';
import '../../../../../../core/ui/theme/custom_colors.dart';

class AboutUsHeaderSectionDesktopVersion extends StatelessWidget {
  const AboutUsHeaderSectionDesktopVersion({super.key});

  @override
  Widget build(BuildContext context) {
    return const PageHeaderSectionDesktopVersion(
      preTitle: 'Conheça mais sobre a',
      title: TextSpan(
        children: [
          TextSpan(
            text: 'Rede ',
            style: TextStyle(color: CustomColors.midnight_slate),
          ),
          TextSpan(text: 'Campo'),
        ],
      ),
      description: 'Pesquisa, inovação e extensão em desenvolvimento rural',
    );
  }
}
