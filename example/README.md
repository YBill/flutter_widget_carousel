# example

A example of using flutter_widget_carousel package.

## Getting Started

```dart
    @override
    Widget build(BuildContext context) {
      return SizedBox(
        height: 300,
        child: CarouselWidget(
          count: 5,
          itemBuilder: (context, index) {
            return Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.primaries[2 * index],
              child: Center(child: Text('Item $index', style: TextStyle(fontSize: 30, color: Colors.white))),
            );
          },
        ),
      );
    }
```