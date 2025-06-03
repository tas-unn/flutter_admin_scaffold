import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:go_router/go_router.dart';
import 'package:badges/badges.dart' as FlutterBadges;
export 'src/admin_menu_item.dart';
export 'src/side_bar.dart';
import 'src/admin_menu_item.dart';
import 'src/side_bar.dart';
import 'src/menu_builder.dart';
export 'src/route_utils.dart'; // Убедитесь, что этот экспорт присутствует

// Тип для функции, строящей NavBar для PersistentTabView
typedef PersistentNavBarBuilder = Widget Function(NavBarConfig navBarConfig);

class AdminScaffold extends StatefulWidget {
  AdminScaffold({
    Key? key,
    this.appBar,
    this.isAppBarOnDesktop = false,
    required this.items,
    this.sideBarHeader,
    this.sideBarFooter,
    this.sideBarWidth = 250.0,
    this.onItemSelected,
    this.selectedRoute,
    this.leadingIcon,
    required this.body, // На мобильном это widget.navigationShell, если используется PersistentTabView
    this.backgroundColor,
    this.mobileThreshold = 768.0,
    this.navigationShell, // Для PersistentTabView.router
    this.bottomNavigationBarItemsLimit = 5,

    // Параметры для кастомизации PersistentBottomNavBar
    this.navBarStyle = "Style 1",
    this.bottomNavActiveColor,
    this.bottomNavInactiveColor,
    this.bottomNavActiveBackgroundColor,
    this.bottomNavBackgroundColor, // Общий фон навбара
    this.bottomNavIconSize = 24,
    this.bottomNavTextStyle = const TextStyle(),
    this.navBarDecoration, // Для более глубокой кастомизации фона (тени, бордеры и т.д.)
  }) : super(key: key);

  final AppBar? appBar;
  final bool isAppBarOnDesktop;
  final List<AdminMenuItem> items;
  final Widget? sideBarHeader;
  final Widget? sideBarFooter;
  final double sideBarWidth;
  final ValueChanged<AdminMenuItem>? onItemSelected;
  final String? selectedRoute;
  final Widget? leadingIcon;
  final Widget body;
  final Color? backgroundColor;
  final double mobileThreshold;
  final StatefulNavigationShell? navigationShell;
  final int bottomNavigationBarItemsLimit;

  // Кастомизация PersistentBottomNavBar
  // NavBarBuilder get navBarBuilder => navBarStyles[navBarStyle]!; // Этот геттер может быть лишним
  final String navBarStyle;
  final Color? bottomNavActiveColor;
  final Color? bottomNavInactiveColor;
  final Color?
      bottomNavActiveBackgroundColor; // Для активного таба в некоторых стилях
  final Color? bottomNavBackgroundColor; // Фон самого NavBara
  final double bottomNavIconSize;
  final TextStyle bottomNavTextStyle;
  final NavBarDecoration? navBarDecoration;

  // Используем обычную функцию, а не typedef, для большей гибкости
  // ИЛИ: Если вы сохраняете typedef, то он должен быть:
  // typedef NavBarBuilder = Widget Function(
  //   NavBarConfig navBarConfig,
  //   NavBarDecoration navBarDecoration,
  //   ItemAnimation? itemAnimationProperties, // Может быть nullable
  //   NeumorphicProperties? neumorphicProperties, // Может быть nullable
  // );
  // И тогда map должен быть:
  // Map<String, NavBarBuilder> navBarStyles = {
  //   "Neumorphic": (navBarConfig, navBarDecoration, itemAnimationProperties, neumorphicProperties) => NeumorphicBottomNavBar(
  //     navBarConfig: navBarConfig,
  //     navBarDecoration: navBarDecoration,
  //     neumorphicProperties: neumorphicProperties ?? const NeumorphicProperties(),
  //   ),
  //   ...
  // };

