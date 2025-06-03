// sample_pages/dashboard_page_content.dart
import 'package:flutter/material.dart';

class DashboardPageContent extends StatelessWidget {
  const DashboardPageContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Этот виджет теперь просто контент страницы
    return Container(
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.all(10),
      child: const Text(
        'Dashboard Content',
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 36,
        ),
      ),
    );
  }
}
