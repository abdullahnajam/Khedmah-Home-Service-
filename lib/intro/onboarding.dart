import 'dart:async';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:rizek/data/values.dart';
import 'package:rizek/navigator/bottom_navigation.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'otp.dart';


class OnBoarding extends StatefulWidget {
  @override
  _OnBoardingPageState createState() => new _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoarding> {

  final controller = PageController();


  final _scaffoldKey = GlobalKey<ScaffoldState>();

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
                            CountryCodePicker(
                              textStyle: TextStyle(fontSize: 20,fontWeight: FontWeight.w400),
                              onChanged: (value) {
                                code = value.dialCode;
                                flag=value.flagUri;
                              },
                              initialSelection: 'PK',
                              favorite: ['+92','PK'],
                              // optional. Shows only country name and flag
                              showCountryOnly: false,
                              // optional. Shows only country name and flag when popup is closed.
                              showOnlyCountryWhenClosed: false,
                              // optional. aligns the flag and the Text left
                              alignLeft: false,
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
                        String phoneNumber = "$code${_phoneNumberController.text}";
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => OTPScreen(_phoneNumberController.text,code,flag)));
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
