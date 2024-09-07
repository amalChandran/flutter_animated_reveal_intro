import 'package:flutter/material.dart';
import 'package:flutter_animated_reveal_intro/intro.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: IntroScreen1(appTitle: 'My App', items: [
        IntroItem(
          icon: Icons.rocket_launch,
          description: 'Blast off into awesomeness!',
          backgroundColor: Color.fromARGB(255, 8, 49, 232),
          textColor: Colors.white,
        ),
        IntroItem(
          icon: Icons.emoji_nature,
          description: 'Unleash your inner unicorn',
          backgroundColor: Colors.pink,
          textColor: Colors.black,
        ),
        IntroItem(
          icon: Icons.brightness_7,
          description: 'Get ready to shine bright',
          backgroundColor: const Color.fromARGB(255, 2, 2, 2),
          textColor: Colors.white,
        ),
        IntroItem(
          icon: Icons.auto_awesome,
          description: 'Become the hero of your story',
          backgroundColor: Color(0xFFFFE5B4),
          textColor: Colors.black,
        ),
        IntroItem(
          icon: Icons.auto_fix_high,
          description: 'Abracadabra! Magic awaits',
          backgroundColor: Colors.orange,
          textColor: Colors.white,
        ),
      ]),
    );
  }
}
