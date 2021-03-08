import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../data/values.dart';
class ServiceDetail extends StatefulWidget {
  @override
  _ServiceDetailState createState() => _ServiceDetailState();
}

class _ServiceDetailState extends State<ServiceDetail> {
  String detailtitle="Please read below applicable Terms & Conditions";
  String detail="Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean vulputate ex a massa accumsan, quis volutpat massa iaculis. Etiam elit erat, ullamcorper ut ipsum quis, imperdiet ornare lacus. Fusce dictum enim leo. Aenean pulvinar dapibus dapibus. Cras commodo, nunc non scelerisque ultrices, massa turpis convallis velit, scelerisque commodo lorem nunc eget ante. Integer justo justo, sodales vitae molestie id, tincidunt nec neque. Morbi eget pharetra massa. Pellentesque bibendum velit vel est dapibus mollis.";
  IconData icon=Icons.keyboard_arrow_down;
  bool isExpanded=false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Stack(
          children: [

            ListView(
              children: [
                Stack(
                  children: [
                    Image.asset("assets/images/placeholder.png",height: 200,width: double.maxFinite,fit: BoxFit.cover,),
                    Container(
                      margin: EdgeInsets.only(top: 180),
                        width: double.maxFinite,
                      decoration: BoxDecoration(
                        color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          )
                      ),
                      child: Container(
                        margin: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 10,),
                            Text(
                              "PCR Test",
                              style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700),
                              textAlign: TextAlign.start,
                            ),
                            SizedBox(height: 20,),
                            Text(
                              isExpanded?detail:detailtitle,
                              style: TextStyle(fontSize: 13,fontWeight: FontWeight.w300),
                              textAlign: TextAlign.start,
                            ),
                            Container(
                              child: IconButton(
                                  onPressed: (){
                                    setState(() {
                                      if(isExpanded)
                                        isExpanded=false;
                                      else
                                        isExpanded=true;

                                    });
                                  },
                                  icon: isExpanded?Icon(Icons.keyboard_arrow_up,color: primaryColor,):
                                  Icon(Icons.keyboard_arrow_down,color: primaryColor,)
                              ),
                              alignment: Alignment.bottomRight,
                            ),
                            ListView.builder(
                              itemCount: 2,
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context,int index){
                                return Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                      top: BorderSide(width: 0.2, color: Colors.grey[500])
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                     Expanded(
                                       child: Container(
                                         margin: EdgeInsets.all(10),
                                         child: Column(
                                           crossAxisAlignment: CrossAxisAlignment.start,
                                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                           children: [
                                             Text(
                                               "Service Title",
                                               style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600),
                                               textAlign: TextAlign.start,
                                             ),
                                             Text(
                                               "price",
                                               style: TextStyle(fontSize: 12,fontWeight: FontWeight.w300),
                                               textAlign: TextAlign.start,
                                             ),
                                           ],
                                         ),
                                       )
                                     ),
                                      Expanded(
                                        child: Container(
                                          alignment: Alignment.center,

                                          margin: EdgeInsets.only(left: 5,right: 5),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                margin: EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 10),
                                                child: Text(
                                                  "Add Service",
                                                  style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500),
                                                  textAlign: TextAlign.start,
                                                ),
                                              ),
                                              Container(
                                                alignment: Alignment.centerRight,
                                                child: Icon(Icons.add),

                                                decoration: BoxDecoration(


                                                    borderRadius: BorderRadius.only(
                                                      topRight: Radius.circular(20),
                                                      bottomRight: Radius.circular(20),
                                                    )
                                                ),
                                              ),
                                            ],
                                          ),
                                          decoration: BoxDecoration(
                                              border: Border.all(color: primaryColor,width: 2),
                                              borderRadius: BorderRadius.circular(20)
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              },
                            ),

                          ],
                        ),
                      )
                    )
                  ],
                ),
                SizedBox(height:30,),
                Container(
                  padding: EdgeInsets.all(10),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Other services you may also like to add...",
                        style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600),
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(height:20,),
                      Container(
                        height: 250,
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: 2,
                          itemBuilder: (BuildContext context,int index){
                            return Container(
                              width: 200,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey,
                                    offset: Offset(0.0, 1.0), //(x,y)
                                    blurRadius: 6.0,
                                  ),
                                ],
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(3),
                              ),
                              margin: EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height:30,),
                                  Text(
                                    "Other Service Category",
                                    style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600,color: primaryColor),
                                    textAlign: TextAlign.start,
                                  ),
                                  SizedBox(height:20,),
                                  Text(
                                    "Other Service Title",
                                    style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600),
                                    textAlign: TextAlign.start,
                                  ),
                                  SizedBox(height:20,),
                                  Text(
                                    "Price",
                                    style: TextStyle(fontSize: 13,fontWeight: FontWeight.w300),
                                    textAlign: TextAlign.start,
                                  ),
                                  SizedBox(height:20,),
                                  Container(
                                    width: 140,
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.only(left: 5,right: 5),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 10),
                                          child: Text(
                                            "Add Service",
                                            style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500),
                                            textAlign: TextAlign.start,
                                          ),
                                        ),
                                        Container(
                                          alignment: Alignment.centerRight,
                                          child: Icon(Icons.add),

                                          decoration: BoxDecoration(


                                              borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(20),
                                                bottomRight: Radius.circular(20),
                                              )
                                          ),
                                        ),
                                      ],
                                    ),
                                    decoration: BoxDecoration(
                                        border: Border.all(color: primaryColor,width: 2),
                                        borderRadius: BorderRadius.circular(20)
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),


              ],
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                margin: EdgeInsets.all(10),
                child: Container(
                  padding: EdgeInsets.all(5),
                  margin: EdgeInsets.all(10),
                  child: Icon(
                    Icons.arrow_back,
                    color: primaryColor,
                  ),
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
              ),
            ),
          ],
        ),
      )
    );
  }
}
