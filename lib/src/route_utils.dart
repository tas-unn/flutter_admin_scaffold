import 'package:go_router/go_router.dart';
import 'admin_menu_item.dart';

List<RouteBase> generateRoutesFromAdminMenuItems(
  List<AdminMenuItem> menuItems, {
  bool isShellBranch = false,
}) {
  final List<RouteBase> routes = [];

  for (final item in menuItems) {
    // 1. Если у элемента есть pageBuilder и route — создаём для него GoRoute
    if (item.route != null &&
        item.route!.isNotEmpty &&
        item.pageBuilder != null) {
      routes.add(
        GoRoute(
          path: item.route!,
          name: item.route, // Опционально: добавьте имя для удобства отладки
          builder: item.pageBuilder!,
          routes: item.children.isNotEmpty && !isShellBranch
              ? generateRoutesFromAdminMenuItems(
                  item.children,
                  isShellBranch: isShellBranch,
                )
              : [],
        ),
      );
    }

    // 2. Если у элемента нет своего pageBuilder, но есть дочерние элементы с pageBuilder
    // И мы не в shell branch — продолжаем рекурсивно генерировать роуты для детей
    // Это условие означает, что категория, которая сама не является страницей, может содержать страницы.
    if (!isShellBranch && item.children.isNotEmpty) {
      routes.addAll(
        generateRoutesFromAdminMenuItems(
          item.children,
          isShellBranch: isShellBranch,
        ),
      );
    }
  }

  return routes;
}

List<AdminMenuItem> collectAllPageItems(List<AdminMenuItem> menuItems) {
  final List<AdminMenuItem> result = [];

  void recurse(List<AdminMenuItem> items) {
    for (final item in items) {
      // Добавляем элемент, если у него есть pageBuilder и route
      if (item.pageBuilder != null &&
          item.route != null &&
          item.route!.isNotEmpty) {
        result.add(item);
      }
      if (item.children.isNotEmpty) {
        recurse(item.children);
      }
    }
  }

  recurse(menuItems);

  return result;
}

List<StatefulShellBranch> generateShellBranchesFromAdminMenuItems(
  List<AdminMenuItem> allReachableItemsForShellBranches,
) {
  final List<StatefulShellBranch> branches = [];

  // Разделяем элементы на мобильные и десктопные
  final mobileItems =
      allReachableItemsForShellBranches.where((item) => item.isMobile).toList();
  final desktopItems = allReachableItemsForShellBranches
      .where((item) => item.isDesktop)
      .toList();

  // Сортируем мобильные элементы
  mobileItems.sort((a, b) => a.orderbottom.compareTo(b.orderbottom));

  // Объединяем списки
  final sortedItems = [...mobileItems, ...desktopItems];

  for (final item in sortedItems) {
    if (item.route != null &&
        item.route!.isNotEmpty &&
        item.pageBuilder != null) {
      // Собираем все дочерние роуты, включая те, которые не отображаются в меню
      final childRoutes = <RouteBase>[];

      void collectChildRoutes(List<AdminMenuItem> items) {
        for (final child in items) {
          if (child.route != null &&
              child.route!.isNotEmpty &&
              child.pageBuilder != null) {
            childRoutes.add(
              GoRoute(
                path: child.route!,
                builder: child.pageBuilder!,
              ),
            );
          }
          if (child.children.isNotEmpty) {
            collectChildRoutes(child.children);
          }
        }
      }

      // Собираем все дочерние роуты
      collectChildRoutes(item.children);

      branches.add(
        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
              path: item.route!,
              builder: item.pageBuilder!,
              routes: childRoutes,
            ),
          ],
        ),
      );
    }
  }
  return branches;
}
