import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:badges/badges.dart' as FlutterBadges;
import 'admin_menu_item.dart';

class SideBar extends StatefulWidget {
  final List<AdminMenuItem> items;
  final String? selectedRoute;
  final ValueChanged<AdminMenuItem> onSelected;
  final Widget? header;
  final Widget? footer;
  final double width;
  final Color? iconColor;
  final Color? activeIconColor;
  final Color? textColor;
  final Color? activeTextColor;
  final Color? activeBackgroundColor;
  final Color? hoverColor;

  const SideBar({
    Key? key,
    required this.items,
    this.selectedRoute,
    required this.onSelected,
    this.header,
    this.footer,
    this.width = 250.0,
    this.iconColor,
    this.activeIconColor,
    this.textColor,
    this.activeTextColor,
    this.activeBackgroundColor,
    this.hoverColor,
  }) : super(key: key);

  @override
  _SideBarState createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  // Используем PageStorageBucket для сохранения состояния ExpansionTile
  final PageStorageBucket _bucket = PageStorageBucket();

  // _userExpandedState теперь не нужен, так как PageStorageKey будет сохранять состояние
  // Map<AdminMenuItem, bool> _initialExpansionStates = {}; // Тоже не нужен напрямую для initiallyExpanded

  @override
  void initState() {
    super.initState();
    // _calculateInitialExpansionStates(); // Больше не нужен, GoRouter сам управляет
  }

  @override
  void didUpdateWidget(covariant SideBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    // if (widget.items != oldWidget.items || widget.selectedRoute != oldWidget.selectedRoute) {
    //   _calculateInitialExpansionStates(); // Больше не нужен
    // }
  }

  String _getCurrentRoute() {
    // Используем GoRouterState.of(context) для получения актуального маршрута
    try {
      final GoRouterState goRouterState = GoRouterState.of(context);
      return goRouterState.matchedLocation;
    } catch (e) {
      // Возвращаем дефолтный маршрут или пустую строку, если GoRouter не доступен
      // (например, если SideBar используется вне GoRouter)
      return widget.selectedRoute ?? '/';
    }
  }

