import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import '../../data/values.dart';
import '../../model/user.dart';
import 'package:country_code_picker/country_code_picker.dart';
class EditProfile extends StatefulWidget {
  UserData user;

  EditProfile(this.user);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final nameController=TextEditingController();
  final surnameController=TextEditingController();
  final phoneNumberController=TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      nameController.text=widget.user.name;
      widget.user.surname=="none"?"nothing":surnameController.text=widget.user.surname;
      phoneNumberController.text=widget.user.phoneNumber;
    });
  }

  bool isGender=true;
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
                  child: Text("Edit Profile",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 13),),
                ),
                Container(
                  margin: EdgeInsets.only(right: 15),
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap: (){
                      final databaseReference = FirebaseDatabase.instance.reference();
                      databaseReference.child("User").child(widget.user.id).update({
                        'name': nameController.text,
                        'surname': surnameController.text==""?'none':surnameController.text,
                        'gender': isGender?'female':'male',

                      }).then((value) => Toast.show("Saved", context, duration: Toast.LENGTH_LONG, gravity:  Toast.TOP))
                          .catchError((error, stackTrace) {
                        print("inner: $error");
                        // although `throw SecondError()` has the same effect.
                        return Toast.show("Error : $error", context, duration: Toast.LENGTH_LONG, gravity:  Toast.TOP);
                      });
                    },
                    child: Text("Save",style: TextStyle(fontWeight: FontWeight.w400,fontSize: 14,color: primaryColor),),
                  )
                )

              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(width: 0.2, color: Colors.grey[500]),
                bottom: BorderSide(width: 0.2, color: Colors.grey[500]),
              ),

            ),
            margin: EdgeInsets.only(left: 15,right: 15,top: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20,),
                Container(
                  margin: EdgeInsets.only(top: 15),
                  child: Text("Given Name",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 13),),
                ),
                Container(

                  child: TextField(
                    controller: nameController,
                    style: TextStyle(fontWeight: FontWeight.w400,fontSize: 18),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(bottom:-20.0),
                        hintText: "Name",
                        hintStyle: TextStyle(fontWeight: FontWeight.w400,fontSize: 18)
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                Container(
                  margin: EdgeInsets.only(top: 15),
                  child: Text("Surname (Optional)",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 13),),
                ),
                Container(

                  child: TextField(
                    controller: surnameController,
                    style: TextStyle(fontWeight: FontWeight.w400,fontSize: 18),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(bottom:-20.0),
                        hintText: "Your Surname",
                        hintStyle: TextStyle(fontWeight: FontWeight.w400,fontSize: 18)
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                Container(
                  margin: EdgeInsets.only(top: 15),
                  child: Text("Gender (Optional)",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 13),),
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: (){
                          setState(() {
                            isGender=true;
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.all(10),
                          alignment: Alignment.center,
                          height: 50,
                          decoration: BoxDecoration(
                            color: isGender?backgroundColor:Colors.white,
                            border: Border.all(
                                width: 1, color: isGender?primaryColor:Colors.grey[300]
                            ),
                            borderRadius: BorderRadius.circular(5)
                          ),
                          child: Text(
                            "Female",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18,color: isGender?primaryColor:Colors.black),),
                        ),
                      )
                    ),
                    Expanded(
                        flex: 1,
                        child: GestureDetector(
                          onTap: (){
                            setState(() {
                              isGender=false;
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.all(10),
                            alignment: Alignment.center,
                            height: 50,
                            decoration: BoxDecoration(
                                color: !isGender?backgroundColor:Colors.white,
                                border: Border.all(
                                    width: 1, color: !isGender?primaryColor:Colors.grey[300]
                                ),
                                borderRadius: BorderRadius.circular(5)
                            ),
                            child: Text(
                              "Male",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18,color: !isGender?primaryColor:Colors.black),),
                          ),
                        )
                    )
                  ],
                ),
                SizedBox(height: 10,),
                Container(
                  margin: EdgeInsets.only(top: 15),
                  child: Text("Phone Number",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 13),),
                ),
                Container(
                    padding:EdgeInsets.only(top: 10),
                    height: 100,
                    width: MediaQuery.of(context).size.width,
                    child:  Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            CountryCodePicker(
                              textStyle: TextStyle(fontSize: 20,fontWeight: FontWeight.w400),
                              onChanged: print,
                              initialSelection: widget.user.countryCode,
                              favorite: [widget.user.phoneCode,widget.user.countryCode],
                              // optional. Shows only country name and flag
                              showCountryOnly: false,
                              // optional. Shows only country name and flag when popup is closed.
                              showOnlyCountryWhenClosed: false,
                              // optional. aligns the flag and the Text left
                              alignLeft: false,
                            ),
                            SizedBox(width: 10,),
                            Expanded(
                              child: TextFormField(
                                controller: phoneNumberController,
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
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 15,right: 15,top: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 15),
                  child: Text("Email",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 13),),
                ),
                SizedBox(height: 10,),
                Text(
                  widget.user.email,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w300
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}


