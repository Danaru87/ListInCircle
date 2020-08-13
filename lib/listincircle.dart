library listincircle;

import 'package:flutter/material.dart';

import 'listincirlce_state.dart';

/// A list in a circle with position selection.
class ListInCircleWidget extends StatefulWidget {
  /// Diameter size of the circular widget (Required)
  final double circleDiameter;

  /// First selected item index,
  /// used as initial state value,
  /// if null => value set to 0
  final int initialSelectedItemIndex;

  /// Item string collection to display in the widget
  final List<String> itemCollection;

  /// Closure executed when selection has been changed
  final ValueChanged<int> onSelectionChanged;

  /// Closure executed when scroll action ended;
  final Function onScrollEnded;

  /// Selected item text style
  final TextStyle selectedTextStyle;

  /// Default selected item text style
  static const TextStyle DEFAULT_SELECTED_TEXT_STYLE =
      TextStyle(color: Colors.blueAccent, fontSize: 50.0);

  /// Unselected item text style
  final TextStyle unSelectedTextStyle;

  /// Default unselected item text style
  static const TextStyle DEFAULT_UNSELECTED_TEXT_STYLE =
      TextStyle(color: Colors.black, fontSize: 50.0);

  /// Circle background color
  final Color circleColor;

  ListInCircleWidget(
      {Key key,
      @required this.circleDiameter,
      @required this.itemCollection,
      this.onSelectionChanged,
      this.onScrollEnded,
      this.initialSelectedItemIndex,
      this.selectedTextStyle = DEFAULT_SELECTED_TEXT_STYLE,
      this.unSelectedTextStyle = DEFAULT_UNSELECTED_TEXT_STYLE,
      this.circleColor = Colors.white})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => ListInCircleWidgetState(
      circleDiameter: circleDiameter,
      unSelectedTextStyle: unSelectedTextStyle,
      selectedTextStyle: selectedTextStyle);
}
