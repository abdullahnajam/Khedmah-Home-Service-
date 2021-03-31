import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import '../../data/values.dart';
import '../../model/user.dart';
import '../../model/country_codes.dart';
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
  bool first=true;
  String countryImageUrl=null;
  String countryCode=null;
  CountryCodes _countryCodes;

  final databaseReference = FirebaseDatabase.instance.reference();
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
    for(int i=0;i<list.length;i++){
      print(widget.user.phoneCode);
      print(list[i].code);
      if(widget.user.phoneCode==list[i].code){
        _countryCodes=list[i];
      }
    }

    return list;
  }

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
                                                          countryImageUrl=snapshot.data[index].image;
                                                          print(countryImageUrl);
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


