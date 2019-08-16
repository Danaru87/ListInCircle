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
  Color selectedItemColor;
  Color unselectedItemColor;
  double defaultFontSize;
  Color circleBackgroundColor;


  ListInCircleWidgetState(
      {Key key,
      this.circleDiameter,
      this.selectedItemIndex,
      this.itemCollection,
      this.onSelectionChanged,
      this.selectedItemColor,
      this.unselectedItemColor, 
      this.defaultFontSize,
      this.circleBackgroundColor})
      : super(){
        if (defaultFontSize == null){
          this.defaultFontSize = circleDiameter / 4;
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
    } else if (controller.offset >= controller.position.maxScrollExtent && !controller.position.outOfRange){
      selectedItemIndex = itemCollection.length - 1;

    } else {
      _keys.forEach((index, key) {
        var itemRect = RectGetter.getRectFromKey(key);
        if(selectedItemIndex != index && _itemIsInSelectionZone(itemRect, index)){
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
  }

  void executePostBackBuild(BuildContext context) {
    getVisible();
    setState(() {
      selectedItemIndex = selectedItemIndex;
    });
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
            child: ListView.builder(
                padding: EdgeInsets.only(
                    top: circleDiameter / 4, bottom: circleDiameter / 2),
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
                            child: AutoSizeText(
                              itemCollection[index],
                              maxLines:2,
                              textAlign: TextAlign.center,
                              stepGranularity: 0.1,
                              style: TextStyle(
                                  color: (index == selectedItemIndex)
                                      ? selectedItemColor
                                      : unselectedItemColor,
                                      fontSize: defaultFontSize
                              ),
                            ),
                          ),
                        ),
                      ));
                }),
          ),
        ),
      ),
    );
  }
}