  // Обновленная логика определения, должен ли ExpansionTile быть раскрыт
  bool _isItemActive(AdminMenuItem item, String currentRoute) {
    // Если у элемента есть route, проверяем точное совпадение
    if (item.route != null && item.route!.isNotEmpty) {
      if (item.route == currentRoute) {
        return true;
      }
    }

    // Если у элемента есть pathtomenu, проверяем, начинается ли текущий роут с него
    // Но только если это не конечный элемент (т.е. у него нет route)
    if (item.pathtomenu.isNotEmpty &&
        (item.route == null || item.route!.isEmpty)) {
      if (currentRoute.startsWith(item.pathtomenu)) {
        return true;
      }
    }

    // Проверяем дочерние элементы
    for (var child in item.children) {
      if (_isItemActive(child, currentRoute)) {
        return true;
      }
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    final currentRoute = _getCurrentRoute();
    final theme = Theme.of(context);

    // Сортируем элементы для сайдбара
    List<AdminMenuItem> sortedItems = List.from(widget.items);
    sortedItems.sort((a, b) => a.order.compareTo(b.order));

    return Material(
      elevation: 4.0,
      color: theme.canvasColor,
      child: Container(
        width: widget.width,
        child: Column(
          children: [
            if (widget.header != null) widget.header!,
            Expanded(
              // Используем PageStorage for ListView, чтобы ExpansionTile сохранял состояние
              child: PageStorage(
                bucket: _bucket,
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: sortedItems.length,
                  itemBuilder: (context, index) {
                    final item = sortedItems[index];
                    return _buildMenuItem(item, currentRoute, theme);
                  },
                ),
              ),
            ),
            if (widget.footer != null) widget.footer!,
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
      AdminMenuItem item, String currentRoute, ThemeData theme,
      {int depth = 0}) {
    final bool isActuallySelected =
        _isItemActive(item, currentRoute); // Используем _isItemActive
    final bool hasChildren = item.children.isNotEmpty;

    final Color effectiveIconColor = isActuallySelected
        ? (widget.activeIconColor ?? theme.colorScheme.primary)
        : (widget.iconColor ?? theme.iconTheme.color ?? Colors.black54);
    final Color effectiveTextColor = isActuallySelected
        ? (widget.activeTextColor ?? theme.colorScheme.primary)
        : (widget.textColor ??
            theme.textTheme.bodyLarge?.color ??
            Colors.black87);
    final TextStyle textStyle = TextStyle(
      fontWeight: isActuallySelected ? FontWeight.bold : FontWeight.normal,
      color: effectiveTextColor,
      fontSize: 13,
    );
    final Color? tileBackgroundColor = isActuallySelected
        ? (widget.activeBackgroundColor ??
            theme.colorScheme.primary.withAlpha((255 * 0.1).round()))
        : null;

    final IconData? iconDataToShow =
        isActuallySelected ? item.selectedicon : item.unselectedicon;
    Widget leadingWidget;
    if (iconDataToShow != null) {
      Widget icon = Icon(iconDataToShow, color: effectiveIconColor, size: 20);
      if (item.badgetext.isNotEmpty) {
        icon = FlutterBadges.Badge(
          badgeContent: Text(item.badgetext,
              style: const TextStyle(color: Colors.white, fontSize: 10)),
          badgeStyle: FlutterBadges.BadgeStyle(
              badgeColor: Colors.red,
              padding: EdgeInsets.all(item.badgetext.length > 1 ? 4 : 5)),
          position: FlutterBadges.BadgePosition.topEnd(top: -10, end: -12),
          child: icon,
        );
      }
      leadingWidget =
          SizedBox(width: 36.0, height: 24, child: Center(child: icon));
    } else {
      leadingWidget =
          SizedBox(width: 36.0); // Для выравнивания, если нет иконки
    }

    final double leftPadding = 16.0 + (depth * 20.0);

    if (hasChildren) {
      // Используем PageStorageKey для сохранения состояния раскрытия ExpansionTile
      // Ключ должен быть уникальным и стабильным для каждого элемента
      return ExpansionTile(
        key: PageStorageKey<String>(item.route ??
            item.pathtomenu), // Используем уникальный идентификатор
        leading: leadingWidget,
        title: Text(item.displayNameForSideBar,
            style: TextStyle(
              fontSize: 13,
              fontWeight:
                  isActuallySelected ? FontWeight.bold : FontWeight.normal,
              color: isActuallySelected
                  ? (widget.activeTextColor ?? theme.colorScheme.primary)
                  : (widget.textColor ?? theme.textTheme.bodyLarge?.color),
            )),
        backgroundColor: tileBackgroundColor,
        iconColor: effectiveIconColor,
        collapsedIconColor: effectiveIconColor,
        initiallyExpanded: _isItemActive(
            item, currentRoute), // Изначальное состояние раскрытия
        onExpansionChanged: (bool expanding) {
          // Состояние теперь сохраняется через PageStorageKey, setState здесь не требуется для сохранения состояния,
          // но может быть полезно для других действий, если они нужны
        },
        tilePadding: EdgeInsets.only(left: leftPadding, right: 8.0),
        childrenPadding: EdgeInsets.zero,
        children: item.children
            .map<Widget>((AdminMenuItem child) =>
                _buildMenuItem(child, currentRoute, theme, depth: depth + 1))
            .toList(),
      );
    } else {
      // Для конечных элементов используем ListTile
      return ListTile(
        key: ValueKey<String>(
            item.route ?? item.title), // ValueKey для конечных элементов
        leading: leadingWidget,
        title: Text(item.displayNameForSideBar, style: textStyle),
        selected: isActuallySelected,
        selectedTileColor: tileBackgroundColor,
        hoverColor: widget.hoverColor ??
            theme.hoverColor.withAlpha((255 * 0.04).round()),
        onTap: () {
          if (item.route != null && item.route!.isNotEmpty) {
            // Переход с использованием GoRouter
            context.go(item.route!);
            widget.onSelected(
                item); // Вызов колбэка для очистки бейджа и других действий
          }
        },
        contentPadding: EdgeInsets.only(left: leftPadding, right: 16.0),
        minLeadingWidth: 0,
      );
    }
  }
}
