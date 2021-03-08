import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../data/values.dart';
import 'edit_profile.dart';
import 'saved_address.dart';
import 'payment_method.dart';
import 'contact_us.dart';
class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
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
                  "User Name",
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w600
                  ),
                ),
                SizedBox(height: 18,),
                Text(
                  "phone number",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w300
                  ),
                ),
                SizedBox(height: 10,),
                Text(
                  "email address",
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
                  builder: (context) => EditProfile()));
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
                  builder: (context) => SavedAddress()));
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
            onTap: (){
              Navigator.push(context, new MaterialPageRoute(
                  builder: (context) => Profile()));
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
            onTap: (){
              Navigator.push(context, new MaterialPageRoute(
                  builder: (context) => Profile()));
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
            onTap: (){
              Navigator.push(context, new MaterialPageRoute(
                  builder: (context) => Profile()));
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
              Navigator.push(context, new MaterialPageRoute(
                  builder: (context) => Profile()));
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
      ),
    );
  }
}