  // Если вы используете PersistentTabView.router, то навбар строится через navBarBuilder в нем
  // и navBarConfig, ItemAnimation, NeumorphicProperties передаются PersistentTabView.router
  // а не AdminScaffold.
  // Так что Map можно оставить как есть, а вот `NavBarBuilder get navBarBuilder` можно убрать.
  final Map<
      String,
      Widget Function({
        required NavBarConfig navBarConfig,
        NavBarDecoration? navBarDecoration,
        ItemAnimation? itemAnimationProperties,
        NeumorphicProperties? neumorphicProperties,
      })> navBarStyles = {
    "Neumorphic": (
            {required navBarConfig,
            navBarDecoration,
            itemAnimationProperties,
            neumorphicProperties}) =>
        NeumorphicBottomNavBar(
          navBarConfig: navBarConfig,
        ),
    "Style 1": (
            {required navBarConfig,
            navBarDecoration,
            itemAnimationProperties,
            neumorphicProperties}) =>
        Style1BottomNavBar(navBarConfig: navBarConfig),
    "Style 2": (
            {required navBarConfig,
            navBarDecoration,
            itemAnimationProperties,
            neumorphicProperties}) =>
        Style2BottomNavBar(
          navBarConfig: navBarConfig,
        ),
    "Style 3": (
            {required navBarConfig,
            navBarDecoration,
            itemAnimationProperties,
            neumorphicProperties}) =>
        Style3BottomNavBar(navBarConfig: navBarConfig),
    "Style 4": (
            {required navBarConfig,
            navBarDecoration,
            itemAnimationProperties,
            neumorphicProperties}) =>
        Style4BottomNavBar(
          navBarConfig: navBarConfig,
        ),
    "Style 5": (
            {required navBarConfig,
            navBarDecoration,
            itemAnimationProperties,
            neumorphicProperties}) =>
        Style5BottomNavBar(navBarConfig: navBarConfig),
    "Style 6": (
            {required navBarConfig,
            navBarDecoration,
            itemAnimationProperties,
            neumorphicProperties}) =>
        Style6BottomNavBar(
          navBarConfig: navBarConfig,
        ),
    "Style 7": (
            {required navBarConfig,
            navBarDecoration,
            itemAnimationProperties,
            neumorphicProperties}) =>
        Style7BottomNavBar(
          navBarConfig: navBarConfig,
        ),
    "Style 8": (
            {required navBarConfig,
            navBarDecoration,
            itemAnimationProperties,
            neumorphicProperties}) =>
        Style8BottomNavBar(
          navBarConfig: navBarConfig,
        ),
    "Style 9": (
            {required navBarConfig,
            navBarDecoration,
            itemAnimationProperties,
            neumorphicProperties}) =>
        Style9BottomNavBar(
          navBarConfig: navBarConfig,
        ),
    "Style 10": (
            {required navBarConfig,
            navBarDecoration,
            itemAnimationProperties,
            neumorphicProperties}) =>
        Style10BottomNavBar(
          navBarConfig: navBarConfig,
        ),
    "Style 11": (
            {required navBarConfig,
            navBarDecoration,
            itemAnimationProperties,
            neumorphicProperties}) =>
        Style11BottomNavBar(
          navBarConfig: navBarConfig,
        ),
    "Style 12": (
            {required navBarConfig,
            navBarDecoration,
            itemAnimationProperties,
            neumorphicProperties}) =>
        Style12BottomNavBar(
          navBarConfig: navBarConfig,
        ),
    "Style 13": (
            {required navBarConfig,
            navBarDecoration,
            itemAnimationProperties,
            neumorphicProperties}) =>
        Style13BottomNavBar(
          navBarConfig: navBarConfig,
        ),
    "Style 14": (
            {required navBarConfig,
            navBarDecoration,
            itemAnimationProperties,
            neumorphicProperties}) =>
        Style14BottomNavBar(
          navBarConfig: navBarConfig,
        ),
    "Style 15": (
            {required navBarConfig,
            navBarDecoration,
            itemAnimationProperties,
            neumorphicProperties}) =>
        Style15BottomNavBar(
          navBarConfig: navBarConfig,
        ),
    "Style 16": (
            {required navBarConfig,
            navBarDecoration,
            itemAnimationProperties,
            neumorphicProperties}) =>
        Style16BottomNavBar(
          navBarConfig: navBarConfig,
        ),
  };

  @override
  _AdminScaffoldState createState() => _AdminScaffoldState();
}

