import 'package:flutter/material.dart';
import 'package:social_app/Widgets/feed.dart';
import 'package:social_app/constants.dart';

class ProfilePage extends StatefulWidget {
  String userid;
  ProfilePage({Key? key, required this.userid}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
          foregroundColor: wit,
          backgroundColor: darkBlu,
          centerTitle: true,
        ),
        body: Feed(userId: widget.userid),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        extendBody: true,
      ),
    );
  }
}
