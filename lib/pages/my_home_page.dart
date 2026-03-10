import 'package:flutter/material.dart';
import 'package:grocery_flutter/pages/view/grocery_lists/grocery_lists_page.dart';
import 'package:grocery_flutter/pages/view/recipes/recipes_page.dart';
import 'package:grocery_flutter/pages/view/requests/requests_page.dart';
import 'package:grocery_flutter/pages/view/social/social_group_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentIndex = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.question_answer),
            label: 'Requests',
          ),
          NavigationDestination(
            icon: Icon(Icons.list_alt),
            label: 'Grocery list',
          ),
          NavigationDestination(icon: Icon(Icons.book), label: 'Recipes'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Social'),
        ],
        onDestinationSelected: (int index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
      body: switch (currentIndex) {
        0 => const RequestsPage(),
        1 => const ViewGroceryListsPage(),
        2 => const RecipesPage(),
        3 => const SocialGroupPage(),
        _ => const Align(
          alignment: Alignment.center,
          child: Text('What happen??? :<<'),
        ),
      },
    );
  }
}
