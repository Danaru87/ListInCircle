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

  ListInCircleWidgetState(
      {Key key,
      this.circleDiameter,
      this.selectedItemIndex,
      this.controller,
      this.itemCollection,
      this.onSelectionChanged})
      : super();

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
    print(selectedItemIndex);
    print("Listen Event raised");
    setState(() {
      selectedItemIndex = selectedItemIndex;
    });
  }

  @override
  void initState() {
    super.initState();
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
            decoration: BoxDecoration(color: Colors.white),
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
                          height: circleDiameter / 3,
                          child: Center(
                            child: Text(
                              itemCollection[index],
                              style: TextStyle(
                                  color: (index == selectedItemIndex)
                                      ? Colors.blueAccent
                                      : Colors.black,
                                  fontSize: circleDiameter / 4),
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
