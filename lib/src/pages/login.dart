import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';

class Login extends StatelessWidget {
  const Login({Key key}) : super(key: key);

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<UserCredential> signInWithKakao() async {
    final clientState = Uuid().v4();
    final url = Uri.https('kauth.kakao.com', '/oauth/authorize', {
      'response_type': 'code',
      'client_id': '75be45c34d7befda1bd48e88afe5fe44',
      // 'redirect_uri': 'http://192.168.158.217:8080/kakao/sign_in',
      // 'redirect_uri': 'http://192.168.0.6:8080/kakao/sign_in',
      'redirect_uri': 'http://192.168.26.217:8080/kakao/sign_in',
      'state': clientState,
    });

    final result = await FlutterWebAuth.authenticate(
        url: url.toString(), callbackUrlScheme: "webauthcallback");

    final params = Uri.parse(result).queryParameters;
    print(params['customToken']);

    return FirebaseAuth.instance.signInWithCustomToken(params['customToken']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SNS Login"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              child: Text("Google Login"),
              onPressed: signInWithGoogle,
            ),
            TextButton(
              child: Text("KaKao Login"),
              onPressed: signInWithKakao,
            ),
          ],
        ),
      ),
    );
  }
}
