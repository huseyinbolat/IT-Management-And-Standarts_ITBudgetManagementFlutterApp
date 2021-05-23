//import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

import 'home_page.dart';

/// Email / Şifre ile kayıt sayfası
class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _success;
  String _message;
  final Color primaryColor = Color(0xff18203d);
  final Color secondaryColor = Color(0xff232c51);
  final Color logoGreen = Color(0xff25bcbb);
  final Color dropColor = Color(0xff2b3663);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: secondaryColor,
        title: Text("Kayıt Ol"),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal:20),
        alignment: Alignment.center,
        child: Form(
          key: _formKey,
          child: Card(
            color: secondaryColor,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    //? E-Mail
                    TextFormField(
                      style: TextStyle(color: Colors.white),
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: "E-Mail",labelStyle: TextStyle(color: Colors.white)),
                      validator: (String mail) {
                        if (mail.isEmpty) {
                          return "Lütfen bir mail yazın";
                        }
                        return null;
                      },
                    ),
                    //? Şifre
                    TextFormField(
                      style: TextStyle(color: Colors.white),
                      controller: _passwordController,
                      decoration: const InputDecoration(labelText: "Şifre",labelStyle: TextStyle(color: Colors.white)),
                      validator: (String password) {
                        if (password.isEmpty) {
                          return "Lütfen bir şifre yazın";
                        }
                        return null;
                      },
                      obscureText: true, //! Şifrenin görünmesini engeller.
                    ),
                    Container(
                      height: 30,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      alignment: Alignment.center,
                      child: SignInButtonBuilder(
                        icon: Icons.person_add,
                        backgroundColor: logoGreen,
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            _register();// TODO: Kayıt İşlemi
                          }
                        },
                        text: "Kayıt ol",
                      ),
                    ),
                    //? Geri bildirim
                    Container(
                      alignment: Alignment.center,
                      child: Text(_success == null ? '' : _message ?? ''),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    //! Widget kapatıldığında controllerları temizle
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _register() async {
    try{
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: _emailController.text, password: _passwordController.text);
      final User user = userCredential.user;
      if(user != null){
        setState(() {
          _message = "Hello, ${user.email}";
          _success = true;
        });
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
      } else {
        setState(() {
          _message = "Error accured!";
          _success = false;
        });
      }
      //Scaffold.of(context).showSnackBar(SnackBar(content: Text("Hello, ${user.email}")));
    } on FirebaseAuthException catch(e){
      setState(() {
        _message = e.message;
        _success = false;
      });
    } catch(e){
      print(e.toString());
    }

  }
}
