import 'package:flutter/material.dart';
import 'package:flutter_widget_carousel/flutter_widget_carousel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Carousel Widget Demo')),
      body: SizedBox(
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
      ),
    );
  }
}
