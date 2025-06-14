import 'package:flutter/material.dart';

import 'admin_menu_item.dart';

class SideBarItem extends StatelessWidget {
  const SideBarItem({
    required this.items,
    required this.index,
    this.onSelected,
    required this.selectedRoute,
    this.depth = 0,
    this.iconColor,
    this.activeIconColor,
    required this.textStyle,
    required this.activeTextStyle,
    required this.backgroundColor,
    required this.activeBackgroundColor,
    required this.borderColor,
  });

  final List<AdminMenuItem> items;
  final int index;
  final void Function(AdminMenuItem item)? onSelected;
  final String selectedRoute;
  final int depth;
  final Color? iconColor;
  final Color? activeIconColor;
  final TextStyle textStyle;
  final TextStyle activeTextStyle;
  final Color backgroundColor;
  final Color activeBackgroundColor;
  final Color borderColor;
  bool get isLast => index == items.length - 1;

  @override
  Widget build(BuildContext context) {
    if (depth > 0 && isLast) {
      return _buildTiles(context, items[index]);
    }
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: borderColor,
          ),
        ),
      ),
      child: _buildTiles(context, items[index]),
    );
  }

  Widget _buildTiles(BuildContext context, AdminMenuItem item) {
    bool selected = _isSelected(selectedRoute, [item]);

    if (item.children.isEmpty) {
      return ListTile(
        contentPadding: _getTilePadding(depth),
        leading: _buildIcon(item.selectedicon, selected),
        title: _buildTitle(item.title, selected),
        selected: selected,
        tileColor: backgroundColor,
        selectedTileColor: activeBackgroundColor,
        onTap: () {
          if (onSelected != null) {
            onSelected!(item);
          }
        },
      );
    }

    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        key: PageStorageKey<AdminMenuItem>(item),
        tilePadding: _getTilePadding(depth),
        leading: _buildIcon(item.selectedicon, selected),
        title: _buildTitle(item.title, selected),
        initiallyExpanded: selected,
        onExpansionChanged: (bool expanding) {
          // setState(() {
          //   // можно сохранять состояние раскрытия, если нужно
          // });
        },
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: item.children.length,
            itemBuilder: (context, idx) {
              return SideBarItem(
                items: item.children,
                index: idx,
                onSelected: onSelected,
                selectedRoute: selectedRoute,
                depth: depth + 1,
                iconColor: iconColor,
                activeIconColor: activeIconColor,
                textStyle: textStyle,
                activeTextStyle: activeTextStyle,
                backgroundColor: backgroundColor,
                activeBackgroundColor: activeBackgroundColor,
                borderColor: borderColor,
              );
            },
          ),
        ],
      ),
    );
  }

  bool _isSelected(String route, List<AdminMenuItem> items) {
    for (final item in items) {
      if (item.pathtomenu == route) {
        return true;
      }
      if (item.children.isNotEmpty) {
        return _isSelected(route, item.children);
      }
    }
    return false;
  }

  Widget _buildIcon(IconData? icon, [bool selected = false]) {
    return icon != null
        ? Icon(
            icon,
            size: 22,
            color: selected
                ? activeIconColor ?? activeTextStyle.color
                : iconColor ?? textStyle.color,
          )
        : SizedBox();
  }

  Widget _buildTitle(String title, [bool selected = false]) {
    return Text(
      title,
      style: selected ? activeTextStyle : textStyle,
    );
  }

  EdgeInsets _getTilePadding(int depth) {
    return EdgeInsets.only(
      left: 10.0 + 10.0 * depth,
      right: 10.0,
    );
  }
}
