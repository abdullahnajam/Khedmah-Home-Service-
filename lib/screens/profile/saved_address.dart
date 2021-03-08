import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../data/values.dart';
class SavedAddress extends StatefulWidget {
  @override
  _SavedAddressState createState() => _SavedAddressState();
}

class _SavedAddressState extends State<SavedAddress> {
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
                  child: Text("Saved Address",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 13),),
                ),
                Container(
                  margin: EdgeInsets.only(right: 15),
                  alignment: Alignment.centerRight,
                  child: Text("Edit",style: TextStyle(fontWeight: FontWeight.w400,fontSize: 14,color: primaryColor),),
                )

              ],
            ),
          ),
          SizedBox(height: 20,),
          GestureDetector(
            onTap: (){

            },
            child: Container(
              height: 40,
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      margin: EdgeInsets.all(5),
                      padding: EdgeInsets.all(5),
                      child: Icon(Icons.add,color: Colors.white,size: 15,),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(0.0, 1.0), //(x,y)
                            blurRadius: 6.0,
                          ),
                        ],
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(120),
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 8,
                      child: Container(
                        margin: EdgeInsets.only(left: 15),
                        alignment: Alignment.centerLeft,
                        child: Text("Add another address",style: TextStyle(fontWeight: FontWeight.w400,fontSize: 14,color: primaryColor),),
                      )
                  ),
                  Expanded(
                      flex: 1,
                      child: Container(
                        margin: EdgeInsets.only(right: 15),
                        alignment: Alignment.center,
                        child: Icon(Icons.chevron_right,color: primaryColor,),
                      )
                  )
                ],
              ),
            )
          )
        ],
      ),
    );
  }
}
