import 'package:flutter/material.dart';

import '../../../../../../core/ui/sections/page_header_section.dart';
import '../../../../../../core/ui/theme/custom_colors.dart';

class AboutUsHeaderSectionMobileVersion extends StatelessWidget {
  const AboutUsHeaderSectionMobileVersion({super.key});

  @override
  Widget build(BuildContext context) {
    return const PageHeaderSectionMobileVersion(
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
