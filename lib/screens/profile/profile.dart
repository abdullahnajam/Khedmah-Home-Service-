import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rizek/google_map_select_place.dart';
import '../../data/values.dart';
import 'edit_profile.dart';
import 'saved_address.dart';
import 'payment_method.dart';
import 'contact_us.dart';
import '../../model/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../intro/onboarding.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:url_launcher/url_launcher.dart';

class Profile extends StatefulWidget {
  String uid;

  Profile(this.uid);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String _url = "https://www.google.com/";
  final databaseReference = FirebaseDatabase.instance.reference();

  Future<UserData> getUserData() async {
    UserData user = null;
    await databaseReference.child("User").child(widget.uid).once().then((
        DataSnapshot dataSnapshot) {
      user = UserData.fromJson(dataSnapshot.value);
      user.id = widget.uid;
    });

    return user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: widget.uid!=null?FutureBuilder<UserData>(
          future: getUserData(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data != null) {
                return ListView(
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
                          GestureDetector(
                            onTap: (){
                              Navigator.pop(context);
                            },
                            child: Container(
                              margin: EdgeInsets.only(left: 15),
                              alignment: Alignment.centerLeft,
                              child: Icon(Icons.arrow_back,color: primaryColor,),
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            child: Text("Profile",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 13),),
                          )

                        ],
                      ),
                    ),
                    Container(
                      margin:EdgeInsets.all(15),
                      child:Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 20,),
                          Text(
                            snapshot.data.name,
                            style: TextStyle(
                                fontSize: 23,
                                fontWeight: FontWeight.w600
                            ),
                          ),
                          SizedBox(height: 18,),
                          Text(
                              "${snapshot.data.phoneCode}${snapshot.data.phoneNumber}",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w300
                            ),
                          ),
                          SizedBox(height: 10,),
                          Text(
                            snapshot.data.email,
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w300
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, new MaterialPageRoute(
                            builder: (context) => EditProfile(snapshot.data)));
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 2),
                        padding:EdgeInsets.all(15),
                        color: Colors.white,
                        child:Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Edit Profile",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400
                              ),
                            ),
                            Icon(Icons.chevron_right,color: primaryColor,),

                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, new MaterialPageRoute(
                            builder: (context) => SavedAddress(widget.uid)));
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 2),
                        padding:EdgeInsets.all(15),
                        color: Colors.white,
                        child:Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Saved Addresses",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400
                              ),
                            ),
                            Icon(Icons.chevron_right,color: primaryColor,),

                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, new MaterialPageRoute(
                            builder: (context) => PaymentMethod()));
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 15),
                        padding:EdgeInsets.all(15),
                        color: Colors.white,
                        child:Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Payment Method",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400
                              ),
                            ),
                            Icon(Icons.chevron_right,color: primaryColor,),

                          ],
                        ),
                      ),
                    ),


                    GestureDetector(
                      onTap: ()async{
                        await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 2),
                        padding:EdgeInsets.all(15),
                        color: Colors.white,
                        child:Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Privacy Policy",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400
                              ),
                            ),
                            Icon(Icons.chevron_right,color: primaryColor,),

                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: ()async{
                        await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 2),
                        padding:EdgeInsets.all(15),
                        color: Colors.white,
                        child:Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Terms and Condition",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400
                              ),
                            ),
                            Icon(Icons.chevron_right,color: primaryColor,),

                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, new MaterialPageRoute(
                            builder: (context) => ContactUs()));
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 2),
                        padding:EdgeInsets.all(15),
                        color: Colors.white,
                        child:Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Contact Us",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400
                              ),
                            ),
                            Icon(Icons.chevron_right,color: primaryColor,),

                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: ()async{
                        await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 15),
                        padding:EdgeInsets.all(15),
                        color: Colors.white,
                        child:Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "About Us",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400
                              ),
                            ),
                            Icon(Icons.chevron_right,color: primaryColor,),

                          ],
                        ),
                      ),
                    ),


                    GestureDetector(
                      onTap: (){
                        FirebaseAuth.instance.signOut();
                        User user = FirebaseAuth.instance.currentUser;
                        runApp(
                            new MaterialApp(
                              home: OnBoarding(),
                            )
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 15),
                        padding:EdgeInsets.all(15),
                        color: Colors.white,
                        child:Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Log out",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400
                              ),
                            ),
                            Icon(Icons.chevron_right,color: primaryColor,),

                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }
              else {
                return new Center(
                  child: Container(
                    child: Text("No Data Found"),
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
        ):
        Container(
          child: ListView(
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
                    GestureDetector(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 15),
                        alignment: Alignment.centerLeft,
                        child: Icon(Icons.arrow_back,color: primaryColor,),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Text("Profile",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 13),),
                    )

                  ],
                ),
              ),

              GestureDetector(
                onTap: (){
                  Navigator.push(context, new MaterialPageRoute(
                      builder: (context) => OnBoarding()));
                },
                child: Container(
                  margin: EdgeInsets.only(bottom: 2),
                  padding:EdgeInsets.all(15),
                  color: Colors.white,
                  child:Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Login/Sign Up",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400
                        ),
                      ),
                      Icon(Icons.chevron_right,color: primaryColor,),

                    ],
                  ),
                ),
              ),


              GestureDetector(
                onTap: ()async{
                  await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';
                },
                child: Container(
                  margin: EdgeInsets.only(bottom: 2),
                  padding:EdgeInsets.all(15),
                  color: Colors.white,
                  child:Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Privacy Policy",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400
                        ),
                      ),
                      Icon(Icons.chevron_right,color: primaryColor,),

                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: ()async{
                  await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';
                },
                child: Container(
                  margin: EdgeInsets.only(bottom: 2),
                  padding:EdgeInsets.all(15),
                  color: Colors.white,
                  child:Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Terms and Condition",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400
                        ),
                      ),
                      Icon(Icons.chevron_right,color: primaryColor,),

                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: (){
                  Navigator.push(context, new MaterialPageRoute(
                      builder: (context) => ContactUs()));
                },
                child: Container(
                  margin: EdgeInsets.only(bottom: 2),
                  padding:EdgeInsets.all(15),
                  color: Colors.white,
                  child:Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Contact Us",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400
                        ),
                      ),
                      Icon(Icons.chevron_right,color: primaryColor,),

                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: ()async{
                  await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';
                },
                child: Container(
                  margin: EdgeInsets.only(bottom: 15),
                  padding:EdgeInsets.all(15),
                  color: Colors.white,
                  child:Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "About Us",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400
                        ),
                      ),
                      Icon(Icons.chevron_right,color: primaryColor,),

                    ],
                  ),
                ),
              ),

            ],
          ),
        )
    );
  }
}
