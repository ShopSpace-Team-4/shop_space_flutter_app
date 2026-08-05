import 'package:flutter/material.dart';

import 'window_size.dart';

/// Hand-rolled adaptive app shell (decision D1).
///
/// Renders a bottom [NavigationBar] on compact widths and a side
/// [NavigationRail] (extended on expanded widths) on medium/expanded widths.
/// Keeps the selected destination and content subtree alive across breakpoint
/// changes so state survives resize/rotation.
class AppAdaptiveShell extends StatefulWidget {
  const AppAdaptiveShell({
    super.key,
    required this.destinations,
    this.body,
    this.initialIndex = 0,
  });

  /// The navigation destinations rendered by the shell.
  ///
  /// In Phase 0 this is the static placeholder list; in later phases the
  /// destination set is derived from the user's roles.
  final List<NavigationDestination> destinations;

  /// The content pane rendered inside the shell.
  final Widget? body;

  /// The initially selected destination index.
  final int initialIndex;

  @override
  State<AppAdaptiveShell> createState() => _AppAdaptiveShellState();
}

class _AppAdaptiveShellState extends State<AppAdaptiveShell> {
  late int _selectedIndex = widget.destinations.isEmpty
      ? 0
      : widget.initialIndex.clamp(0, widget.destinations.length - 1);

  @override
  Widget build(BuildContext context) {
    if (widget.destinations.isEmpty) {
      return Scaffold(body: widget.body ?? const SizedBox.shrink());
    }

    switch (breakpointOf(context)) {
      case AppBreakpoint.compact:
        return Scaffold(
          body: widget.body ?? const SizedBox.shrink(),
          bottomNavigationBar: NavigationBar(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) {
              setState(() => _selectedIndex = index);
            },
            destinations: widget.destinations,
          ),
        );
      case AppBreakpoint.medium:
      case AppBreakpoint.expanded:
        final bool extended = breakpointOf(context) == AppBreakpoint.expanded;
        return Scaffold(
          body: Row(
            children: [
              NavigationRail(
                selectedIndex: _selectedIndex,
                extended: extended,
                onDestinationSelected: (index) {
                  setState(() => _selectedIndex = index);
                },
                destinations: [
                  for (final destination in widget.destinations)
                    NavigationRailDestination(
                      icon: destination.icon,
                      selectedIcon: destination.selectedIcon,
                      label: Text(destination.label),
                    ),
                ],
              ),
              const VerticalDivider(width: 1, thickness: 1),
              Expanded(child: widget.body ?? const SizedBox.shrink()),
            ],
          ),
        );
    }
  }
}
