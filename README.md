This plugin provides a widget carousel feature, supporting horizontal or vertical scrolling, automatic or manual cycling, and infinite looping.

## Features

- Any widget.
- Infinite looping.
- Auto carousel.

## Getting started

TODO: List prerequisites and provide or point to information on how to
start using the package.

## Usage

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
