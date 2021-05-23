import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_signin_button/button_builder.dart';

import 'butce_raporu.dart';
import 'butce_tanimla.dart';
import 'signin_page.dart';
import 'package:flutter/material.dart';

final Color primaryColor = Color(0xff18203d);
final Color secondaryColor = Color(0xff232c51);
final Color logoGreen = Color(0xff25bcbb);

class HomePage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: secondaryColor,
        title: Text("Hesabım"),
        actions: [
          //! Builder eklemezsek Scaffold.of() hata verecektir!
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.login),
              onPressed: () async {
                await _auth.signOut();// TODO: Çıkış yap
                if(await GoogleSignIn().isSignedIn()){
                  await GoogleSignIn().disconnect();
                  await GoogleSignIn().signOut();
                }
                Scaffold.of(context).showSnackBar(SnackBar(content: Text("Başarıyla çıkış yapıldı")));

                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignInPage()));
              },
            ),
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Gelir görüntüle butonu
          Container(
            //decoration: BoxDecoration( borderRadius: BorderRadius.circular(120.0),boxShadow:[BoxShadow(color: Colors.blueAccent, spreadRadius: 4, blurRadius: 20)] ),
            alignment: Alignment.center,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(120),
              child: Container(
                width: 240,
                height: 240,
                color: Color(0xff48a87e),
                //child: ElevatedButton.icon(onPressed: () {}, icon: Icon(Icons.attach_money), label: Text('Bütçe Tanımlama',style: TextStyle(fontSize: 20))),
                child: SignInButtonBuilder(
                    onPressed: () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => ButceTanimla())),
                    icon: Icons.attach_money,
                    text: "Bütçe Tanımlama",
                    fontSize: 20,
                    backgroundColor: Color(0xff48a87e),
                ),
              ),
            ),
          ),
          Container(
            height: 30,
            color: primaryColor,
          ),
          Container(
            //decoration: BoxDecoration( borderRadius: BorderRadius.circular(120.0),boxShadow:[BoxShadow(color: Colors.blueAccent, spreadRadius: 4, blurRadius: 20)] ),
            alignment: Alignment.center,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(120),
              child: Container(
                width: 240,
                height: 240,
                color: Color(0xff6a6396),
                //child: ElevatedButton.icon(onPressed: () {}, icon: Icon(Icons.attach_money), label: Text('Bütçe Tanımlama',style: TextStyle(fontSize: 20))),
                child: SignInButtonBuilder(
                  onPressed: () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => ButceRaporu())),
                  icon: Icons.assignment_outlined,
                  text: "Bütçe Raporlama",
                  fontSize: 20,
                  backgroundColor: Color(0xff6a6396),
                ),
              ),
            ),
          )
        ],
      )
    );
  }
}
