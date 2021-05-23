import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_builder.dart';

import 'home_page.dart';

final Color primaryColor = Color(0xff18203d);
final Color secondaryColor = Color(0xff232c51);
final Color logoGreen = Color(0xff25bcbb);
final Color dropColor = Color(0xff2b3663);


class ButceRaporu extends StatefulWidget {
  @override
  _ButceRaporuState createState() => _ButceRaporuState();
}

final FirebaseAuth _auth = FirebaseAuth.instance;
final User user = _auth.currentUser;

class _ButceRaporuState extends State<ButceRaporu> {
  var secilenZamanDilimi;
  var secilenButceTuru;
  var secilenAltTur ;
  var yillikMiktar = 0.0;
  var aylikMiktar = 0.0;

  //var dialogColor = Color(0xff32496e);

  final GlobalKey<FormState> _formKeyValue = new GlobalKey<FormState>();
  final _miktarController = TextEditingController();
  final _aciklamaController = TextEditingController();
  final _karZararController = TextEditingController();
  TextEditingController butceTuruController = TextEditingController();

  List<String> _zamanDilimi = <String>['Aylık', 'Yıllık'];
  List<String> _butceTuru = <String>['Gelir', 'Gider'];
  List<String> _altTur = <String>['Proje Bazlı','Rutin','Sabit','Değişken'];

  var karZararRenk;
  var karZararDurumu;

  CollectionReference ref = FirebaseFirestore.instance.collection('${user.email}');

