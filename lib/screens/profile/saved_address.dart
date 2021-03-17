import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import '../../data/values.dart';
import 'package:geocoder/geocoder.dart';
import 'package:toast/toast.dart';
import '../../model/address.dart';
import 'package:firebase_database/firebase_database.dart';
const kGoogleApiKey = "AIzaSyBhCef5WuAuPKRVoPuWQASD6avTs16x7uE";
GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);
class SavedAddress extends StatefulWidget {
  String uid;

  SavedAddress(this.uid);

  @override
  _SavedAddressState createState() => _SavedAddressState();
}

class _SavedAddressState extends State<SavedAddress> {
  final _formKey = GlobalKey<FormState>();
  final areaController=TextEditingController();
  final nameController=TextEditingController();
  final numberController=TextEditingController();
  final databaseReference = FirebaseDatabase.instance.reference();
  List<AddressModel> list=[];
  getUserAddress() async {
    print("uid ${widget.uid}");
    await databaseReference.child("address").child(widget.uid).once().then((DataSnapshot dataSnapshot){
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
    });


    return list;
  }

  @override
  void initState() {
    super.initState();
    getUserAddress();
  }

  Future<void> _handlePressButton() async {
    // show input autocomplete with selected mode
    // then get the Prediction selected
    Prediction p = await PlacesAutocomplete.show(
      context: context,
      apiKey: kGoogleApiKey,
      onError: onError,
      mode: Mode.overlay,
      language: "fr",
      //components: [Component(Component.country, "ue")],
    );

    displayPrediction(p);
  }

  Future<Null> displayPrediction(Prediction p) async {
    if (p != null) {
      // get detail (lat/lng)
      PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(p.placeId);

      final lat = detail.result.geometry.location.lat;
      final lng = detail.result.geometry.location.lng;


      final coordinates = new Coordinates(1.10, 45.50);
      var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
      Address first = addresses.first;


      final address=detail.result.formattedAddress;
      showDialog<void>(
        context: context,
        barrierDismissible: true, // user must tap button!
        builder: (BuildContext context) {
          return Card(

            margin: EdgeInsets.only(
              top: MediaQuery.of(context).size.height*0.56,
            ),
            child: Form(
                key: _formKey,
                child: Container(
                  margin: EdgeInsets.all(10),
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.all(5),
                          child: Text(address,style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700),textAlign: TextAlign.center,),
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
                                  'addressLine': "${numberController.text}, ${nameController.text}, ${areaController.text}, $address",
                                  'area': areaController.text,
                                  'flatNo': numberController.text,
                                  'building': nameController.text,
                                  'lat': lat,
                                  'long': lng,


                                }).then((value) => Toast.show("Saved", context, duration: Toast.LENGTH_LONG, gravity:  Toast.TOP))
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
          );
        },
      );
      setState(() {
        //availabilityController.text=address;
      });


    }
  }
  void onError(PlacesAutocompleteResponse response) {

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
                    )
                  ],
                ),
              );
            },
          ),
          SizedBox(height: 20,),
          GestureDetector(
            onTap: (){
              _handlePressButton();
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
