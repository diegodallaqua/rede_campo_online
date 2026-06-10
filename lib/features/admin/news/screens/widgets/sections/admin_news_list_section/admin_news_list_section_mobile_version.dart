import 'package:flutter/material.dart';
import 'package:rede_campo_online/features/admin/news/screens/widgets/listing/admin_news/admin_news_list_widget_mobile_version.dart';
import 'package:rede_campo_online/features/admin/news/stores/admin_news_store.dart';
import 'package:rede_campo_online/features/news/models/news.dart';

class AdminNewsListSectionMobileVersion extends StatelessWidget {
  final AdminNewsStore adminNewsStore;
  final Future<void> Function(News? news) onTapNews;

  const AdminNewsListSectionMobileVersion({
    super.key,
    required this.adminNewsStore,
    required this.onTapNews,
  });

  @override
  Widget build(BuildContext context) {
    return AdminNewsListWidgetMobileVersion(
      adminNewsStore: adminNewsStore,
      onTapNews: onTapNews,
    );
  }
}