  Future<bool> _onBackPressed(){
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        backgroundColor: primaryColor,
        appBar: AppBar(title: Text("Bütçe Raporu"),backgroundColor: secondaryColor,),
        body: Container(
          margin: EdgeInsets.symmetric(horizontal:20),
          child: Column(
            children: [
              StreamBuilder(
                stream: ref.snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if(snapshot.hasData){
                    final QuerySnapshot querySnapshot = snapshot.data;
                    return ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: querySnapshot.size,
                      itemBuilder: (context, index){
                        final map = querySnapshot.docs[index].data();
                        return Container(
                          child: Dismissible(
                            key: Key(querySnapshot.docs[index].id),
                            onDismissed: (direction) async{
                              await querySnapshot.docs[index].reference.delete();
                            } ,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(map['Bütçe Türü'],style: TextStyle(color: Colors.white),),
                                Text(map['Alt Bütçe Türü'],style: TextStyle(color: Colors.white)),
                                Text(map['Açıklama'],style: TextStyle(color: Colors.white)),
                                Text((map['Aylık Miktar']).toString()+ ' TL',style: TextStyle(color: Colors.white)),
                                //Text(map['Zaman Dilimi'],style: TextStyle(color: Colors.white)),
                                IconButton(icon: Icon(Icons.edit_rounded), color: logoGreen,onPressed: () {

                                  _miktarController.text = map['Aylık Miktar'].toString();
                                  secilenButceTuru = map['Bütçe Türü'];
                                  secilenAltTur = map['Alt Bütçe Türü'];
                                  secilenZamanDilimi = map['Zaman Dilimi'];
                                  _aciklamaController.text = map['Açıklama'];

                                  showDialog(context: context, builder: (context) => Dialog(backgroundColor: secondaryColor,
                                    child: Form(
                                      key: _formKeyValue, autovalidate: true,
                                      child: Container(
                                        margin: EdgeInsets.symmetric(horizontal:10),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: <Widget>[
                                            Expanded(child: Row(
                                              children: <Widget> [
                                                Expanded(child: Text('Bütçe Türü:',style: TextStyle(color: Colors.white),)),
                                                Expanded(child: DropdownButtonFormField(
                                                  dropdownColor: dropColor,
                                                  icon: Icon(Icons.keyboard_arrow_down_sharp),
                                                  items: _butceTuru.map((value) => DropdownMenuItem(child: Text(value,style: TextStyle(color: Colors.white)), value: value)).toList(),
                                                  value: secilenButceTuru,
                                                  onChanged: (secilenTur){
                                                    setState(() {
                                                      secilenButceTuru = secilenTur;
                                                    });
                                                  },
                                                  validator: (value) => value==null ? 'Bütçe türü seçiniz' :null,
                                                ))
                                              ],
                                            )),
                                            Expanded(child: Row(
                                              children: <Widget> [
                                                Expanded(child: Text('Gelir/Gider Türü:',style: TextStyle(color: Colors.white))),
                                                Expanded(child: DropdownButtonFormField(
                                                  dropdownColor: dropColor,
                                                  icon: Icon(Icons.keyboard_arrow_down_sharp),
                                                  items: _altTur.map((value) => DropdownMenuItem(child: Text(value,style: TextStyle(color: Colors.white)), value: value)).toList(),
                                                  onChanged: (secildiAltTur){
                                                    setState(()  {
                                                      secilenAltTur = secildiAltTur;
                                                    });
                                                  }, value: secilenAltTur,
                                                  validator: (value) => value==null ? 'Alt Bütçe türü seçiniz' :null,
                                                ))
                                              ],
                                            )),
                                            Expanded(child: Row(
                                                children: <Widget> [
                                                  Expanded(flex:1,child: Text('Açıklama: ',style: TextStyle(color: Colors.white))),
                                                  Expanded(flex:2,child: TextFormField(style:TextStyle(color: Colors.white),controller: _aciklamaController, decoration:InputDecoration(hintText: 'Bütce Türü Detayı Giriniz.'),))
                                                ]
                                            )),
                                            Expanded(child: Row(
                                              children: <Widget> [
                                                Expanded(flex:1,child: Text('Miktar(TL):',style: TextStyle(color: Colors.white))),
                                                Expanded(flex:2,child: TextFormField(style: TextStyle(color: Colors.white),
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
                                                Expanded(child: Text('Zaman Dilimi :',style: TextStyle(color: Colors.white))),
                                                Expanded(child: DropdownButtonFormField(
                                                  dropdownColor: dropColor,
                                                  icon: Icon(Icons.keyboard_arrow_down_sharp),
                                                  items: _zamanDilimi.map((value) => DropdownMenuItem(child: Text(value,style: TextStyle(color: Colors.white)), value: value)).toList(),
                                                  value: secilenZamanDilimi,
                                                  onChanged: (secilenDilim){
                                                    setState(() {
                                                      secilenZamanDilimi = secilenDilim;
                                                    });
                                                  },
                                                  validator: (value) => value==null ? 'Zaman dilimi seçiniz' :null,
                                                ))
                                              ],
                                            )),
                                            Expanded(child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                ElevatedButton( onPressed: () {
                                                  if(secilenZamanDilimi == 'Yıllık'){
                                                    yillikMiktar = double.parse(_miktarController.text);
                                                    aylikMiktar = yillikMiktar/12;
                                                    aylikMiktar = double.parse(aylikMiktar.toStringAsFixed(2));
                                                  }
                                                  else{
                                                    aylikMiktar = double.parse(_miktarController.text);
                                                    yillikMiktar = aylikMiktar*12;
                                                  }
                                                  snapshot.data.docs[index].reference.update({'Bütçe Türü': secilenButceTuru, 'Alt Bütçe Türü': secilenAltTur, 'Açıklama': _aciklamaController.text,
                                                    'Yıllık Miktar': yillikMiktar,'Aylık Miktar': aylikMiktar, 'Zaman Dilimi': secilenZamanDilimi
                                                  });
                                                  _miktarController.clear();
                                                  _aciklamaController.clear();
                                                  secilenButceTuru = null;
                                                  secilenAltTur = null;
                                                  secilenZamanDilimi = null;
                                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ButceRaporu()));
                                                },child: Text('Güncelle'))
                                              ],
                                            ))
                                          ],
                                        ),
                                      ),
                                    ),
                                  ));
                                }),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                  if(snapshot.hasError){
                    print(snapshot.error);
                    return Text("Error: ${snapshot.error}");
                  }
                  else{
                    return Text('Hata oldu!',style: TextStyle(color: Colors.white));
                  }
                } ,
              ),
              SizedBox(height: 20),
              SignInButtonBuilder(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                icon: Icons.assessment_outlined,
                fontSize: 17.0,
                backgroundColor: logoGreen,
                text: "Kar/Zarar Görüntüle",
                onPressed:  () async {
                  _karZararHesapla();
                  setState(() {
                    _karZararController.text = karZararDurumu ;
                  });
                },
              ),
              SizedBox(height: 40),
              Text("Kar/Zarar Durumu : ", style: TextStyle(color: Colors.white)),
              TextField(
                style: TextStyle(color: karZararRenk ),
                textAlign: TextAlign.center,
                controller: _karZararController,
                enabled: false,
              )
            ],
          ),
        ) ,
      ),
    );
  }

  void dispose() {
    //! Widget kapatıldığında controllerları temizle
    _miktarController.dispose();
    _aciklamaController.dispose();
    super.dispose();
  }

  void _karZararHesapla() async {
    var kar = 0.0;
    var zarar = 0.0;
    var net = 0.0;

    await ref.where('Bütçe Türü', isEqualTo: 'Gelir')
        .get()
        .then((value) {
      value.docs.forEach((element) => {
        kar = kar + double.parse(element.data()['Aylık Miktar'].toString()),
      });
        });
    await ref.where('Bütçe Türü', isEqualTo: 'Gider')
        .get()
        .then((value) {
      value.docs.forEach((element) => {
        zarar = zarar + double.parse(element.data()['Aylık Miktar'].toString()),
      });
    });
    net = kar - zarar;
    //karZararDurumu = net.toString();
    if(net.isNegative){
      net *= -1;
      karZararDurumu = "${net} TL Zarardasınız";
      karZararRenk = Colors.red;
    }
    else{
      karZararDurumu = "${net} TL Kardasınız";
      karZararRenk = Colors.green;
    }

  }
}
