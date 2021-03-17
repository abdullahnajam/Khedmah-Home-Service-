import 'dart:async';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:rizek/data/values.dart';
import 'package:rizek/navigator/bottom_navigation.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'otp.dart';
import '../model/country_codes.dart';
import 'package:firebase_database/firebase_database.dart';


class OnBoarding extends StatefulWidget {
  @override
  _OnBoardingPageState createState() => new _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoarding> {

  final controller = PageController();
  bool first=true;
  String countryImageUrl=null;
  String countryCode=null;
  CountryCodes _countryCodes;

  final databaseReference = FirebaseDatabase.instance.reference();
  Future<List<CountryCodes>> getCodes() async {
    List<CountryCodes> list=new List();
    await databaseReference.child("countries").once().then((DataSnapshot dataSnapshot){

      var KEYS= dataSnapshot.value.keys;
      var DATA=dataSnapshot.value;

      for(var individualKey in KEYS){
        CountryCodes bookingModel = new CountryCodes(
            individualKey,
            DATA[individualKey]['code'],
            DATA[individualKey]['name'],
            DATA[individualKey]['image'],
        );
        list.add(bookingModel);


      }

    });
    if(first){
      setState(() {
        _countryCodes=list[0];
        first=false;
      });
    }

    return list;
  }

  String code='+92';
  String flag='PK';

  final TextEditingController _phoneNumberController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 9,
            child: Stack(
              children: [
                Container(
                  child:CustomPaint(
                    painter: CurvePainter(),
                  ),
                  alignment: Alignment.topCenter,

                  height: 250,
                  width: MediaQuery.of(context).size.width,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.height*0.65,
                      alignment:Alignment.center,
                      width: double.maxFinite,
                      child: PageView(
                        controller: controller,
                        children: <Widget>[
                          Container(
                            width: double.maxFinite,
                            child: Column(
                              children: <Widget>[
                                Image.asset('assets/images/logo.png',height: MediaQuery.of(context).size.height*0.5,width: double.maxFinite,),
                                Text("Heading",textAlign: TextAlign.center,style: TextStyle(color: Colors.black,fontWeight: FontWeight.w800,fontSize: 18)),
                                Container(
                                  width: 100,
                                  margin: EdgeInsets.all(10),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 50,right: 50),
                                  child: Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.black,fontWeight: FontWeight.w300,fontSize: 11),),
                                )
                              ],
                            ),
                          ),
                          Container(
                            width: double.maxFinite,
                            child: Column(
                              children: <Widget>[
                                Image.asset('assets/images/logo.png',height: MediaQuery.of(context).size.height*0.5,width: double.maxFinite,),
                                Text("Heading",textAlign: TextAlign.center,style: TextStyle(color: Colors.black,fontWeight: FontWeight.w800,fontSize: 18)),
                                Container(
                                  width: 100,
                                  margin: EdgeInsets.all(10),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 50,right: 50),
                                  child: Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.black,fontWeight: FontWeight.w300,fontSize: 11),),
                                )
                              ],
                            ),
                          ),
                          Container(
                            width: double.maxFinite,
                            child: Column(
                              children: <Widget>[
                                Image.asset('assets/images/logo.png',height: MediaQuery.of(context).size.height*0.5,width: double.maxFinite,),
                                Text("Heading",textAlign: TextAlign.center,style: TextStyle(color: Colors.black,fontWeight: FontWeight.w800,fontSize: 18)),
                                Container(
                                  width: 100,
                                  margin: EdgeInsets.all(10),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 50,right: 50),
                                  child: Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.black,fontWeight: FontWeight.w300,fontSize: 11),),
                                )
                              ],
                            ),
                          ),


                        ],
                      ),
                    ),
                    Container(
                      child: SmoothPageIndicator(
                        controller: controller,
                        count: 3,
                        effect: WormEffect(dotWidth: 12,dotHeight:12,activeDotColor: primaryColor,dotColor: Colors.grey[200]),
                      ),
                    ),
                  ],
                ),
              ],
            )
          ),
          Expanded(
            flex: 4,
            child: Container(
              height: MediaQuery.of(context).size.height*0.3,
              alignment: Alignment.bottomCenter,
              child: Column(
                children: <Widget>[
                  Container(
                    padding:EdgeInsets.only(top: 10,left: 30,right: 30),
                    height: 100,
                    width: MediaQuery.of(context).size.width,
                    child:  Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            FutureBuilder<List<CountryCodes>>(
                              future: getCodes(),
                              builder: (context,snapshot){
                                if(snapshot.hasData){
                                  if(snapshot.data!=null && snapshot.data.length>0){
                                    return GestureDetector(
                                      onTap: (){
                                        showDialog<void>(
                                          context: context,
                                          barrierDismissible: true, // user must tap button!
                                          builder: (BuildContext context) {
                                            return Card(
                                              
                                              margin: EdgeInsets.only(
                                                  top: MediaQuery.of(context).size.height*0.1,
                                                  bottom: MediaQuery.of(context).size.height*0.1,
                                                  left: MediaQuery.of(context).size.width*0.1,
                                                  right: MediaQuery.of(context).size.width*0.1,
                                              ),
                                              child: Container(
                                                padding: EdgeInsets.all(10),
                                                child: ListView.builder(
                                                  itemCount: snapshot.data.length,
                                                  itemBuilder: (BuildContext context,int index){
                                                    return GestureDetector(
                                                      onTap: (){
                                                        setState(() {
                                                          _countryCodes=snapshot.data[index];
                                                          countryImageUrl=snapshot.data[index].image;
                                                          print(countryImageUrl);
                                                          Navigator.pop(context);
                                                        });
                                                      },
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            flex: 3,
                                                            child:  Row(
                                                              children: [
                                                                Image.network(snapshot.data[index].image,width: 30,height: 30,),
                                                                SizedBox(width: 5,),
                                                                Text(snapshot.data[index].code,style: TextStyle(fontSize: 18),),
                                                              ],
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex: 7,
                                                            child:  Text(snapshot.data[index].name,style: TextStyle(fontSize: 18),),
                                                          )

                                                        ],
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      child: Row(
                                        children: [
                                          Image.network(_countryCodes.image,width: 30,height: 30,),
                                          SizedBox(width: 5,),
                                          Text(_countryCodes.code,style: TextStyle(fontSize: 18),)
                                        ],
                                      ),
                                    );
                                  }
                                  else {
                                    return new Container(
                                      child: Center(
                                          child: Icon(Icons.warning,color: primaryColor,)
                                      ),
                                    );
                                  }
                                }
                                else if (snapshot.hasError) {
                                  return Text('Error : ${snapshot.error}');
                                } else {
                                  return new Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                              },
                            ),
                            SizedBox(width: 10,),
                            Expanded(
                              child: TextFormField(
                                controller: _phoneNumberController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                  labelStyle: TextStyle(color: Colors.grey[500],fontSize: 20),
                                  labelText: 'Enter Mobile Number',
                                ),
                              ),
                            )
                          ],
                        ),
                        Divider(color: Colors.grey,)
                      ],
                    )

                  ),
                  Container(
                    padding:EdgeInsets.only(top: 10,bottom: 10,left: 30,right: 30),
                    height: 60,
                    width: MediaQuery.of(context).size.width,
                    child:  RaisedButton(
                      color: primaryColor,
                      onPressed: (){
                        String phoneNumber = "${_countryCodes.code}${_phoneNumberController.text}";
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => OTPScreen(_phoneNumberController.text,_countryCodes.code,_countryCodes.image)));
                      },
                      child: Text("Login / Sign Up",textAlign: TextAlign.center,style: TextStyle(color: Colors.white,fontWeight: FontWeight.w400,fontSize: 12),),
                    ),

                  ),
                  Container(
                    padding:EdgeInsets.only(bottom: 10,left: 30,right: 30),
                    width: double.maxFinite,
                    child:  OutlineButton(
                      color: Colors.grey[200],
                      onPressed: (){
                        Navigator.push(context, new MaterialPageRoute(
                            builder: (context) => BottomNavBar(null,false)));
                      },
                      child: Text("Continue without account",textAlign: TextAlign.center,style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 12),),
                    ),

                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }


}
class CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = Colors.green[800];
    paint.style = PaintingStyle.fill;

    var path = Path();

    path.moveTo(0, size.height * 0.25);
    path.quadraticBezierTo(
        size.width / 2, size.height / 2, size.width, size.height * 0.25);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
