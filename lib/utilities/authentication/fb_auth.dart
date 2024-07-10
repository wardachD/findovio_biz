/*import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:findovio/models/userInfoDetails.dart';
import 'package:findovio/screens/main_screen.dart';

//test dopier po wrzuceniu do appstore

class fbAuth {
  final FirebaseAuth _fAuth = FirebaseAuth.instance;

  Future<void> signIn(BuildContext context) async {
    final LoginResult loginResult = await FacebookAuth.instance.login();
    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);

    User user =
        (await _fAuth.signInWithCredential(facebookAuthCredential)) as User;

    ProviderDetails userInfo = ProviderDetails(user.uid, user.email!);
    List<ProviderDetails> providerData = <ProviderDetails>[];
    providerData.add(userInfo);

    UserInfoDetails userInfoDetails =
        new UserInfoDetails(user.uid, user.email!, providerData);

    Navigator.push(
      context,
      new MaterialPageRoute(
        builder: (context) => new MainScreen(detailsUser: userInfoDetails),
      ),
    );
  }
}*/
