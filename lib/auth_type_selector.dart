import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_builder.dart';
import 'package:path/path.dart' as pth;


import 'home_page.dart';
import 'register_page.dart';
import 'signin_page.dart';

/// Bir kimlik doğrulama türü [Authentication Type] seçmek için
/// bir UI [User Interface] sağlar.
class AuthTypeSelector extends StatelessWidget {
  final Color primaryColor = Color(0xff18203d);
  final Color secondaryColor = Color(0xff232c51);
  final Color logoGreen = Color(0xff25bcbb);

  BuildContext context;
  Future<bool> _onBackPressed(){
    return showDialog(context: this.context, builder: (context) => AlertDialog(title: Text("Uygulamadan çıkılsın mı?"),
      actions: <Widget> [
        FlatButton(child: Text("No"),onPressed: () => Navigator.pop(context,false)),
        FlatButton(child: Text("Yes"),onPressed: () => Navigator.pop(context, true) )
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        backgroundColor: primaryColor,
        appBar: AppBar(
          backgroundColor: secondaryColor,
          title: Text("Bütçe Yönetimim"),
        ),
        body: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //? Kayıt Ol Buttonu
              Container(
                //decoration: BoxDecoration( borderRadius: BorderRadius.circular(120.0),boxShadow:[BoxShadow(color: Colors.blueAccent, spreadRadius: 4, blurRadius: 20)] ),
                alignment: Alignment.center,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(120),
                  child: Container(
                    width: 240,
                    height: 240,
                    decoration: new BoxDecoration(
                      image: new DecorationImage(image: ExactAssetImage('assets/images/budget.png'),fit: BoxFit.fitHeight,),
                    ),
                  ),
                ),
              ),
              Container(
                  height: 55
              ),
              Container(
                child: SignInButtonBuilder(
                  icon: Icons.person_add,
                  backgroundColor: logoGreen,
                  text: "Kayıt Ol",
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => RegisterPage(),
                    ),
                  ),
                ),
                padding: const EdgeInsets.all(16.0),
                alignment: Alignment.center,
              ),
              //? Giriş Yap Buttonu
              Container(
                child: SignInButtonBuilder(
                  icon: Icons.verified_user,
                  backgroundColor: Colors.blueAccent,
                  text: "Giriş Yap",
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => FirebaseAuth.instance.currentUser == null ? SignInPage() : HomePage(),
                    ),
                  ),
                ),
                padding: const EdgeInsets.all(16.0),
                alignment: Alignment.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
