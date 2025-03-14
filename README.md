This plugin provides a widget carousel feature, supporting horizontal or vertical scrolling, automatic or manual cycling, and infinite looping.

## Features

- Any widget.
- Infinite looping.
- Auto carousel.

---------

![example](https://github.com/YBill/flutter_widget_carousel/blob/master/screenshot/carousel_widget.gif)

-------



## Usage

##### Use

```dart
    CarouselWidget(
count: 5,
itemBuilder: (context, index) {
return Container(
width: double.infinity,
height: double.infinity,
color: Colors.primaries[2 * index],
child: Center(child: Text('Item $index', style: TextStyle(fontSize: 30, color: Colors.white))),
);
},
)
```



##### 2、Parameter description

| parameter           | type                 | explanation                                                  |
| ------------------- | -------------------- | ------------------------------------------------------------ |
| count               | int                  | Count of carousel items. required parameter                  |
| itemBuilder         | IndexedWidgetBuilder | Used to build child widgets. required parameter              |
| scrollDirection     | Axis                 | Scroll direction, default is Axis.horizontal                 |
| canManualSwitch     | bool                 | Whether manual scrolling is allowed. default is true         |
| autoCarousel        | bool                 | Auto carousel is allowed, default is true                    |
| interruptCarousel   | bool                 | Whether to interrupt the auto carousel after manual scrolling. default is false |
| loop                | bool                 | Whether to enable infinite scrolling. default is true        |
| carouselIntervalMs  | int                  | Auto carousel interval, in milliseconds, default is 5000     |
| animationDurationMs | int                  | Scroll duration, in milliseconds, default is 300             |
| animationCurve      | Curve                | Animation curve, default is Curves.linear                    |
| changedCallback     | ValueChanged<int>    | Carousel item changed callback, default is null              |
| controller          | PageController       | For the PageView's controller: if not provided externally, the system will create one internally |



