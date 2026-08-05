import 'package:flutter/widgets.dart';

enum AppBreakpoint { compact, medium, expanded }

const double _compactMaxWidth = 600;
const double _mediumMaxWidth = 840;

AppBreakpoint breakpointOf(BuildContext context) {
  final double width = MediaQuery.sizeOf(context).width;
  if (width < _compactMaxWidth) {
    return AppBreakpoint.compact;
  }
  if (width < _mediumMaxWidth) {
    return AppBreakpoint.medium;
  }
  return AppBreakpoint.expanded;
}
