import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../data/values.dart';
class PaymentMethod extends StatefulWidget {
  @override
  _PaymentMethodState createState() => _PaymentMethodState();
}

class _PaymentMethodState extends State<PaymentMethod> {
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
                GestureDetector(
                  child: Container(
                    margin: EdgeInsets.only(left: 15),
                    alignment: Alignment.centerLeft,
                    child: Icon(Icons.arrow_back,color: primaryColor,),
                  ),
                  onTap: ()=>Navigator.pop(context),
                ),
                Container(
                  alignment: Alignment.center,
                  child: Text("Payment Method",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 13),),
                ),


              ],
            ),
          ),
          
        ],
      ),
    );
  }
}
