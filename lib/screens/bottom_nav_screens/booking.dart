import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../data/values.dart';
import '../../model/booking_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rizek/intro/otp.dart';
import 'package:rizek/model/country_codes.dart';
import 'package:firebase_auth/firebase_auth.dart';
class Booking extends StatefulWidget {
  String uid;

  Booking(this.uid);

  @override
  _BookingState createState() => _BookingState();
}

class _BookingState extends State<Booking>  with SingleTickerProviderStateMixin{
  TabController _tabController;

  bool first=true;
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

  showLoginDailog(){
    showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          margin: EdgeInsets.only(
            top: MediaQuery.of(context).size.height*0.6,
          ),
          child: Column(
            children: [
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
            ],
          )
        );
      },
    );
  }

  getUser()async{
    print('gg');
    User user=await FirebaseAuth.instance.currentUser;

  }


  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
    getUser();

  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }
  Future<List<BookingModel>> getUserBookings() async {
    List<BookingModel> list=[];
    User user=await FirebaseAuth.instance.currentUser;
    if(user!=null){
      await databaseReference.child("booking").once().then((DataSnapshot dataSnapshot){

        var KEYS= dataSnapshot.value.keys;
        var DATA=dataSnapshot.value;

        for(var individualKey in KEYS){
          BookingModel bookingModel = new BookingModel(
              individualKey,
              DATA[individualKey]['description'],
              DATA[individualKey]['location'],
              DATA[individualKey]['price'],
              DATA[individualKey]['time'],
              DATA[individualKey]['status'],
              DATA[individualKey]['url'],
              DATA[individualKey]['date'],
              DATA[individualKey]['user']
          );
          if(bookingModel.status!="Completed" && bookingModel.user==user.uid){
            print("key ${bookingModel.id}");
            list.add(bookingModel);
          }

        }
      });
    }


    return list;
  }
  Future<List<BookingModel>> getHistory() async {
    List<BookingModel> list=[];
    User user=await FirebaseAuth.instance.currentUser;
    if(user!=null){
      await databaseReference.child("booking").child(user.uid).once().then((DataSnapshot dataSnapshot){

        var KEYS= dataSnapshot.value.keys;
        var DATA=dataSnapshot.value;

        for(var individualKey in KEYS){
          BookingModel bookingModel = new BookingModel(
              individualKey,
              DATA[individualKey]['description'],
              DATA[individualKey]['location'],
              DATA[individualKey]['price'],
              DATA[individualKey]['time'],
              DATA[individualKey]['status'],
              DATA[individualKey]['url'],
              DATA[individualKey]['date'],
            DATA[individualKey]['user']
          );
          if(bookingModel.status=="Completed" && bookingModel.user==user.uid){
            print("key ${bookingModel.id}");
            list.add(bookingModel);
          }
        }

      });
    }

    return list;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: <Widget>[
            Container(
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(width: 0.2, color: Colors.grey[500]),
                ),

              ),
              child: Stack(
                children: [

                  Container(
                    alignment: Alignment.center,
                    child: Text("Bookings",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 13),),
                  )

                ],
              ),
            ),

            DefaultTabController(
                length: 2, // length of tabs
                initialIndex: 0,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Container(
                        color: Colors.white,
                        child: TabBar(
                          labelStyle: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),
                          indicatorColor: Colors.black,
                          indicator: UnderlineTabIndicator(
                            borderSide: BorderSide(width: 4.0),
                          ),
                          labelColor: Colors.black,
                          unselectedLabelColor: Colors.grey,
                          tabs: [
                            Tab(text: 'Active'),
                            Tab(text: 'History'),
                          ],
                        ),
                      ),
                      Container( //height of TabBarView
                          height: MediaQuery.of(context).size.height*0.74,

                          child: TabBarView(children: <Widget>[
                            FutureBuilder<List<BookingModel>>(
                              future: getUserBookings(),
                              builder: (context,snapshot){
                                if(snapshot.hasData){
                                  if(snapshot.data!=null && snapshot.data.length>0){
                                    return ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.vertical,
                                      itemCount: snapshot.data.length,
                                      itemBuilder: (BuildContext context,int index){
                                        return Container(
                                          margin: EdgeInsets.only(top: 10,bottom: 5),
                                          padding: EdgeInsets.only(left: 10,right: 10),
                                          color: Colors.white,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              SizedBox(height: 10,),
                                              Text("PCR Test",style: TextStyle(fontWeight: FontWeight.w700),),
                                              SizedBox(height: 10,),
                                              Text("Booking ID : ${snapshot.data[index].id}",style: TextStyle(fontWeight: FontWeight.w400),),
                                              SizedBox(height: 10,),
                                              Divider(color: Colors.grey,thickness: 0.3,),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(snapshot.data[index].date,style: TextStyle(fontWeight: FontWeight.w300),),
                                                      Text(" - ",style: TextStyle(fontWeight: FontWeight.w900,fontSize: 18),),
                                                      Text(snapshot.data[index].time,style: TextStyle(fontWeight: FontWeight.w300),),
                                                    ],
                                                  ),
                                                  Container(
                                                    margin:EdgeInsets.all(5),
                                                    padding:EdgeInsets.only(left: 7,right: 7,top: 5,bottom: 5),
                                                    decoration: BoxDecoration(
                                                      color: Colors.yellow[600],
                                                      borderRadius: BorderRadius.circular(20),
                                                    ),
                                                    child: Text(snapshot.data[index].status,style: TextStyle(fontSize:12,color: Colors.white),),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 10,),

                                            ],
                                          ),
                                        );
                                      },

                                    );
                                  }
                                  else {
                                    return new Container(
                                      child: Center(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Image.asset("assets/images/empty.png",width: 150,height: 150,),
                                              Text('Your active bookings will appear here', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300)),
                                            ],
                                          )
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
                            FutureBuilder<List<BookingModel>>(
                              future: getHistory(),
                              builder: (context,snapshot){
                                if(snapshot.hasData){
                                  if(snapshot.data!=null && snapshot.data.length>0){
                                    return ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.vertical,
                                      itemCount: snapshot.data.length,
                                      itemBuilder: (BuildContext context,int index){
                                        return Container(
                                          margin: EdgeInsets.only(top: 10,bottom: 5),
                                          padding: EdgeInsets.only(left: 10,right: 10),
                                          color: Colors.white,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              SizedBox(height: 10,),
                                              Text("PCR Test",style: TextStyle(fontWeight: FontWeight.w700),),
                                              SizedBox(height: 10,),
                                              Text("Booking ID : ${snapshot.data[index].id}",style: TextStyle(fontWeight: FontWeight.w400),),
                                              SizedBox(height: 10,),
                                              Divider(color: Colors.grey,thickness: 0.3,),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(snapshot.data[index].date,style: TextStyle(fontWeight: FontWeight.w300),),
                                                      Text(" - ",style: TextStyle(fontWeight: FontWeight.w900,fontSize: 18),),
                                                      Text(snapshot.data[index].time,style: TextStyle(fontWeight: FontWeight.w300),),
                                                    ],
                                                  ),
                                                  Container(
                                                    margin:EdgeInsets.all(5),
                                                    padding:EdgeInsets.only(left: 7,right: 7,top: 5,bottom: 5),
                                                    decoration: BoxDecoration(
                                                      color: Colors.yellow[600],
                                                      borderRadius: BorderRadius.circular(20),
                                                    ),
                                                    child: Text(snapshot.data[index].status,style: TextStyle(fontSize:12,color: Colors.white),),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 10,),

                                            ],
                                          ),
                                        );
                                      },

                                    );
                                  }
                                  else {
                                    return new Container(
                                      child: Center(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Image.asset("assets/images/empty.png",width: 150,height: 150,),
                                              Text('Your history bookings will appear here', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300)),
                                            ],
                                          )
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

                          ])
                      )

                ])
            ),
          ]),
        ),
      ),
    );
  }

  /*@override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      child: ListView(
        children: [
          // give the tab bar a height [can change hheight to preferred height]
          Container(
            height: 45,
            child: TabBar(
              controller: _tabController,
              // give the indicator a decoration (color and border radius)
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  25.0,
                ),
                color: Colors.green,
              ),
              labelColor: Colors.white,
              unselectedLabelColor: Colors.black,
              tabs: [
                // first tab [you can add an icon using the icon property]
                Tab(
                  text: 'Place Bid',
                ),

                // second tab [you can add an icon using the icon property]
                Tab(
                  text: 'Buy Now',
                ),
              ],
            ),
          ),
          // tab bar view here
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // first tab bar view widget
                Center(
                  child: Text(
                    'Place Bid',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                // second tab bar view widget
                Center(
                  child: Text(
                    'Buy Now',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }*/

  /*@override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        initialIndex: 0,
        length: 2,
        child: Scaffold(
          body: Container(
            height: double.maxFinite,
            child: Column(
              children: [
                Container(
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(width: 0.2, color: Colors.grey[500]),
                    ),

                  ),
                  child: Stack(
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 15),
                        alignment: Alignment.centerLeft,
                        child: Icon(Icons.arrow_back,color: primaryColor,),
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: Text("Bookings",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 13),),
                      )

                    ],
                  ),
                ),
                Container(
                  height: 100,
                  child: TabBar(
                    controller: _tabController,
                    tabs: [
                      Tab(text:"Booking"),
                      Tab(text: "History",),

                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      Icon(Icons.directions_car),
                      Icon(Icons.directions_transit)
                    ],
                  ),
                )
              ],
            ),
          )
        )
      )
    );
  }*/
}
