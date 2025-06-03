import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Главный импорт твоего пакета
import 'package:flutter_admin_scaffold/admin_scaffold.dart';

// Импорты виджетов контента страниц
// Убедись, что эти файлы существуют и содержат StatelessWidget с соответствующим контентом
import 'package:flutter_admin_scaffold_example/sample_pages/DesktopOnlyPageContent.dart';
import 'package:flutter_admin_scaffold_example/sample_pages/dashboard_page.dart';
import 'package:flutter_admin_scaffold_example/sample_pages/second_level_item_1_page.dart';
import 'package:flutter_admin_scaffold_example/sample_pages/second_level_item_2_page.dart';
import 'package:flutter_admin_scaffold_example/sample_pages/settings.dart';
import 'package:flutter_admin_scaffold_example/sample_pages/subitem1.dart';
import 'package:flutter_admin_scaffold_example/sample_pages/subitem2.dart';

void main() {
  runApp(MyApp());
}

// --- Определение элементов меню ---
final List<AdminMenuItem> _appMenuItems = [
  AdminMenuItem(
    order: 1,
    orderbottom: 0,
    title: 'Dashboard',
    route: '/',
    selectedicon: Icons.dashboard,
    unselectedicon: Icons.dashboard_outlined,
    isMobile: true,
    isDesktop: true,
    name: "Главная",
    namebottom: "Дом",
    pathtomenu: "/",
    pageBuilder: (context, state) => const DashboardPageContent(),
  ),
  AdminMenuItem(
    order: 0,
    title: 'Items Category',
    selectedicon: Icons.folder_copy,
    unselectedicon: Icons.folder_copy_outlined,
    isDesktop: true,
    name: "Элементы",
    pathtomenu: "/item",
    // Общий префикс для подсветки
    children: [
      AdminMenuItem(
        order: 0,
        title: 'Item 1',
        route: '/item1',
        selectedicon: Icons.filter_1,
        unselectedicon: Icons.filter_1_outlined,
        isMobile: false,
        isDesktop: true,
        name: "Элемент 1",
        namebottom: "Элем.1",
        badgetext: "3",
        pageBuilder: (context, state) => const Item1PageContent(),
      ),
      AdminMenuItem(
        order: 1,
        title: 'Item 2',
        route: '/item2',
        selectedicon: Icons.filter_2,
        unselectedicon: Icons.filter_2_outlined,
        isMobile: false,
        isDesktop: true,
        name: "Элемент 2",
        namebottom: "Элем.2",
        pageBuilder: (context, state) => const Item2PageContent(),
      ),
      AdminMenuItem(
        order: 2,
        title: 'Sub Items',
        selectedicon: Icons.snippet_folder,
        unselectedicon: Icons.snippet_folder_outlined,
        isDesktop: true,
        name: "Под-элементы",
        // Общий префикс
        children: [
          AdminMenuItem(
            order: 0,
            title: 'Sub Item 1',
            route: '/subitem1',
            selectedicon: Icons.looks_one,
            unselectedicon: Icons.looks_one_outlined,
            isDesktop: true,
            name: "Под-Элемент 1",
            pageBuilder: (context, state) => const SubItem1PageContent(),
          ),
          AdminMenuItem(
            order: 1,
            title: 'Sub Item 2',
            route: '/subitem2',
            selectedicon: Icons.image_search,
            unselectedicon: Icons.image_outlined,
            isDesktop: true,
            name: "Картинка",
            pageBuilder: (context, state) => const SubItem2PageContent(),
          ),
        ],
      ),
    ],
  ),
  AdminMenuItem(
    order: 2,
    orderbottom: 1,
    title: 'Settings',
    route: '/settings',
    selectedicon: Icons.settings_applications,
    unselectedicon: Icons.settings_outlined,
    isMobile: true,
    isDesktop: true,
    name: "Настройки",
    namebottom: "Настр.",
    pathtomenu: "/settings",
    badgetext: "New",
    pageBuilder: (context, state) => const SettingsPageContent(),
  ),
  AdminMenuItem(
    order: 3,
    title: 'Desktop Only',
    route: '/desktoponly',
    selectedicon: Icons.desktop_mac,
    unselectedicon: Icons.desktop_windows_outlined,
    isDesktop: true,
    isMobile: false,
    name: "Только ПК",
    pathtomenu: "/desktoponly",
    pageBuilder: (context, state) => const DesktopOnlyPageContent(),
  ),
];

