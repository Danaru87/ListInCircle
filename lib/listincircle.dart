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

  /// Selected item color
  final Color selectedColor;

  /// Unselected item color
  final Color unSelectedColor;

  /// Circle background color
  final Color circleColor;

  /// Default text font size (will be autmaticaly resized if needed)
  final double defaultFontSize;


  ListInCircleWidget(
      {Key key,
      @required this.circleDiameter,
      this.itemCollection,
      this.onSelectionChanged,
      this.initialSelectedItemIndex,
      this.selectedColor = Colors.blueAccent,
      this.unSelectedColor = Colors.black,
      this.defaultFontSize,
      this.circleColor = Colors.white})
      : super(key: key);


   @override
  State<StatefulWidget> createState() => ListInCircleWidgetState(
      circleDiameter: this.circleDiameter,
      itemCollection: this.itemCollection,
      onSelectionChanged: this.onSelectionChanged,
      selectedItemIndex: this.initialSelectedItemIndex, 
      selectedItemColor: this.selectedColor, 
      unselectedItemColor: this.unSelectedColor, 
      defaultFontSize: this.defaultFontSize);
}


