import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignApi {
  static const _clientIDweb =
      "222297719612-fmehgoip8k9g0q9vjq27loccphbr5vnq.apps.googleusercontent.com";
  static final _googleSignIn = GoogleSignIn(clientId: _clientIDweb);

  static Future<GoogleSignInAccount?> login() => _googleSignIn.signIn();
  //silentlogin
  static Future<GoogleSignInAccount?> silentLogin() =>
      _googleSignIn.signInSilently();

  static Future<void> logout() => _googleSignIn.signOut();

  GoogleSignInAccount? get getUser => _googleSignIn.currentUser;
}
