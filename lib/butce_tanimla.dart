import 'package:flutter/material.dart';
import 'package:login_firebase/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ButceTanimla extends StatefulWidget {
  @override
  _ButceTanimlaState createState() => _ButceTanimlaState();
}

class _ButceTanimlaState extends State<ButceTanimla> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var secilenZamanDilimi;
  var secilenButceTuru;
  var secilenAltTur = "Proje Bazlı";
  final GlobalKey<FormState> _formKeyValue = new GlobalKey<FormState>();
  final _miktarController = TextEditingController();
  final _aciklamaController = TextEditingController();
  List<String> _zamanDilimi = <String>['Aylık', 'Yıllık'];
  List<String> _butceTuru = <String>['Gelir', 'Gider'];
  List<String> _gelirTuru = <String>['Proje Bazlı', 'Rutin'];
  List<String> _giderTuru = <String>['Sabit', 'Değişken','Proje Bazlı'];
  List<String> _altTur = <String>['Proje Bazlı'];

  final Color primaryColor = Color(0xff18203d);
  final Color secondaryColor = Color(0xff232c51);
  final Color logoGreen = Color(0xff25bcbb);
  final Color dropColor = Color(0xff2b3663);


  Future<bool> _onBackPressed(){
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
          backgroundColor: secondaryColor,
          appBar: AppBar(backgroundColor: secondaryColor,title: Text("Bütçe Tanımla")),
          body: Form( key: _formKeyValue, autovalidate: true,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal:30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(child: Row(
                      children: <Widget> [
                        Expanded(child: Text('Bütçe Türü:',style: TextStyle(color: Colors.white))),
                        Expanded(child: DropdownButtonFormField(
                          dropdownColor: dropColor,
                          icon: Icon(Icons.keyboard_arrow_down_sharp),
                          items: _butceTuru.map((value) => DropdownMenuItem(child: Text(value,style: TextStyle(color: Colors.white)), value: value)).toList(),
                          onChanged: (secilenTur){
                            setState(() {
                              secilenButceTuru = secilenTur;
                              if (secilenButceTuru.toString() == 'Gelir'){
                                _altTur = _gelirTuru;
                                secilenAltTur = "Proje Bazlı";
                              }
                              else if(secilenButceTuru == 'Gider'){
                                _altTur = _giderTuru;
                                secilenAltTur = "Proje Bazlı";
                              }
                            });
                          }, value: secilenButceTuru,
                          validator: (value) => value==null ? 'Bütçe türü seçiniz' :null,
                        ))
                      ],
                    )),
                    Expanded(child: Row(
                      children: <Widget> [
                        Expanded(child: Text('Alt Bütçe Türü:',style: TextStyle(color: Colors.white))),
                        Expanded(child: DropdownButtonFormField(
                          dropdownColor: dropColor,
                          icon: Icon(Icons.keyboard_arrow_down_sharp),
                          items: _altTur.map((value) => DropdownMenuItem(child: Text(value,style: TextStyle(color: Colors.white)), value: value)).toList(),
                          onChanged: (altTur){
                            setState(() {
                              secilenAltTur = altTur;
                            });
                          }, value: secilenAltTur,
                          validator: (value) => value==null ? 'Alt Bütçe türü seçiniz' :null,
                        ))
                      ],
                    )),
                    Expanded(child: Row(
                        children: <Widget> [
                          Expanded(flex: 1,child: Text('Açıklama: ',style: TextStyle(color: Colors.white))),
                          Expanded(flex:2,child: TextFormField(style: TextStyle(color: Colors.white),controller: _aciklamaController, decoration: InputDecoration(hintText: 'Bütce Türü Detayı Giriniz.'),))
                        ]
                    )),
                    Expanded(child: Row(
                      children: <Widget> [
                        Expanded(flex: 1,child: Text('Miktar(TL):',style: TextStyle(color: Colors.white))),
                        Expanded(flex:2,child: TextFormField(
                          style: TextStyle(color: Colors.white),
                          controller: _miktarController,
                          validator: (String miktar) {
                            if(miktar.isEmpty) {
                              return "Lütfen miktar giriniz!";
                            }
                            return null;
                          },
                          decoration: InputDecoration(hintText: 'Miktarı Giriniz.'),)),

                      ],
                    )),
                    Expanded(child: Row(
                      children: <Widget> [
                        Expanded(child: Text('Zaman Dilimi:',style: TextStyle(color: Colors.white))),
                        Expanded(child: DropdownButtonFormField(
                          dropdownColor: dropColor,
                          icon: Icon(Icons.keyboard_arrow_down_sharp),
                          items: _zamanDilimi.map((value) => DropdownMenuItem(child: Text(value,style: TextStyle(color: Colors.white)), value: value)).toList(),
                          onChanged: (secilenDilim){
                            setState(() {
                              secilenZamanDilimi = secilenDilim;
                            });
                          }, value: secilenZamanDilimi,
                          validator: (value) => value==null ? 'Zaman dilimi seçiniz' :null,
                        ))
                      ],
                    )),
                    Expanded(child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton( onPressed: () {
                          setState(() {

                          });
                          if (_formKeyValue.currentState.validate()) {
                            _gonder();// TODO: Kayıt İşlemi
                            _miktarController.clear();
                            _aciklamaController.clear();
                            secilenButceTuru = null;
                            secilenAltTur = null;
                            secilenZamanDilimi = null;
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
                          }

                        },child: Text('Gönder'),)
                      ],
                    ))
                  ],
                ),

              )
          )
      ),
    );
  }

  void dispose() {
    //! Widget kapatıldığında controllerları temizle
    _miktarController.dispose();
    _aciklamaController.dispose();
    super.dispose();
  }

  void _gonder() async {
    print("Gönderildi");
    final User user = _auth.currentUser;
    var miktar = double.parse(_miktarController.text);
    //var f = new NumberFormat("###.0#", "en_US");
    CollectionReference ceo = FirebaseFirestore.instance.collection("${user.email}");
    if(secilenZamanDilimi == 'Yıllık'){
      var aylikMiktar = miktar/12;
      //aylikMiktar=double.parse(f.format(aylikMiktar));
      aylikMiktar = double.parse(aylikMiktar.toStringAsFixed(2));
      await ceo.add({'Bütçe Türü': secilenButceTuru, 'Alt Bütçe Türü': secilenAltTur, 'Açıklama': _aciklamaController.text,
        'Yıllık Miktar': miktar,'Aylık Miktar': aylikMiktar, 'Zaman Dilimi': secilenZamanDilimi,
      });
    }
    else{
      var yillikMiktar = miktar*12;
      await ceo.add({'Bütçe Türü': secilenButceTuru, 'Alt Bütçe Türü': secilenAltTur, 'Açıklama': _aciklamaController.text,
        'Yıllık Miktar': yillikMiktar,'Aylık Miktar': miktar, 'Zaman Dilimi': secilenZamanDilimi,
      });
    }

  }
  
}
