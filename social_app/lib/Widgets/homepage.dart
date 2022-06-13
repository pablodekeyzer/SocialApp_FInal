import 'package:flutter/material.dart';
import 'package:social_app/Widgets/feed.dart';
import 'package:social_app/constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Dashboard'),
          foregroundColor: wit,
          backgroundColor: darkBlu,
          centerTitle: true,
        ),
        body: Feed(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        extendBody: true,
      ),
    );
  }
}