final List<AdminMenuItem> _profileMenuItems = [
  AdminMenuItem(
    title: 'User Profile',
    selectedicon: Icons.account_circle,
    route: '/profile',
    pageBuilder: (context, state) => const SettingsPageContent(),
  ),
  AdminMenuItem(
    title: 'App Settings',
    selectedicon: Icons.tune,
    route: '/settings',
    // Ссылается на тот же роут, что и в основном меню
    pageBuilder: (context, state) =>
        const SettingsPageContent(), // Используем тот же билдер
  ),
  AdminMenuItem(
    title: 'Logout', selectedicon: Icons.logout, route: '/logout',
    pageBuilder: (context, state) =>
        const Center(child: Text("Logging out...")), // Пример страницы выхода
  ),
];

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  // --- Тема (можно вынести в отдельный файл) ---
  static const MaterialColor themePrimaryColor = Colors.indigo; // Пример

  // --- Логика для GoRouter ---

  // Все элементы, которые должны иметь роут внутри StatefulShellRoute
  // Это все элементы из _appMenuItems, у которых есть pageBuilder или дети с pageBuilder
  // (чтобы обеспечить навигацию к ним через Drawer, даже если их нет в BottomNav)
  final List<AdminMenuItem> _shellRouteItems =
      collectAllPageItems(_appMenuItems);
  late final GoRouter _router = GoRouter(
    initialLocation: '/',
    //debugLogDiagnostics: true,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (BuildContext context, GoRouterState state,
            StatefulNavigationShell navigationShell) {
          String appBarTitle = 'Admin Panel';
          // Логика для определения заголовка AppBar
          try {
            final String currentLocation = state.matchedLocation;
            AdminMenuItem? findActiveTitleItem(
                List<AdminMenuItem> items, String path) {
              AdminMenuItem? found;
              for (var item in items) {
                if (item.route == path ||
                    (item.pathtomenu.isNotEmpty &&
                        path.startsWith(item.pathtomenu))) {
                  found = item; // Нашли подходящий
                  // Если это прямой роут, он лучше, чем pathtomenu
                  if (item.route == path) break;
                }
                if (item.children.isNotEmpty) {
                  var childFound = findActiveTitleItem(item.children, path);
                  if (childFound != null) {
                    // Если у ребенка более точное совпадение (прямой route), используем его
                    if (childFound.route == path ||
                        found == null ||
                        (found.route != path &&
                            childFound.pathtomenu.length >
                                found.pathtomenu.length)) {
                      found = childFound;
                      if (childFound.route == path) break;
                    }
                  }
                }
              }
              return found;
            }

            final activeItem =
                findActiveTitleItem(_appMenuItems, currentLocation);
            if (activeItem != null) {
              appBarTitle = activeItem.displayNameForSideBar; // Или title
            }
          } catch (e) {
            //print("Error determining AppBar title: $e");
          }

          return AdminScaffold(
            items: _appMenuItems,
            // Передаем ВСЕ элементы меню
            navigationShell: navigationShell,
            selectedRoute: state.matchedLocation,
            // "Чистый" путь для подсветки
            onItemSelected: (item) {
              GoRouter.of(context).go(item.route!);
            },
            appBar: AppBar(
              title: Text(appBarTitle),
              actions: [
                PopupMenuButton<AdminMenuItem>(
                  icon: const Icon(Icons.account_circle),
                  itemBuilder: (context) {
                    return _profileMenuItems.map((AdminMenuItem item) {
                      return PopupMenuItem<AdminMenuItem>(
                        value: item,
                        child: Row(
                          children: [
                            if (item.selectedicon != null)
                              Icon(item.selectedicon, color: Colors.black87),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(item.title,
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.black87)),
                            ),
                          ],
                        ),
                      );
                    }).toList();
                  },
                  onSelected: (item) {
                    _appMenuItems
                        .firstWhere(
                            (a) => a.route == item.route && a.route != null)
                        .badgetext = "";
                    // if (item.route != null) {
                    //   if (item.route == '/logout') {
                    //     //print('Logout action'); // TODO: Implement logout
                    //     // context.go('/login'); // Пример перехода после логаута
                    //   } else {
                    //     GoRouter.of(context).go(item.route!);
                    //   }
                    // }
                  },
                ),
              ],
            ),
            body: navigationShell,
            // Контент для табов/страниц внутри Shell

            // Кастомизация внешнего вида
            backgroundColor: Colors.grey[100],
            sideBarHeader: Container(
                height: 60,
                width: double.infinity,
                color: themePrimaryColor.shade700,
                child: const Center(
                    child: Text('MY APP',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)))),
            sideBarFooter: Container(
                height: 40,
                width: double.infinity,
                color: Colors.black54,
                child: const Center(
                    child: Text('v1.0.0',
                        style:
                            TextStyle(color: Colors.white70, fontSize: 12)))),

            // Настройки PersistentBottomNavBar
            navBarStyle: "Style 1",
            // Выбери свой стиль
            bottomNavActiveColor: themePrimaryColor,
            bottomNavInactiveColor: Colors.grey,
            bottomNavBackgroundColor: Colors.white,
          );
        },
        // Генерируем ветки для StatefulShellRoute на основе _shellRouteItems
        // Это все страницы, доступные внутри AdminScaffold (включая DesktopOnly)
        branches: generateShellBranchesFromAdminMenuItems(_shellRouteItems),
      ),

      // Роуты, которые НЕ являются частью AdminScaffold (например, страница логина)
      // GoRoute(path: '/login', builder: (context, state) => LoginPage()),

      // Роут для /logout (если он не обрабатывается внутри shell, а как отдельная страница)
      // Если pageBuilder для /logout в _profileMenuItems уже есть, этот GoRoute может быть избыточным,
      // если _profileMenuItems также передаются в generateRoutesFromAdminMenuItems для "внешних" роутов.
      // Для простоты, если /logout - это просто выход без UI, он может быть обработан в onSelected.
      // Если это страница, то она должна быть здесь или сгенерирована.
      // Если /logout из _profileMenuItems должен быть частью основного AdminScaffold, то его надо добавить в _shellRouteItems.
      // Предположим, /logout - это отдельная страница.
      GoRoute(
          path: '/logout',
          // Убедись, что pageBuilder для этого роута есть в _profileMenuItems
          builder: (context, state) {
            final logoutItem = _profileMenuItems.firstWhere(
                (item) => item.route == '/logout',
                orElse: () => AdminMenuItem(
                    title: 'Error',
                    pageBuilder: (c, s) =>
                        Center(child: Text("Logout page not found"))));
            return logoutItem.pageBuilder!(context, state);
          }),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Ошибка')),
      body: Center(child: Text('Страница не найдена: ${state.uri}')),
    ),
  );

  @override
  Widget build(BuildContext context) {
    //print(_appMenuItems.where((item) => _hasPageRoute(item)).toList());
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Admin Scaffold Example',
      theme: ThemeData(
        primarySwatch: themePrimaryColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: AppBarTheme(
          backgroundColor: themePrimaryColor.shade600,
          foregroundColor: Colors.white,
        ),
        // Можно добавить другие настройки темы
      ),
      routerConfig: _router,
    );
  }
}
