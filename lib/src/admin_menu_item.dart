import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AdminMenuItem {
  AdminMenuItem({
    required this.title, // Используется как fallback, если name/namebottom не указаны
    this.route,
    this.selectedicon,
    this.unselectedicon,
    this.isDesktop = true,
    this.isMobile = false, // По умолчанию не в bottom_nav, если не указано явно
    this.pathtomenu = '',  // Для подсветки родительского пункта
    this.name = '',        // Имя для SideBar/Drawer
    this.namebottom = '',  // Имя для BottomNavBar
    int? order,        // Порядок в SideBar/Drawer
    int? orderbottom,  // Порядок в BottomNavBar
    this.categ = 0,        // Категория доступа (пока не используется в Scaffold, но можно фильтровать список items)
    String? badgetext,   // Текст для Badge
    this.pageBuilder,
    bool? clearBadgeOnTap, // По умолчанию убираем бейдж

    this.children = const [],
  }) : order = order ?? 0,
        orderbottom = orderbottom ?? 0,
        badgetext = badgetext ?? '',
        clearBadgeOnTap = clearBadgeOnTap ?? true;

  final String title;
  final IconData? selectedicon;
  final IconData? unselectedicon;
  final List<AdminMenuItem> children;
  final bool isDesktop;
  final bool isMobile;
  final String? route;
  final String pathtomenu;
  final String name;
  final String namebottom;
  final int order; // Сделал final
  final int orderbottom; // Сделал final
  final int categ;
  final bool clearBadgeOnTap; // Сделал final
  String badgetext; // Оставил mutable, чтобы можно было очищать бейдж
  final Widget Function(BuildContext context, GoRouterState state)? pageBuilder;

  // Геттеры для удобства, чтобы использовать title как fallback
  String get displayNameForSideBar {
    return name.isNotEmpty ? name : title;
  }

  String get displayNameForBottomNav {
    return namebottom.isNotEmpty ? namebottom : title;
  }
}
extension AdminMenuItemCopy on AdminMenuItem {
  AdminMenuItem copyWith({
    String? title,
    IconData? selectedicon,
    IconData? unselectedicon,
    List<AdminMenuItem>? children,
    bool? isDesktop,
    bool? isMobile,
    String? route,
    String? pathtomenu,
    String? name,
    String? namebottom,
    int? order,
    int? orderbottom,
    int? categ,
    bool? clearBadgeOnTap,
    String? badgetext,
    Widget Function(BuildContext context, GoRouterState state)? pageBuilder,
  }) {
    return AdminMenuItem(
      title: title ?? this.title,
      selectedicon: selectedicon ?? this.selectedicon,
      unselectedicon: unselectedicon ?? this.unselectedicon,
      children: children ?? this.children,
      isDesktop: isDesktop ?? this.isDesktop,
      isMobile: isMobile ?? this.isMobile,
      route: route ?? this.route,
      pathtomenu: pathtomenu ?? this.pathtomenu,
      name: name ?? this.name,
      namebottom: namebottom ?? this.namebottom,
      order: order ?? this.order,
      orderbottom: orderbottom ?? this.orderbottom,
      categ: categ ?? this.categ,
      clearBadgeOnTap: clearBadgeOnTap ?? this.clearBadgeOnTap,
      badgetext: badgetext ?? this.badgetext,
      pageBuilder: pageBuilder ?? this.pageBuilder,
    );
  }
}
