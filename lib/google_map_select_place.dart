import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'data/values.dart';
class GMAp extends StatefulWidget {
  @override
  _GMApState createState() => _GMApState();
}

class _GMApState extends State<GMAp> {
  final _formKey = GlobalKey<FormState>();
  final areaController=TextEditingController();
  final nameController=TextEditingController();
  final numberController=TextEditingController();
  LocationResult _pickedLocation;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: RaisedButton (
          onPressed: ()async{
            LocationResult result = await showLocationPicker(
              context,
              kGoogleApiKey,

            );
            print("result = ${result}");

            setState(() => _pickedLocation = result);
          },
        )
      )
    );
  }
}
