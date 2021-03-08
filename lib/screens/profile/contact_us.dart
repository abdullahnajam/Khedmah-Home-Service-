import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../data/values.dart';
class ContactUs extends StatefulWidget {
  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
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
                  child: Text("Contact",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 13),),
                ),


              ],
            ),
          ),
          SizedBox(height: 20,),
          Container(
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(width: 0.2, color: Colors.grey[500]),
                bottom: BorderSide(width: 0.2, color: Colors.grey[500]),
              ),

            ),
            child: Row(
              children: [
                Expanded(
                    flex: 1,
                    child: Container(
                      alignment: Alignment.center,
                      child: Icon(Icons.call_outlined,color: primaryColor,),
                    )
                ),
                Expanded(
                    flex: 9,
                    child: Container(
                      margin: EdgeInsets.only(left: 15),
                      alignment: Alignment.centerLeft,
                      child: Text("phone number",style: TextStyle(fontWeight: FontWeight.w400,fontSize: 14,color: primaryColor),),
                    )
                ),

              ],
            ),
          ),
          Container(
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(width: 0.2, color: Colors.grey[500]),
                bottom: BorderSide(width: 0.2, color: Colors.grey[500]),
              ),

            ),
            child: Row(
              children: [
                Expanded(
                    flex: 1,
                    child: Container(
                      alignment: Alignment.center,
                      child: Icon(Icons.email_outlined,color: primaryColor,),
                    )
                ),
                Expanded(
                    flex: 9,
                    child: Container(
                      margin: EdgeInsets.only(left: 15),
                      alignment: Alignment.centerLeft,
                      child: Text("email address",style: TextStyle(fontWeight: FontWeight.w400,fontSize: 14,color: primaryColor),),
                    )
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}
