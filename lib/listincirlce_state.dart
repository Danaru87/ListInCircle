import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import 'listincircle.dart';
import 'scrollphysics/item_centered_physics.dart';

class ListInCircleWidgetState extends State<ListInCircleWidget> {
  ScrollController controller;

  int selectedItemIndex = 10;
  TextStyle selectedTextStyle;
  TextStyle unSelectedTextStyle;
  final double circleDiameter;
  final itemHeight;

  @override
  void initState() {
    super.initState();
    controller = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      double position = itemHeight * selectedItemIndex;
      controller.animateTo(position,
          duration: const Duration(seconds: 1), curve: Curves.easeInOut);
    });
  }

  ListInCircleWidgetState(
      {Key key,
      @required this.circleDiameter,
      @required this.selectedTextStyle,
      @required this.unSelectedTextStyle})
      : this.itemHeight = circleDiameter / 3 {
    double maxFontSize = this.circleDiameter / 4;
    this.selectedTextStyle =
        this._adjustFontSize(maxFontSize, selectedTextStyle);
    this.unSelectedTextStyle =
        this._adjustFontSize(maxFontSize, unSelectedTextStyle);
  }

  TextStyle _adjustFontSize(double maxFontSize, TextStyle textStyle) {
    double fontSizeDelta = maxFontSize - textStyle.fontSize;
    if (fontSizeDelta < 0) {
      return textStyle.apply(fontSizeDelta: fontSizeDelta);
    } else {
      return textStyle;
    }
  }

  _scrollEnded() {
    widget.onScrollEnded?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipOval(
        child: Container(
          width: widget.circleDiameter,
          height: widget.circleDiameter,
          decoration: BoxDecoration(color: widget.circleColor),
          child: NotificationListener<ScrollEndNotification>(
              onNotification: (_) => _scrollEnded(),
              child: ListView.builder(
                  physics: ItemCenteredScrollPhysics(
                      itemsSize: itemHeight,
                      centerItemChanged: (int newSelectedItemIndex) {
                        setState(() {
                          selectedItemIndex = newSelectedItemIndex;
                        });
                        widget.onSelectionChanged(newSelectedItemIndex);
                      },
                      minSelectableItem: 0,
                      maxSelectableItem: widget.itemCollection.length - 1),
                  itemExtent: itemHeight,
                  padding: EdgeInsets.only(top: itemHeight, bottom: itemHeight),
                  controller: controller,
                  itemCount: widget.itemCollection.length,
                  itemBuilder: (BuildContext context, int index) => Center(
                        child: Container(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          height: itemHeight,
                          child: Center(
                            child: AutoSizeText(widget.itemCollection[index],
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                stepGranularity: 0.1,
                                style: (index == selectedItemIndex)
                                    ? selectedTextStyle
                                    : unSelectedTextStyle),
                          ),
                        ),
                      ))),
        ),
      ),
    );
  }
}
