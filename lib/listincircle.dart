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

  /// Your scroll controller (Required)
  final ScrollController controller;

  /// Item string collection to display in the widget
  final List<String> itemCollection;

  /// Closure executed when selection has been changed
  final Function onSelectionChanged;

  ListInCircleWidget(
      {Key key,
      @required this.circleDiameter,
      @required this.controller,
      this.itemCollection,
      this.onSelectionChanged,
      this.initialSelectedItemIndex})
      : super(key: key);


   @override
  State<StatefulWidget> createState() => ListInCircleWidgetState(
      controller: this.controller,
      circleDiameter: this.circleDiameter,
      itemCollection: this.itemCollection,
      onSelectionChanged: this.onSelectionChanged,
      selectedItemIndex: this.initialSelectedItemIndex);
}


