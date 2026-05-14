import 'package:flutter/material.dart';
import '../../../../core/ui/theme/custom_colors.dart';
import '../../../news/stores/news_store.dart';
import '../listing/news_list_widget_desktop_version.dart';

class NewsSectionDesktopVersion extends StatelessWidget {
  final NewsStore newsStore;

  const NewsSectionDesktopVersion({super.key, required this.newsStore});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Notícias Recentes',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        color: CustomColors.fresh_sprout,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 64,
                      height: 3,
                      decoration: BoxDecoration(
                        color: CustomColors.fresh_sprout,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: () {
                    // TODO: navegar para a tela de notícias
                  },
                  icon: const Text(
                    'Ver todas',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: CustomColors.concrete_mist,
                    ),
                  ),
                  label: const Icon(
                    Icons.arrow_forward_rounded,
                    size: 16,
                    color: CustomColors.concrete_mist,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          NewsListWidgetDesktopVersion(newsStore: newsStore, totalCount: 10),
        ],
      ),
    );
  }
}
