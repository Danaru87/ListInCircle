library listincircle;

import 'package:flutter/material.dart';

import 'src/listincirlce_state.dart';

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
  final Function onSelectionChanged;

  /// Closure executed when scroll action ended;
  final Function onScrollEnded;

  /// Selected item text style
  final TextStyle selectedTextStyle;

  /// Default selected item text style
  static const TextStyle DEFAULT_SELECTED_TEXT_STYLE = TextStyle(color: Colors.blueAccent);

  /// Unselected item text style
  final TextStyle unSelectedTextStyle;

  /// Default unselected item text style
  static const TextStyle DEFAULT_UNSELECTED_TEXT_STYLE = TextStyle(color: Colors.black);

  /// Circle background color
  final Color circleColor;

  ListInCircleWidget(
      {Key key,
      @required this.circleDiameter,
      this.itemCollection,
      this.onSelectionChanged,
      this.onScrollEnded,
      this.initialSelectedItemIndex,
      this.selectedTextStyle = DEFAULT_SELECTED_TEXT_STYLE,
      this.unSelectedTextStyle = DEFAULT_UNSELECTED_TEXT_STYLE,
      this.circleColor = Colors.white})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => ListInCircleWidgetState(
      circleDiameter: this.circleDiameter,
      itemCollection: this.itemCollection,
      onSelectionChanged: this.onSelectionChanged,
      onScrollEnded: this.onScrollEnded,
      selectedItemIndex: this.initialSelectedItemIndex,
      selectedTextStyle: this.selectedTextStyle,
      unSelectedTextStyle: this.unSelectedTextStyle,
      circleBackgroundColor: this.circleColor);
}
