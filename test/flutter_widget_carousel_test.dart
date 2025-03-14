import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_carousel/flutter_widget_carousel.dart';

void main() {
  testWidgets('MarqueeWidget test', (WidgetTester tester) async {
    await tester.pumpWidget(CarouselWidget(
        count: 3,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            width: 100,
            height: 100,
            color: Colors.red,
          );
        }));
  });
}
