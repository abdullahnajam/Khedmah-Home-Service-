import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:google_maps_webservice/places.dart';
import '../../data/values.dart';
import 'package:geocoder/geocoder.dart';
import 'package:toast/toast.dart';
import '../../model/address.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:firebase_database/firebase_database.dart';

GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);
class SavedAddress extends StatefulWidget {
  String uid;

  SavedAddress(this.uid);

  @override
  _SavedAddressState createState() => _SavedAddressState();
}

class _SavedAddressState extends State<SavedAddress> with SingleTickerProviderStateMixin{
  AnimationController _controller;
  Animation _animation;

  FocusNode _focusNode = FocusNode();
  String lat,lng,address;
  final _formKey = GlobalKey<FormState>();
  final areaController=TextEditingController();
  final nameController=TextEditingController();
  final numberController=TextEditingController();

  bool isEditable=false;
  final databaseReference = FirebaseDatabase.instance.reference();
  List<AddressModel> list=[];
  String changeButtonName="Edit";

  activateEditMode(){
    setState(() {
      changeButtonName="Save";
      isEditable=true;
    });
  }
  revertFromEditMode(){
    setState(() {
      changeButtonName="Edit";
      isEditable=false;
    });
  }

  getUserAddress() async {
    print("uid ${widget.uid}");
    //list.clear();
    await databaseReference.child("address").child(widget.uid).once().then((DataSnapshot dataSnapshot){
      if(dataSnapshot!=null){
        var KEYS= dataSnapshot.value.keys;
        var DATA=dataSnapshot.value;

        for(var individualKey in KEYS){
          AddressModel addressModel = new AddressModel(
              individualKey,
              DATA[individualKey]['addressLine']
          );
          setState(() {
            list.add(addressModel);
          });

        }
      }
    });

    if(list.isEmpty){
      list=[];
    }
    return list;
  }
  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getUserAddress();
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _animation = Tween(begin: 300.0, end: 50.0).animate(_controller)
      ..addListener(() {
        setState(() {});
      });

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

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
                  onTap: ()=>Navigator.pop(context)
                ),
                Container(
                  alignment: Alignment.center,
                  child: Text("Saved Address",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 13),),
                ),
                GestureDetector(
                  onTap: (){
                    if(changeButtonName=="Edit"){
                      activateEditMode();
                    }
                    else{
                      revertFromEditMode();
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 15),
                    alignment: Alignment.centerRight,
                    child: Text(changeButtonName,style: TextStyle(fontWeight: FontWeight.w400,fontSize: 14,color: primaryColor),),
                  ),
                )

              ],
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: list.length,
            itemBuilder: (BuildContext context,int index){
              return Container(
                margin: EdgeInsets.only(top: 5,bottom: 5),
                color: Colors.white,
                child: Row(
                  children: [
                    Icon(Icons.place,color: primaryColor,),
                    Expanded(
                      child: Text(list[index].addressLine),
                    ),
                    AnimatedContainer(
                        duration: const Duration(seconds: 1),
                        curve: Curves.fastOutSlowIn,
                      width: isEditable?50:0,
                      child:  GestureDetector(
                        child: Container(
                          margin: EdgeInsets.only(right: 20),
                          child: Icon(Icons.delete_forever_outlined,color: Colors.red,size: 27,),
                        ),
                        onTap: (){
                          FirebaseDatabase.instance.reference()
                              .child('address')
                              .child(widget.uid)
                              .child(list[index].id)
                              .remove().then((value){
                               setState(() {
                                 list.removeAt(index);
                                 revertFromEditMode();
                               });
                          });
                        },
                      )

                    )
                  ],
                ),
              );
            },
          ),
          SizedBox(height: 20,),
          GestureDetector(
            onTap: ()async{
              LocationResult result = await showLocationPicker(
                context,
                kGoogleApiKey,

              );
              print("result = ${result}");
              if(result!=null){
                showDialog<void>(
                  context: context,
                  barrierDismissible: true, // user must tap button!
                  builder: (BuildContext context) {
                    return StatefulBuilder(
                      builder: (context,setState){
                        return Card(
                          margin: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height*0.15,
                            bottom: MediaQuery.of(context).size.height*0.35,
                            left: MediaQuery.of(context).size.height*0.02,
                            right: MediaQuery.of(context).size.height*0.02,
                          ),
                          child: Scaffold(
                            resizeToAvoidBottomPadding: false,
                            body: Form(
                                key: _formKey,
                                child: Container(
                                  margin: EdgeInsets.all(10),
                                  child: ListView(
                                    shrinkWrap: true,
                                    children: [
                                      Container(
                                        alignment: Alignment.center,
                                        margin: EdgeInsets.all(5),
                                        child: Text(result.address,style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700),textAlign: TextAlign.center,),
                                      ),
                                      TextFormField(

                                        controller: areaController,
                                        decoration: InputDecoration(
                                            hintText: "Area"
                                        ),
                                        // The validator receives the text that the user has entered.
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return 'Enter Area';
                                          }
                                          return null;
                                        },
                                      ),
                                      SizedBox(height: 10,),
                                      TextFormField(
                                        controller: nameController,
                                        decoration: InputDecoration(
                                            hintText: "Building/Villa Name"
                                        ),
                                        // The validator receives the text that the user has entered.
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return 'Enter Name';
                                          }
                                          return null;
                                        },
                                      ),
                                      SizedBox(height: 10,),
                                      TextFormField(
                                        controller: numberController,
                                        decoration: InputDecoration(
                                            hintText: "Flat / Villa No"
                                        ),
                                        // The validator receives the text that the user has entered.
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return 'Enter number';
                                          }
                                          return null;
                                        },
                                      ),
                                      SizedBox(height: 10,),
                                      Container(
                                        padding:EdgeInsets.only(top: 10,bottom: 10,left: 30,right: 30),
                                        height: 60,
                                        width: MediaQuery.of(context).size.width,
                                        child:  RaisedButton(
                                          color: primaryColor,
                                          onPressed: (){
                                            if (_formKey.currentState.validate()) {
                                              final databaseReference = FirebaseDatabase.instance.reference();
                                              databaseReference.child("address").child(widget.uid).push().set({
                                                'addressLine': "${numberController.text}, ${nameController.text}, ${result.address}",
                                                'area': areaController.text,
                                                'flatNo': numberController.text,
                                                'building': nameController.text,
                                                'lat': result.latLng.latitude,
                                                'long': result.latLng.longitude,


                                              }).then((value) {
                                                Toast.show("Saved", context, duration: Toast.LENGTH_LONG, gravity:  Toast.TOP);
                                                Navigator.pushReplacement(context, new MaterialPageRoute(
                                                    builder: (context) => SavedAddress(widget.uid)));
                                              })
                                                  .catchError((error, stackTrace) {
                                                print("inner: $error");
                                                // although `throw SecondError()` has the same effect.
                                                return Toast.show("Error : $error", context, duration: Toast.LENGTH_LONG, gravity:  Toast.TOP);
                                              });
                                            }
                                          },
                                          child: Text("Save Address",textAlign: TextAlign.center,style: TextStyle(color: Colors.white,fontWeight: FontWeight.w400,fontSize: 12),),
                                        ),

                                      ),

                                    ],
                                  ),
                                )
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              }
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
