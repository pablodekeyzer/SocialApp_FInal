import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:social_app/Services/google_signin.dart';
import 'package:social_app/constants.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GoogleSignInAccount? user;
  Future signIn() async {
    user = await GoogleSignApi.login();
    if (user != null) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  Future signInSilent() async {
    user = await GoogleSignApi.silentLogin();
    if (user != null) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  String createUser = r'''
  mutation createUser($id: String!,$displayname: String!,$img: String) {
    createUser(input: {id: $id, displayname: $displayname, img: $img}) {
      id
    }
  }
''';

  @override
  initState() {
    signInSilent();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
          foregroundColor: wit,
          backgroundColor: darkBlu,
          centerTitle: true,
        ),
        //button to login with google
        body: Center(
          child: Mutation(
              options: MutationOptions(
                document: gql(createUser),
                onCompleted: (dynamic resultData) {},
              ),
              builder: (
                RunMutation runMutation,
                QueryResult? result,
              ) {
                return ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(darkBlu),
                    foregroundColor: MaterialStateProperty.all(wit),
                    textStyle: MaterialStateProperty.all(
                      const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  onPressed: () async {
                    await signIn();
                    runMutation({
                      'id': user?.email,
                      'displayname': user?.displayName,
                      'img': user?.photoUrl
                    });
                  },
                  child: const Text('Login with Google'),
                );
              }),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        extendBody: true,
      ),
    );
  }
}
