import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:social_app/Widgets/homepage.dart';
import 'package:social_app/Widgets/login.dart';
import 'package:social_app/constants.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

void main() async {
  await initHiveForFlutter();
  final HttpLink httpLink = HttpLink(
    'https://qraph-ql-server.herokuapp.com/',
  );

  ValueNotifier<GraphQLClient> client = ValueNotifier(
    GraphQLClient(
      link: httpLink,
      cache: GraphQLCache(store: HiveStore()),
    ),
  );
  runApp(MyApp(client: client));
}

class MyApp extends StatelessWidget {
  final ValueNotifier<GraphQLClient> client;
  const MyApp({Key? key, required this.client}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: client,
      child: MaterialApp(
          title: 'SocialApp',
          theme:
              ThemeData(primaryColor: lightGrey, scaffoldBackgroundColor: wit),
          initialRoute: '/login',
          onGenerateRoute: (settings) {
            switch (settings.name) {
              case '/home':
                return PageTransition(
                  child: const HomePage(),
                  type: PageTransitionType.fade,
                  duration: const Duration(milliseconds: 20),
                );
              case '/login':
                return PageTransition(
                  child: const LoginPage(),
                  type: PageTransitionType.fade,
                  duration: const Duration(milliseconds: 20),
                );
            }
            return null;
          }),
    );
  }
}
