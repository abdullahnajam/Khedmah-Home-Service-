import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../data/values.dart';
import '../home/category_list.dart';
import '../profile/profile.dart';
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height*0.4,
            width: double.maxFinite,
            color: backgroundColor,
          ),
          SafeArea(
            child: ListView(
              children: [
                Container(
                  margin: EdgeInsets.all(7),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.place,color: primaryColor,),
                          Text("City Name",style: TextStyle(fontWeight: FontWeight.w800),),
                          Icon(Icons.keyboard_arrow_down,color: primaryColor,),
                        ],
                      ),
                      GestureDetector(
                        onTap: (){
                          Navigator.push(context, new MaterialPageRoute(
                              builder: (context) => Profile()));
                        },
                        child: Container(
                          padding: EdgeInsets.all(5),
                          child: Icon(Icons.person,color: primaryColor,),
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey,
                                offset: Offset(0.0, 1.0), //(x,y)
                                blurRadius: 6.0,
                              ),
                            ],
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(120),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(15),
                  padding: EdgeInsets.all(5),
                  child: Row(
                    children: [
                      Expanded(
                        flex:2,
                        child: Image.asset("assets/images/placeholder.png",width: 30,height: 30,),
                      ),
                      Expanded(
                        flex:8,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Your Safety Is Our Piority",
                              style: TextStyle(fontSize: 17,fontWeight: FontWeight.w700),
                              textAlign: TextAlign.start,
                            ),
                            SizedBox(height: 2,),
                            Text(
                              "We take strick precautionary measures to keep you safe from COVID-19",
                              style: TextStyle(fontSize: 13,fontWeight: FontWeight.w400,color: Colors.grey[500]),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(15),
                  padding: EdgeInsets.all(5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Special Offers",
                        style: TextStyle(fontSize: 17,fontWeight: FontWeight.w700),
                        textAlign: TextAlign.start,
                      ),
                      Icon(Icons.arrow_forward,color: primaryColor,)
                    ],
                  ),

                ),
                Container(
                  height: 120,
                  margin: EdgeInsets.all(10),
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      GestureDetector(
                        onTap: (){
                          Navigator.push(context, new MaterialPageRoute(
                              builder: (context) => CategoryList()));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          width: 180,
                          child: Stack(
                            children: [
                              Container(
                                margin:EdgeInsets.all(5),
                                padding:EdgeInsets.only(left: 7,right: 7,top: 5,bottom: 5),
                                decoration: BoxDecoration(
                                  color: Colors.yellow[600],
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text("Trending",style: TextStyle(fontSize:12,color: Colors.white),),
                              ),
                              Positioned(
                                bottom: 7,
                                left: 5,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Covid-19 PCR Test",
                                      style: TextStyle(fontSize: 12,fontWeight: FontWeight.w700,color: Colors.white),
                                      textAlign: TextAlign.start,
                                    ),
                                    SizedBox(height: 2,),
                                    Text(
                                      "Duly Licensed by DOH and DHA",
                                      style: TextStyle(fontSize: 10,fontWeight: FontWeight.w400,color: Colors.white),
                                    )
                                  ],
                                ),
                              )

                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 10,),
                      Container(
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        width: 180,
                        child: Stack(
                          children: [
                            Container(
                              margin:EdgeInsets.all(5),
                              padding:EdgeInsets.only(left: 7,right: 7,top: 5,bottom: 5),
                              decoration: BoxDecoration(
                                color: Colors.yellow[600],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text("Trending",style: TextStyle(fontSize:12,color: Colors.white),),
                            ),
                            Positioned(
                              bottom: 7,
                              left: 5,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Covid-19 PCR Test",
                                    style: TextStyle(fontSize: 12,fontWeight: FontWeight.w700,color: Colors.white),
                                    textAlign: TextAlign.start,
                                  ),
                                  SizedBox(height: 2,),
                                  Text(
                                    "Duly Licensed by DOH and DHA",
                                    style: TextStyle(fontSize: 10,fontWeight: FontWeight.w400,color: Colors.white),
                                  )
                                ],
                              ),
                            )

                          ],
                        ),
                      )
                    ],

                  )

                ),
                Container(
                  margin: EdgeInsets.only(top:15,left: 15),
                  child: Text(
                    "Book a home service",
                    style: TextStyle(fontSize: 17,fontWeight: FontWeight.w700),
                    textAlign: TextAlign.start,
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(15),
                  height: 120,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      Container(
                        width: 100,
                        decoration: BoxDecoration(
                          color: Color(0xfff1f6fa),
                          border: Border.all(color: backgroundColor),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              flex: 8,
                              child: Image.asset("assets/images/logo.png",width: 80,),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                "PCR Test",
                                style: TextStyle(fontSize: 12,fontWeight: FontWeight.w300),
                                textAlign: TextAlign.start,
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(width: 10,),
                      Container(
                        width: 100,
                        decoration: BoxDecoration(
                          color: Color(0xfff1f6fa),
                          border: Border.all(color: backgroundColor),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              flex: 8,
                              child: Container(
                                width: 50,
                                margin: EdgeInsets.only(top: 22,bottom: 22),
                                decoration: BoxDecoration(
                                  color: Color(0xfff1f6fa),
                                  border: Border.all(color: backgroundColor),
                                  borderRadius: BorderRadius.circular(120),
                                ),
                                child: Center(child:Icon(Icons.arrow_forward)),
                              )
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                "View All",
                                style: TextStyle(fontSize: 12,fontWeight: FontWeight.w300),
                                textAlign: TextAlign.start,
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(15),
                  padding: EdgeInsets.all(5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Discover",
                        style: TextStyle(fontSize: 17,fontWeight: FontWeight.w700),
                        textAlign: TextAlign.start,
                      ),
                      Icon(Icons.arrow_forward,color: primaryColor,)
                    ],
                  ),

                ),

                Container(
                    height: 250,
                    margin: EdgeInsets.all(10),
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey,
                                offset: Offset(0.0, 1.0), //(x,y)
                                blurRadius: 3.0,
                              ),
                            ],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          width: 280,
                          child: Column(
                            children: [
                              Expanded(
                                flex: 6,
                                child: Container(
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(
                                            'assets/images/placeholder.png'),
                                        fit: BoxFit.fill,
                                      ),
                                    color: Colors.blue,
                                      borderRadius: new BorderRadius.only(
                                        topLeft: const Radius.circular(10.0),
                                        topRight: const Radius.circular(10.0),
                                      )
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 4,
                                child: Container(
                                  padding: EdgeInsets.all(15),
                                  width: 280,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 10,),
                                      Text(
                                        "Doctor Consultation",
                                        style: TextStyle(fontSize: 15,fontWeight: FontWeight.w700),
                                      ),
                                      SizedBox(height: 10,),
                                      Text(
                                        "Get expert care, diagnosis, and adive right at home",
                                        style: TextStyle(fontSize: 12,fontWeight: FontWeight.w300,color: Colors.grey[500]),
                                      ),
                                    ],
                                  ),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: new BorderRadius.only(
                                        bottomRight: const Radius.circular(10.0),
                                        bottomLeft: const Radius.circular(10.0),
                                      )
                                  ),
                                ),
                              )

                            ],
                          ),
                        ),
                        SizedBox(width: 10,),
                        Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey,
                                offset: Offset(0.0, 1.0), //(x,y)
                                blurRadius: 3.0,
                              ),
                            ],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          width: 280,
                          child: Column(
                            children: [
                              Expanded(
                                flex: 6,
                                child: Container(
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(
                                            'assets/images/placeholder.png'),
                                        fit: BoxFit.fill,
                                      ),
                                      color: Colors.blue,
                                      borderRadius: new BorderRadius.only(
                                        topLeft: const Radius.circular(10.0),
                                        topRight: const Radius.circular(10.0),
                                      )
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 4,
                                child: Container(
                                  padding: EdgeInsets.all(15),
                                  width: 280,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 10,),
                                      Text(
                                        "Doctor Consultation",
                                        style: TextStyle(fontSize: 15,fontWeight: FontWeight.w700),
                                      ),
                                      SizedBox(height: 10,),
                                      Text(
                                        "Get expert care, diagnosis, and adive right at home",
                                        style: TextStyle(fontSize: 12,fontWeight: FontWeight.w300,color: Colors.grey[500]),
                                      ),
                                    ],
                                  ),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: new BorderRadius.only(
                                        bottomRight: const Radius.circular(10.0),
                                        bottomLeft: const Radius.circular(10.0),
                                      )
                                  ),
                                ),
                              )

                            ],
                          ),
                        ),
                      ],

                    )

                ),
              ],
            ),
          )
        ],
      ),

    );
  }
}
