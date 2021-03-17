import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../data/values.dart';
import '../../model/offeredServiceModel.dart';
import '../../model/service_list.dart';
import 'package:firebase_database/firebase_database.dart';
import '../checkout_form/service_form_details.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rizek/model/country_codes.dart';
import '../../intro/otp.dart';
class ServiceDetail extends StatefulWidget {
  OfferedServiceModel offeredServiceModel;
  String serviceId,categoryId;


  ServiceDetail(this.serviceId,this.categoryId,this.offeredServiceModel);

  @override
  _ServiceDetailState createState() => _ServiceDetailState();
}

class _ServiceDetailState extends State<ServiceDetail> {
  String detailtitle="Please read below applicable Terms & Conditions";
  String detail="Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean vulputate ex a massa accumsan, quis volutpat massa iaculis. Etiam elit erat, ullamcorper ut ipsum quis, imperdiet ornare lacus. Fusce dictum enim leo. Aenean pulvinar dapibus dapibus. Cras commodo, nunc non scelerisque ultrices, massa turpis convallis velit, scelerisque commodo lorem nunc eget ante. Integer justo justo, sodales vitae molestie id, tincidunt nec neque. Morbi eget pharetra massa. Pellentesque bibendum velit vel est dapibus mollis.";
  IconData icon=Icons.keyboard_arrow_down;
  final databaseReference = FirebaseDatabase.instance.reference();
  bool isExpanded=false;
  bool isDataLoaded=false;
  String serviceCount="Add Service";
  int price=0;
  bool cartPopUpScreen=false;
  bool cartDetailPopUpScreen=false;
  int counter=0;
  List<ServiceListModel> serviceList=[];
  List<String> serviceCountList=[];
  List<int> counterList=[];
  List<bool> containerList=[];
  List<IconData> iconList=[];
  List<ServiceListModel> selectedServicesList=[];


  bool first=true;
  CountryCodes _countryCodes;

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


