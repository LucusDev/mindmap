import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class MindMap extends MultiChildRenderObjectWidget {
  MindMap({Key? key}) : super(key: key);

  @override
  MindMapRender createRenderObject(BuildContext context) {
    return MindMapRender();
  }
}

class MindMapParentData extends ContainerBoxParentData<RenderBox> {}

class MindMapRender extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, MindMapParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, MindMapParentData> {
  @override
  void setupParentData(covariant RenderObject child) {
    if (child.parentData is! MindMapParentData) {
      child.parentData = MindMapParentData();
    }
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    return super.computeDryLayout(constraints);
  }

  @override
  void performLayout() {}

  @override
  void paint(PaintingContext context, Offset offset) {
    super.paint(context, offset);
  }
}
