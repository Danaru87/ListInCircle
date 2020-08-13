import 'dart:math' as Math;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ItemCenteredSimulation extends Simulation {
  final double velocity;
  final Tween<double> positionAnimation;
  final double scrollDuration;
  final ValueChanged<int> centerItemChanged;
  final int minSelectableItem;
  final int maxSelectableItem;
  final double viewSize;
  final double itemsSize;

  int currentItem;

  ItemCenteredSimulation(
      {@required double initPosition,
      @required double destinationPosition,
      @required this.viewSize,
      @required this.itemsSize,
      @required this.velocity,
      @required this.scrollDuration,
      @required this.centerItemChanged,
      this.minSelectableItem,
      this.maxSelectableItem})
      : this.positionAnimation =
            Tween(begin: initPosition, end: destinationPosition) {
    currentItem = centeredItem(initPosition);
    centerItemChanged?.call(currentItem);
  }

  factory ItemCenteredSimulation.build(
      {double minDuration = 0.2,
      @required double viewSize,
      @required double antiAcceleration,
      @required double velocity,
      @required double initPosition,
      @required double itemsSize,
      int minSelectableItem,
      int maxSelectableItem,
      ValueChanged<int> centerItemChanged}) {
    double scrollDuration =
        Math.max(minDuration, (velocity / antiAcceleration).abs());

    final rawDestinationPosition = initPosition + velocity * scrollDuration;
    final offset = ItemCenteredSimulation._scrollOffset(
        viewSize: viewSize, itemsSize: itemsSize);
    final destinationItem = ItemCenteredSimulation._centeredItem(
        scrollOffset: offset,
        scrollPosition: rawDestinationPosition,
        viewSize: viewSize,
        itemsSize: itemsSize,
        minSelectableItem: minSelectableItem,
        maxSelectableItem: maxSelectableItem);
    final destinationPosition =
        (destinationItem * itemsSize - offset).roundToDouble();

    if (destinationPosition == initPosition) {
      return null;
    }
    return ItemCenteredSimulation(
      velocity: velocity,
      initPosition: initPosition,
      destinationPosition: destinationPosition,
      scrollDuration: scrollDuration,
      centerItemChanged: centerItemChanged,
      viewSize: viewSize,
      itemsSize: itemsSize,
      minSelectableItem: minSelectableItem,
      maxSelectableItem: maxSelectableItem,
    );
  }

  static double _scrollOffset({double viewSize, double itemsSize}) =>
      ((viewSize % itemsSize) / 2.0 - itemsSize / 2.0).roundToDouble();

  static int _centeredItem(
      {@required double scrollOffset,
      @required double scrollPosition,
      @required double viewSize,
      @required double itemsSize,
      int minSelectableItem,
      int maxSelectableItem}) {
    int destinationItem = ((scrollPosition + scrollOffset) / itemsSize).round();
    if (minSelectableItem != null)
      destinationItem = Math.max(destinationItem, minSelectableItem);
    if (maxSelectableItem != null)
      destinationItem = Math.min(destinationItem, maxSelectableItem);

    return destinationItem;
  }

  int centeredItem(double scrollPosition) =>
      ItemCenteredSimulation._centeredItem(
          scrollOffset: ItemCenteredSimulation._scrollOffset(
              viewSize: viewSize, itemsSize: itemsSize),
          scrollPosition: scrollPosition,
          viewSize: viewSize,
          itemsSize: itemsSize,
          minSelectableItem: minSelectableItem,
          maxSelectableItem: maxSelectableItem);

  @override
  double dx(double time) {
    return velocity;
  }

  @override
  bool isDone(double time) {
    return time >= scrollDuration;
  }

  void updateCurrentItem(double newPosition) {
    if (centerItemChanged != null) {
      int newCurrentItem = centeredItem(newPosition);
      if (newCurrentItem != currentItem) {
        currentItem = newCurrentItem;
        centerItemChanged(currentItem);
      }
    }
  }

  double position(double time) {
    final progress = CurveTween(curve: Curves.decelerate)
        .transform((time / scrollDuration).clamp(0.0, 1.0));
    return positionAnimation.transform(progress);
  }

  @override
  double x(double time) {
    final newPosition = position(time);

    updateCurrentItem(newPosition);

    return newPosition;
  }
}

class ItemCenteredScrollPhysics extends ScrollPhysics {
  final double itemsSize;
  final ValueChanged<int> centerItemChanged;
  final int minSelectableItem;
  final int maxSelectableItem;
  ItemCenteredScrollPhysics(
      {@required this.itemsSize,
      this.centerItemChanged,
      this.minSelectableItem,
      this.maxSelectableItem});

  @override
  Simulation createBallisticSimulation(
      ScrollMetrics position, double velocity) {
    return ItemCenteredSimulation.build(
        initPosition: position.pixels,
        viewSize: position.viewportDimension,
        velocity: velocity,
        antiAcceleration: 20000.0,
        itemsSize: this.itemsSize,
        minSelectableItem: minSelectableItem,
        maxSelectableItem: maxSelectableItem,
        centerItemChanged: centerItemChanged);
  }

  @override
  ScrollPhysics applyTo(ScrollPhysics ancestor) {
    return ItemCenteredScrollPhysics(
        itemsSize: this.itemsSize,
        centerItemChanged: centerItemChanged,
        minSelectableItem: minSelectableItem,
        maxSelectableItem: maxSelectableItem);
  }
}
