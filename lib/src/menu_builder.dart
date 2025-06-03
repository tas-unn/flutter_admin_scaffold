import 'admin_menu_item.dart';

class MenuBuilder {
  static List<AdminMenuItem> buildMobileMenu(List<AdminMenuItem> items,
      {int limit = 5}) {
    final List<AdminMenuItem> result = [];

    void collectMobileItems(List<AdminMenuItem> items) {
      for (var item in items) {
        if (item.isMobile && item.route != null && item.pageBuilder != null) {
          result.add(item);
        }
        if (item.children.isNotEmpty) {
          collectMobileItems(item.children);
        }
      }
    }

    collectMobileItems(items);
    result.sort((a, b) => a.orderbottom.compareTo(b.orderbottom));
    return result.take(limit).toList();
  }

  static List<AdminMenuItem> buildDesktopMenu(List<AdminMenuItem> items) {
    return items.where((item) => item.isDesktop).toList();
  }

  static String? findActiveRoute(
      List<AdminMenuItem> items, String currentRoute) {
    for (var item in items) {
      if (item.route == currentRoute) {
        return item.route;
      }
      if (item.pathtomenu.isNotEmpty &&
          currentRoute.startsWith(item.pathtomenu)) {
        return item.route;
      }
      if (item.children.isNotEmpty) {
        final childRoute = findActiveRoute(item.children, currentRoute);
        if (childRoute != null) {
          return childRoute;
        }
      }
    }
    return null;
  }

  static AdminMenuItem? findActiveItem(
      List<AdminMenuItem> items, String currentRoute) {
    for (var item in items) {
      if (item.route == currentRoute) {
        return item;
      }
      if (item.pathtomenu.isNotEmpty &&
          currentRoute.startsWith(item.pathtomenu)) {
        return item;
      }
      if (item.children.isNotEmpty) {
        final childItem = findActiveItem(item.children, currentRoute);
        if (childItem != null) {
          return childItem;
        }
      }
    }
    return null;
  }
}