class _AdminScaffoldState extends State<AdminScaffold>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _isMobile = false;
  bool _isOpenSidebar = false; // Только для десктопного сайдбара
  double _screenWidth = 0;

  // Элементы для нижнего меню на мобильном (PersistentTabView)
  List<AdminMenuItem> get _bottomNavItems {
    final result = MenuBuilder.buildMobileMenu(widget.items,
        limit: widget.bottomNavigationBarItemsLimit);
    return result;
  }

  // Элементы для бокового меню (SideBar на десктопе или Drawer на мобильном)
  List<AdminMenuItem> get _sideBarOrDrawerItems {
    return MenuBuilder.buildDesktopMenu(widget.items);
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutQuad,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final mediaQuery = MediaQuery.of(context);
    if (_screenWidth == mediaQuery.size.width && _screenWidth != 0) {
      return;
    }
    final newIsMobile = mediaQuery.size.width < widget.mobileThreshold;
    if (_isMobile != newIsMobile || _screenWidth == 0) {
      setState(() {
        _isMobile = newIsMobile;
        // На десктопе сайдбар по умолчанию открыт, если есть элементы
        _isOpenSidebar = !_isMobile && _sideBarOrDrawerItems.isNotEmpty;
        _animationController.value =
            (_isMobile || _sideBarOrDrawerItems.isEmpty) ? 0 : 1;
      });
    }
    _screenWidth = mediaQuery.size.width;

    // Проверяем и обновляем текущий роут для нижнего меню
    if (_isMobile && widget.navigationShell != null) {
      final itemsForBottomNav = _bottomNavItems;
      if (itemsForBottomNav.isNotEmpty) {
        final currentRoute =
            widget.selectedRoute ?? GoRouterState.of(context).matchedLocation;

        if (!itemsForBottomNav.any((item) => item.route == currentRoute)) {
          // Используем Future.microtask чтобы избежать вызова setState во время build
          Future.microtask(() {
            GoRouter.of(context).go(itemsForBottomNav.first.route!);
          });
        }
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleSidebar() {
    // Используется только для десктопного сайдбара
    if (_isMobile)
      return; // На мобильном Drawer управляется через Scaffold.of(context).openDrawer()
    setState(() {
      _isOpenSidebar = !_isOpenSidebar;
      if (_isOpenSidebar) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  AppBar _buildActualAppBar() {
    // Кнопка меню нужна, если есть элементы для Drawer (на мобильном) или для сайдбара (на десктопе)
    final bool showMenuButton = _sideBarOrDrawerItems.isNotEmpty;

    final Widget? leadingButton = showMenuButton
        ? Builder(
            builder: (BuildContext scaffoldContext) {
              // Контекст "под" Scaffold
              return IconButton(
                icon: widget.leadingIcon ?? const Icon(Icons.menu),
                onPressed: () {
                  if (_isMobile) {
                    // На мобильном открываем Drawer
                    FocusScope.of(scaffoldContext).unfocus();
                    Scaffold.of(scaffoldContext).openDrawer();
                  } else {
                    // На десктопе управляем сайдбаром
                    _toggleSidebar();
                  }
                },
              );
            },
          )
        : widget.appBar?.leading;

    return AppBar(
      leading: leadingButton,
      title: widget.appBar?.title,
      actions: widget.appBar?.actions,
      // ... остальные свойства AppBar копируются из widget.appBar ...
      automaticallyImplyLeading:
          widget.appBar?.automaticallyImplyLeading ?? true,
      flexibleSpace: widget.appBar?.flexibleSpace,
      bottom: widget.appBar?.bottom,
      elevation: widget.appBar?.elevation,
      scrolledUnderElevation: widget.appBar?.scrolledUnderElevation,
      notificationPredicate: widget.appBar?.notificationPredicate ??
          defaultScrollNotificationPredicate,
      shadowColor: widget.appBar?.shadowColor,
      surfaceTintColor: widget.appBar?.surfaceTintColor,
      shape: widget.appBar?.shape,
      backgroundColor: widget.appBar?.backgroundColor,
      foregroundColor: widget.appBar?.foregroundColor,
      iconTheme: widget.appBar?.iconTheme,
      actionsIconTheme: widget.appBar?.actionsIconTheme,
      primary: widget.appBar?.primary ?? true,
      centerTitle: widget.appBar?.centerTitle,
      excludeHeaderSemantics: widget.appBar?.excludeHeaderSemantics ?? false,
      titleSpacing: widget.appBar?.titleSpacing,
      toolbarOpacity: widget.appBar?.toolbarOpacity ?? 1.0,
      bottomOpacity: widget.appBar?.bottomOpacity ?? 1.0,
      toolbarHeight: widget.appBar?.toolbarHeight,
      leadingWidth: widget.appBar?.leadingWidth,
      toolbarTextStyle: widget.appBar?.toolbarTextStyle,
      titleTextStyle: widget.appBar?.titleTextStyle,
      systemOverlayStyle: widget.appBar?.systemOverlayStyle,
    );
  }

  void clearBadgeForRoute(String? route, List<AdminMenuItem> menuItems) {
    if (route == null) return;

    for (var item in menuItems) {
      if (item.route == route) {
        // Используем setState, чтобы обновить UI после изменения badgetext
        setState(() {
          item.badgetext = ""; // Нашли совпадение — убираем бейдж
        });
        return; // Бейдж найден и удален, можно выйти
      }
      if (item.children.isNotEmpty) {
        clearBadgeForRoute(route, item.children); // Ищем в глубину
      }
    }
  }

  Widget _buildSideBarOrDrawerWidget({bool isDrawer = false}) {
    final itemsToDisplay =
        _sideBarOrDrawerItems; // Всегда используем isDesktop элементы
    if (itemsToDisplay.isEmpty &&
        widget.sideBarHeader == null &&
        widget.sideBarFooter == null) {
      return isDrawer
          ? Drawer(child: Center(child: Text("Меню пусто")))
          : const SizedBox.shrink();
    }

    // `selectedRoute` может быть null, но SideBar ожидает String
    final String currentRoute =
        widget.selectedRoute ?? GoRouterState.of(context).matchedLocation;

    return SideBar(
      items: itemsToDisplay,
      selectedRoute: currentRoute,
      onSelected: (item) {
        if (widget.onItemSelected != null) {
          widget.onItemSelected!(item);
        }
        // Условие: убирать бейдж только если clearBadgeOnTap == true
        if (item.clearBadgeOnTap) {
          clearBadgeForRoute(
              item.route, widget.items); // Передаем корневые элементы
        }

        if (isDrawer) {
          // Если это Drawer, закрываем его после выбора
          Navigator.of(context).pop();
        }
      },
      header: widget.sideBarHeader,
      footer: widget.sideBarFooter,
      width: widget.sideBarWidth,
    );
  }

  Widget _buildPersistentNavBarWidget(NavBarConfig navBarConfig) {
    final selectedBuilder = widget.navBarStyles[widget.navBarStyle];

    if (selectedBuilder != null) {
      return selectedBuilder(
        navBarConfig: navBarConfig,
        navBarDecoration: widget.navBarDecoration ?? const NavBarDecoration(),
        itemAnimationProperties: const ItemAnimation(), // Дефолт или из пропсов
        neumorphicProperties:
            const NeumorphicProperties(), // Дефолт или из пропсов
      );
    }

    return Style1BottomNavBar(
      navBarConfig: navBarConfig,
      navBarDecoration: widget.navBarDecoration ?? const NavBarDecoration(),
    );
  }

  @override
  Widget build(BuildContext context) {
    // effectiveAppBar: Если appBar не задан ИЛИ не должен отображаться на десктопе И мы на десктопе, то null.
    // Иначе - строим appBar.
    final effectiveAppBar = (widget.appBar == null &&
                !widget.isAppBarOnDesktop) ||
            _isMobile
        ? _buildActualAppBar() // Если не задан appBar или не должен быть на десктопе, но мы на мобильном, или appBar задан.
        : (widget.isAppBarOnDesktop ? _buildActualAppBar() : null);

    final theme = Theme.of(context);

    // --- Мобильный режим с PersistentTabView ---
    if (_isMobile && widget.navigationShell != null) {
      final itemsForBottomNav =
          _bottomNavItems; // Уже отсортированы и обрезаны в геттере

      // Если нет элементов в bottom nav — показываем просто navigationShell
      if (itemsForBottomNav.isEmpty) {
        return Scaffold(
          appBar: effectiveAppBar,
          drawer: _getDrawer(),
          body: widget.navigationShell,
          backgroundColor:
              widget.backgroundColor ?? theme.scaffoldBackgroundColor,
        );
      }

      // Основной мобильный интерфейс с нижней навигацией
      return Scaffold(
        appBar: effectiveAppBar,
        drawer: _getDrawer(),
        body: PersistentTabView.router(
          navigationShell: widget.navigationShell!,
          tabs: itemsForBottomNav.map((item) {
            return PersistentRouterTabConfig(
              item: ItemConfig(
                icon: item.badgetext.isNotEmpty
                    ? FlutterBadges.Badge(
                        badgeContent: Text(item.badgetext,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 10)),
                        badgeStyle: FlutterBadges.BadgeStyle(
                            badgeColor: Colors.red,
                            padding: EdgeInsets.all(
                                item.badgetext.length > 1 ? 4 : 5)),
                        position: FlutterBadges.BadgePosition.topEnd(
                            top: -10, end: -12),
                        child: Icon(item.selectedicon ?? Icons.circle_outlined),
                      )
                    : Icon(item.selectedicon ?? Icons.circle_outlined),
                title: item.displayNameForBottomNav,
                textStyle: widget.bottomNavTextStyle,
                iconSize: widget.bottomNavIconSize,
                activeForegroundColor:
                    widget.bottomNavActiveColor ?? theme.colorScheme.primary,
                inactiveForegroundColor:
                    widget.bottomNavInactiveColor ?? Colors.grey,
                activeColorSecondary:
                    widget.bottomNavActiveBackgroundColor ?? Colors.blue,
              ),
            );
          }).toList(),
          onTabChanged: (index) {
            if (index >= 0 && index < itemsForBottomNav.length) {
              final item = itemsForBottomNav[index];
              print(item.title);
              if (item.clearBadgeOnTap) {
                Future.microtask(() {
                  // Ищем элемент в полном списке по route
                  final fullItem = widget.items.firstWhere(
                    (i) => i.route == item.route,
                    orElse: () => item,
                  );
                  clearBadgeForRoute(fullItem.route, widget.items);
                });
              }
            }
          },
          backgroundColor: widget.bottomNavBackgroundColor ??
              theme.bottomAppBarTheme.color ??
              theme.scaffoldBackgroundColor,
          navBarBuilder: _buildPersistentNavBarWidget,
          // Дополнительные параметры PersistentTabView.router, если нужны:
          handleAndroidBackButtonPress: true,
          resizeToAvoidBottomInset: true,
          stateManagement: true,
          //navBarStyle: NavBarStyle.neumorphic, // Это не используется для navBarBuilder
        ),
        backgroundColor:
            widget.backgroundColor ?? theme.scaffoldBackgroundColor,
      );
    }

    // --- Десктопный режим ---
    final sideBarWidget = _buildSideBarOrDrawerWidget();

    return Scaffold(
      backgroundColor: widget.backgroundColor,
      appBar: effectiveAppBar,
      // Drawer только на мобильном, если navigationShell == null (т.е. обычный Scaffold)
      // или если navigationShell не используется, но есть элементы для drawer
      drawer: _isMobile &&
              widget.navigationShell == null &&
              _sideBarOrDrawerItems.isNotEmpty
          ? _getDrawer()
          : null,
      body: Row(
        children: [
          // Анимированный сайдбар для десктопа
          if (!_isMobile && _sideBarOrDrawerItems.isNotEmpty)
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return ClipRect(
                  child: SizedBox(
                    width: widget.sideBarWidth * _animation.value,
                    child: child!,
                  ),
                );
              },
              child: sideBarWidget,
            ),

          // Основной контент
          Expanded(
            child: Container(
              alignment: Alignment
                  .topLeft, // Изменено на topLeft для лучшего выравнивания
              padding: const EdgeInsets.all(16),
              child: widget.body,
            ),
          ),
        ],
      ),
    );
  }

  // Вспомогательный метод для получения Drawer
  Widget? _getDrawer() {
    final hasDrawerContent = _sideBarOrDrawerItems.isNotEmpty ||
        widget.sideBarHeader != null ||
        widget.sideBarFooter != null;
    return hasDrawerContent
        ? Drawer(child: _buildSideBarOrDrawerWidget(isDrawer: true))
        : null;
  }
}
