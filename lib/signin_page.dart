import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_builder.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'home_page.dart';

final Color primaryColor = Color(0xff18203d);
final Color secondaryColor = Color(0xff232c51);
final Color logoGreen = Color(0xff25bcbb);

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: secondaryColor,
        title: Text("Giriş Yap"),
      ),
      body: _SignInBody(),
    );
  }
}

class _SignInBody extends StatefulWidget {
  @override
  __SignInBodyState createState() => __SignInBodyState();
}

class __SignInBodyState extends State<_SignInBody> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          Container(
            height: 165,
          ),
          Container(
            alignment: Alignment.center,
            child:
            _EmailPasswordForm(),
          ),
          //? Email / Şifre ile giriş

        ],
      ),
    );
  }

  _singInWithGoogle() async {
    try{
      final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final GoogleAuthCredential googleCredential = GoogleAuthProvider.credential(accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

      final UserCredential userCredential = await _auth.signInWithCredential(googleCredential);
      final User user = userCredential.user;
      Scaffold.of(context).showSnackBar(SnackBar(content: Text("Welcome, ${user.displayName}")));
    } on FirebaseAuthException catch (e){
      Scaffold.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    } catch (e){
      print(e.toString());
    }
  }

  _signInAnonymously() async {
    await _auth.signInAnonymously();
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
  }

}

class _EmailPasswordForm extends StatefulWidget {
  @override
  __EmailPasswordFormState createState() => __EmailPasswordFormState();
}

class __EmailPasswordFormState extends State<_EmailPasswordForm> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Form(
        key: _formKey,
        child: Card(
          color: secondaryColor,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //? Bilgi
                Container(
                  alignment: Alignment.center,
                ),
                //? E-Mail
                TextFormField(
                  style: TextStyle(color: Colors.white),
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: "E-Mail",labelStyle: TextStyle(color: Colors.white)),
                  validator: (String mail) {
                    if (mail.trim().isEmpty) return "Lütfen bir mail yazın";
                    return null;
                  },
                ),
                //? Şifre
                TextFormField(
                  style: TextStyle(color: Colors.white),
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: "Şifre",labelStyle: TextStyle(color: Colors.white)),
                  validator: (String password) {
                    if (password.isEmpty) return "Lütfen bir şifre yazın";
                    return null;
                  },
                  obscureText: true, //! Şifrenin görünmesini engeller.
                ),
                Container(
                  padding: const EdgeInsets.only(top: 16.0),
                  alignment: Alignment.center,
                  child: SignInButtonBuilder(
                    icon: Icons.verified_user,
                    backgroundColor: Colors.blueAccent,
                    text: "Giriş Yap",
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        _signIn(); // TODO: Email ile giriş
                      }
                    }
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _signIn() async {
    try{
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: _emailController.text, password: _passwordController.text);
      final User user = userCredential.user;

      Scaffold.of(context).showSnackBar(SnackBar(content: Text("Welcome, ${user.email}")));
    }on FirebaseAuthException catch (e){
      Scaffold.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    } catch (e){
      //print(e.toString());
      debugPrint(e.toString());
    }
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
  }
}

class _SignInProvider extends StatefulWidget {
  final String infoText;
  final Buttons buttonType;
  final Function signInMethod;

  const _SignInProvider({
    Key key,
    @required this.infoText,
    @required this.buttonType,
    @required this.signInMethod,
  }) : super(key: key);

  @override
  __SignInProviderState createState() => __SignInProviderState();
}

class __SignInProviderState extends State<_SignInProvider> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Text(
                widget.infoText,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              alignment: Alignment.center,
            ),
            Container(
              padding: const EdgeInsets.only(top: 16.0),
              alignment: Alignment.center,
              child: SignInButton(
                widget.buttonType,
                text: widget.infoText,
                onPressed: () async => widget.signInMethod(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
