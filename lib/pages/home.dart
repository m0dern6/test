import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:widget_mask/widget_mask.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Widget build(BuildContext context) {
    double _fontSize = 58;
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Hi ',
                    style: TextStyle(
                      fontSize: _fontSize,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  Lottie.asset(
                    width: 60,
                    height: 80,
                    'assets/wave.json',
                  ),
                  Text(
                    ',',
                    style: TextStyle(
                      fontSize: _fontSize,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    'My name is ',
                    style: TextStyle(
                      fontSize: _fontSize,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(colors: [
                      Colors.blue,
                      Colors.green,
                    ], begin: Alignment.topLeft, end: Alignment.bottomRight)
                        .createShader(bounds),
                    child: Text(
                      'Nabin Adhikari',
                      style: TextStyle(
                        fontSize: _fontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
              Text(
                'I am a ',
                style: TextStyle(
                  fontSize: _fontSize,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              Text(
                'Flutter Developer',
                style: TextStyle(
                  color: Colors.lightBlue,
                  fontSize: _fontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          )),
          WidgetMask(
            blendMode: BlendMode.srcATop,
            childSaveLayer: true,
            mask: Image.asset(
              'assets/profile.png',
            ),
            child: Image.asset(
              'assets/e.png',
            ),
          ),
        ],
      ),
    );
  }
}
