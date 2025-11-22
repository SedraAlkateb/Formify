import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:formify/presentation/resources/them_manager.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (lightDynamic, darkDynamic) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: getApplicationTheme(lightDynamic, isLight: true),
          darkTheme: getApplicationTheme(darkDynamic, isLight: false),
          themeMode: ThemeMode.system,
          home: const HomePage(),
        );
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        title: Text("Dynamic Color Example"),
        backgroundColor: colorScheme.primary,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: colorScheme.secondary,
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
