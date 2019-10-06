import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:rect_getter/rect_getter.dart';

import '../listincircle.dart';

class ListInCircleWidgetState extends State<ListInCircleWidget> {
  int selectedItemIndex;
  double circleDiameter;
  GlobalKey listViewKey = RectGetter.createGlobalKey();
  ScrollController controller;
  List<String> itemCollection;
  var _keys = {};
  Function onSelectionChanged;
  TextStyle selectedTextStyle;
  TextStyle unSelectedTextStyle;
  Color circleBackgroundColor;
  bool isAutoMove = false;

  ListInCircleWidgetState(
      {Key key,
      this.circleDiameter,
      this.selectedItemIndex,
      this.itemCollection,
      this.onSelectionChanged,
      this.selectedTextStyle,
      this.unSelectedTextStyle,
      this.circleBackgroundColor})
      : super() {
    double maxFontSize = circleDiameter / 4;
    this.selectedTextStyle =
        this._adjustFontSize(maxFontSize, this.selectedTextStyle);
    this.unSelectedTextStyle =
        this._adjustFontSize(maxFontSize, this.unSelectedTextStyle);
  }

  TextStyle _adjustFontSize(double maxFontSize, TextStyle textStyle) {
    double fontSizeDelta = maxFontSize - textStyle.fontSize;
    if (fontSizeDelta < 0) {
      return textStyle.apply(fontSizeDelta: fontSizeDelta);
    } else {
      return textStyle;
    }
  }

  bool _itemIsInSelectionZone(Rect itemRect, index) {
    var rect = RectGetter.getRectFromKey(listViewKey);
    var itemRectCenterFromTop;
    if (itemRect != null) {
      itemRectCenterFromTop = itemRect.top + (itemRect.size.height / 2);
    }
    var topZoneLimitTop = rect.top + (circleDiameter / 3);

    var botZoneLimitTop = rect.bottom - (circleDiameter / 3);

    if (itemRect == null) {
    } else if (itemRectCenterFromTop > (topZoneLimitTop) &&
        itemRectCenterFromTop < (botZoneLimitTop)) {
      return true;
    }
    return false;
  }

  void getVisible() {
    if (controller.offset <= controller.position.minScrollExtent &&
        !controller.position.outOfRange) {
      selectedItemIndex = 0;
      return;
    } else if (controller.offset >= controller.position.maxScrollExtent &&
        !controller.position.outOfRange) {
      selectedItemIndex = itemCollection.length - 1;
    } else {
      _keys.forEach((index, key) {
        var itemRect = RectGetter.getRectFromKey(key);
        if (selectedItemIndex != index &&
            _itemIsInSelectionZone(itemRect, index)) {
          selectedItemIndex = index;
          onSelectionChanged(selectedItemIndex);
        }
      });
    }
  }

  _scrollListener() {
    getVisible();
    setState(() {
      selectedItemIndex = selectedItemIndex;
    });
  }

  @override
  void initState() {
    super.initState();
    controller = ScrollController();
    controller.addListener(_scrollListener);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      double position = circleDiameter / 3 * selectedItemIndex;
      controller.animateTo(position,
          duration: const Duration(seconds: 1), curve: Curves.easeInOut);
    });
  }

  void executePostBackBuild(BuildContext context) {
    getVisible();
    setState(() {
      selectedItemIndex = selectedItemIndex;
    });
  }
  _scrollStarted(){
    print("Scroll started");
  }

  _scrollEnded(){
    print("Scroll has stop at $selectedItemIndex");
    if (!isAutoMove){
      isAutoMove = true;
      double position = circleDiameter / 3 * selectedItemIndex;
      controller.jumpTo(position);
      isAutoMove = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => executePostBackBuild(context));

    return Center(
      child: ClipOval(
        child: RectGetter(
          key: listViewKey,
          child: Container(
            width: circleDiameter,
            height: circleDiameter,
            decoration: BoxDecoration(color: circleBackgroundColor),
            child: NotificationListener<ScrollStartNotification>(
              onNotification: (_) => _scrollStarted(),
              child:NotificationListener<ScrollEndNotification>(
                onNotification: (_) => _scrollEnded(),
                child:ListView.builder(
                padding: EdgeInsets.only(
                    top: circleDiameter / 3, bottom: circleDiameter / 3),
                controller: controller,
                itemCount: itemCollection.length,
                itemBuilder: (BuildContext context, int index) {
                  var itemKey = RectGetter.createGlobalKey();
                  _keys[index] = itemKey;
                  return RectGetter(
                    key: _keys[index],
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        height: circleDiameter / 3,
                        child: Center(
                          child: AutoSizeText(itemCollection[index],
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              stepGranularity: 0.1,
                              style: (index == selectedItemIndex)
                                  ? selectedTextStyle
                                  : unSelectedTextStyle),
                        ),
                      ),
                    ),
                  );
                })
              )
            ),
          ),
        ),
      ),
    );
  }
}