  getServiceList() async {
    List<ServiceListModel> list=new List();
    await databaseReference.child("service").child(widget.serviceId).child("categories").child(widget.categoryId).child("servicesOffered")
        .child(widget.offeredServiceModel.id).child("servicelist").once().then((DataSnapshot dataSnapshot){

      var KEYS= dataSnapshot.value.keys;
      var DATA=dataSnapshot.value;

      for(var individualKey in KEYS){
        ServiceListModel serviceListModel = new ServiceListModel(
            individualKey,
            DATA[individualKey]['price'],
          DATA[individualKey]['title']
        );
        print("key ${serviceListModel.title}");
        list.add(serviceListModel);
        serviceCountList.add("Add Service");
        counterList.add(0);
        containerList.add(false);
        iconList.add(null);



      }
    });
    setState(() {
      isDataLoaded=true;
      serviceList=list;
    });
    //return list;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getServiceList();
  }

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
                    Image.network(widget.offeredServiceModel.image,height: 200,width: double.maxFinite,fit: BoxFit.cover,),
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
                              widget.offeredServiceModel.name,
                              style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700),
                              textAlign: TextAlign.start,
                            ),
                            SizedBox(height: 20,),
                            Text(
                              isExpanded?widget.offeredServiceModel.description:detailtitle,
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
                            isDataLoaded?ListView.builder(
                              itemCount: serviceList.length,
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
                                               serviceList[index].title,
                                               style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600),
                                               textAlign: TextAlign.start,
                                             ),
                                             Text(
                                               "AED ${serviceList[index].price}",
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

                                          margin: EdgeInsets.only(left: 5,right: 5,top: 10,bottom: 10),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              AnimatedContainer(
                                                width: containerList[index] ? 50.0 : 0.0,
                                                duration: const Duration(seconds: 1),
                                                curve: Curves.fastOutSlowIn,
                                                child: IconButton(
                                                  icon: Icon(iconList[index]),
                                                  onPressed: (){
                                                    print("pp");
                                                    setState(() {
                                                      if(counterList[index]>1){
                                                        counterList[index]--;
                                                        price-=serviceList[index].price;
                                                        serviceCountList[index]=counterList[index].toString();
                                                      }
                                                      else{
                                                        iconList[index]=null;
                                                        counterList[index]=0;
                                                        price-=serviceList[index].price;
                                                        containerList[index]=false;
                                                        if(price<=0){
                                                          cartPopUpScreen=false;
                                                        }
                                                        selectedServicesList.removeWhere((element) => element.id==serviceList[index].id);
                                                        serviceCountList[index]="Add Service";
                                                      }


                                                    });
                                                  },
                                                ),
                                              ),
                                              Container(
                                                alignment:Alignment.center,
                                                margin: EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 10),
                                                child: Text(
                                                  serviceCountList[index],
                                                  style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500),
                                                  textAlign: TextAlign.start,
                                                ),
                                              ),
                                              Container(
                                                alignment: Alignment.centerRight,
                                                child:IconButton(
                                                  icon:  Icon(Icons.add),
                                                  onPressed: (){
                                                    setState(() {
                                                      if(counterList[index]>=0){
                                                        counterList[index]++;
                                                        price+=serviceList[index].price;
                                                        containerList[index]=true;
                                                        iconList[index]=Icons.remove;
                                                        serviceCountList[index]=counterList[index].toString();
                                                        if(price>0){
                                                          cartPopUpScreen=true;
                                                        }
                                                        if(counterList[index]==1){
                                                          selectedServicesList.add(serviceList[index]);
                                                        }
                                                      }

                                                    });
                                                  },
                                                ),

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
                            ):CircularProgressIndicator(),

                          ],
                        ),
                      )
                    )
                  ],
                ),
                SizedBox(height:30,),
                /*Container(
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
                ),*/


              ],
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                margin: EdgeInsets.all(10),
                child: GestureDetector(
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
                  onTap:()=>Navigator.pop(context),
                )
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: AnimatedContainer(
                duration: const Duration(seconds: 1),
                curve: Curves.fastOutSlowIn,
                height: cartPopUpScreen?100:0,
                color: Colors.white,
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: (){

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
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  child: Column(
                                    children: [
                                      Container(
                                        height: MediaQuery.of(context).size.height*0.04,
                                        child: Text("Your Basket",style: TextStyle(fontWeight: FontWeight.w700),),
                                      ),
                                      Container(
                                        height: MediaQuery.of(context).size.height*0.15,
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: selectedServicesList.length,
                                          itemBuilder: (BuildContext context,int index){
                                            return Container(
                                              margin: EdgeInsets.all(5),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(selectedServicesList[index].title,style: TextStyle(fontWeight: FontWeight.w400),),
                                                  GestureDetector(
                                                    child: Text("AED ${selectedServicesList[index].price}",style: TextStyle(fontWeight: FontWeight.w600),),
                                                    onTap: null,
                                                  )
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      GestureDetector(
                                        child: Container(
                                          height: MediaQuery.of(context).size.height*0.11,
                                          margin: EdgeInsets.all(10),
                                          padding: EdgeInsets.all(10),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text("AED ${price}",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w700,fontSize: 18),),
                                              Text("Excluding VAT",style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w300,fontSize: 13),),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Text("Hide Items",style: TextStyle(color: Colors.black,fontSize: 13),),
                                                  Icon(Icons.keyboard_arrow_down,color: primaryColor,size: 20,),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                        onTap: (){
                                          Navigator.pop(context);
                                        },
                                      )

                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.all(10),
                          padding: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("AED ${price}",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w700,fontSize: 18),),
                              Text("Excluding VAT",style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w300,fontSize: 13),),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text("View Items",style: TextStyle(color: Colors.black,fontSize: 13),),
                                  Icon(Icons.keyboard_arrow_up,color: primaryColor,size: 20,),
                                ],
                              )
                            ],
                          ),
                        ),
                      )
                    ),
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: ()async{
                          User user=await FirebaseAuth.instance.currentUser;
                          if(user!=null){
                            Navigator.push(context, new MaterialPageRoute(
                                builder: (context) => ServiceFormDetail(price,selectedServicesList,widget.offeredServiceModel.id,widget.categoryId)));
                          }
                          else{
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
                                      top: MediaQuery.of(context).size.height*0.7,
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

                        },
                        child: Container(
                          margin: EdgeInsets.all(10),
                          padding: EdgeInsets.all(10),
                          height: 50,
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(10)
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Proceed",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 16),),
                              Icon(Icons.arrow_forward,color: Colors.white,size: 20,),
                            ],
                          )

                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      )
    );
  }
}
