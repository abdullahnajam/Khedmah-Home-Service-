import 'dart:io';

import 'package:date_format/date_format.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toast/toast.dart';
import '../../data/values.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import '../../model/service_list.dart';
import '../../model/address.dart';
class ServiceFormDetail extends StatefulWidget {
  int price;
  List<ServiceListModel> selectedServicesList=[];
  String offerId,catId;

  ServiceFormDetail(this.price,this.selectedServicesList,this.offerId,this.catId);

  @override
  _ServiceFormDetailState createState() => _ServiceFormDetailState();
}

class _ServiceFormDetailState extends State<ServiceFormDetail> {
  int current=1;
  bool locationContainer=false;
  String location="Location";
  PageController controller = PageController();
  List<File> imageVideo=[];
  List<String> imageVideoUrl=[];
  List<File> audio=[];
  User user;
  getUser()async{
    user=await FirebaseAuth.instance.currentUser;
  }
  final databaseReference = FirebaseDatabase.instance.reference();
  List<AddressModel> list=[];
  getUserAddress() async {
    User users=await FirebaseAuth.instance.currentUser;
    await databaseReference.child("address").child(users.uid).once().then((DataSnapshot dataSnapshot){
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
  Directory appDirectory;
  Stream<FileSystemEntity> fileStream;
  List<String> records;
  DateTime _dateTime=DateTime.now();
  String selectedTime=null;
  String buttonText="Proceed";
  List<bool> timeSelected=[];

  fillSelectedTimeList(){
    for(int i=0;i<10;i++){
      setState(() {
        timeSelected.add(false);
      });
    }
  }
  fillFalseSelectedTimeList(int index){
    for(int i=0;i<10;i++){
      if(i!=index){
        setState(() {
          timeSelected[i]=false;
        });
      }
    }
  }


  @override
  void initState() {
    super.initState();
    records = [];
    getUser();
    fillSelectedTimeList();
    getUserAddress();
  }

  @override
  void dispose() {
    fileStream = null;
    appDirectory = null;
    records = null;
    super.dispose();
  }

  ///NOTE: Only supported on Android & iOS
  ///Needs image_picker plugin {https://pub.dev/packages/image_picker}
  final picker = ImagePicker();

  Future pickImageFromCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      imageVideo.add(File(pickedFile.path));
    });
    uploadImageToFirebase(context,File(pickedFile.path));
  }
  Future pickImageFromGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      imageVideo.add(File(pickedFile.path));
    });
    uploadImageToFirebase(context,File(pickedFile.path));
  }
  final descriptionController=TextEditingController();
  Future uploadImageToFirebase(BuildContext context,File _imageFile) async {
    String fileName = _imageFile.path;
    StorageReference firebaseStorageRef =
    FirebaseStorage.instance.ref().child('uploads/');
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    taskSnapshot.ref.getDownloadURL().then(
          (value) => imageVideoUrl.add(value),
    ).catchError((onError)=> print(onError));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(width: 0.2, color: Colors.grey[500]),
                ),


              ),
              margin: EdgeInsets.only(top: 20),
              child: Column(
                children: [
                  Stack(
                    children: [
                      GestureDetector(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: Container(
                          margin: EdgeInsets.only(left: 15),
                          alignment: Alignment.centerLeft,
                          child: Icon(Icons.arrow_back,color: primaryColor,),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: Text("Service Details",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 13),),
                      )

                    ],
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    //Step indicator to show the progress at the top of the screen
                    child: StepProgressIndicator(
                      totalSteps: 2, //total time the screen will change when next button is pressed
                      currentStep: current,
                      size: 8,
                      padding: 4,
                      selectedSize: 3,
                      unselectedSize: 2,
                      selectedColor: primaryColor,
                      unselectedColor: Colors.grey[300],
                      roundedEdges: Radius.circular(10),


                    ),
                  ),
                ],
              )
            ),


            //Expanded shows the form
            Expanded(
              //PageView display the form that can move in one direction
              child: PageView(
                physics:new NeverScrollableScrollPhysics(), //Used to stop the swipe gesture
                controller: controller,
                children: <Widget>[
                  //Form displayed in the app
                  ListView(
                    shrinkWrap: true,
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: widget.selectedServicesList.length,
                        itemBuilder: (BuildContext context, int index){
                          return Container(
                            padding: EdgeInsets.all(10),
                            color: Colors.white,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("COVID-19 / PCR Test",style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w300,fontSize: 14),),
                                SizedBox(height: 5,),
                                Text(widget.selectedServicesList[index].title,style: TextStyle(color: Colors.black,fontSize: 16),)
                              ],
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 10,),
                      Container(
                        color: Colors.white,
                        child: Column(
                          children: [
                            Container(

                              color: Colors.white,
                              padding: EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Icon(Icons.edit,color: primaryColor,),
                                  ),
                                  Expanded(
                                      flex: 9,
                                      child: Text("Please add any specifically instructions you would like your hero to know",style: TextStyle(color: Colors.black,fontSize: 16),)
                                  ),
                                ],
                              ),
                            ),
                            Divider(color: Colors.grey[400],),
                            Container(
                              margin: EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  Expanded(
                                      flex:9,
                                    child: Container(
                                      margin: EdgeInsets.all(10),
                                      child: TextField(
                                        controller: descriptionController,
                                        maxLines: 4,
                                        maxLength: 180,
                                        decoration: InputDecoration(
                                          enabledBorder:  new OutlineInputBorder(
                                              borderSide: new BorderSide(color: Colors.grey)),
                                          focusedBorder:  new OutlineInputBorder(
                                              borderSide: new BorderSide(color: Colors.grey)),
                                          border: new OutlineInputBorder(
                                              borderSide: new BorderSide(color: Colors.grey)),
                                        ),
                                      ),
                                    )
                                  ),
                                  Expanded(
                                    flex:1,
                                    child: Column(
                                      children: [
                                        GestureDetector(
                                          onTap:(){

                                          },
                                          child: Icon(Icons.mic_none,color:primaryColor,size: 35,),
                                        ),
                                        SizedBox(height: 10,),
                                        GestureDetector(
                                          onTap:(){
                                            print("presed");
                                            showDialog<void>(
                                              context: context,
                                              barrierDismissible: true, // user must tap button!
                                              builder: (BuildContext context) {
                                                return Card(
                                                  margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.8),
                                                  child: Container(
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                          padding: EdgeInsets.all(10),
                                                          child: InkWell(
                                                            onTap: (){
                                                              pickImageFromGallery();
                                                            },
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Text("Choose Photo from Gallery",style: TextStyle(fontSize:17),),
                                                                Icon(Icons.arrow_forward),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          padding: EdgeInsets.all(10),
                                                          child: InkWell(
                                                            onTap: (){
                                                              pickImageFromCamera();
                                                            },
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Text("Choose Photo from Camera",style: TextStyle(fontSize:17),),
                                                                Icon(Icons.arrow_forward),
                                                              ],
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            );

                                          },
                                          child: Icon(Icons.camera_alt_outlined,color:primaryColor,size: 35,),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            /*Container(
                              height: 0,
                              child: Column(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: RecordListView(
                                      records: records,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: RecorderView(
                                      onSaved: _onRecordComplete,
                                    ),
                                  ),
                                ],
                              ),
                            )*/
                          ],
                        ),
                      ),
                      Container(
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: imageVideo.length,
                          itemBuilder: (BuildContext context,int index){
                            return Container(
                              margin: EdgeInsets.all(5),
                              child: Image.file(imageVideo[index],width: 100,height: 150,fit: BoxFit.cover,),
                            );
                          },
                        ),
                        height: 100,
                      ),

                    ],
                  ),
                  ListView(
                    shrinkWrap: true,
                    children: [
                      SizedBox(height: 10,),
                      Container(
                        color: Colors.white,
                        child: Column(
                          children: [
                            Container(

                              color: Colors.white,
                              padding: EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Icon(Icons.calendar_today,color: primaryColor,),
                                  ),
                                  Expanded(
                                      flex: 9,
                                      child: Text("What date would you like your service?",style: TextStyle(color: Colors.black,fontSize: 16),)
                                  ),
                                ],
                              ),
                            ),
                            Divider(color: Colors.grey[400],),
                            Container(
                              margin: EdgeInsets.all(10),
                              child: DatePicker(
                                DateTime.now(),
                                initialSelectedDate: DateTime.now(),
                                selectionColor: primaryColor,
                                selectedTextColor: Colors.white,
                                onDateChange: (date) {
                                  // New date selected
                                  setState(() {
                                    _dateTime = date;
                                    print(_dateTime);
                                  });
                                },
                              ),
                            ),
                            /*Container(
                              height: 0,
                              child: Column(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: RecordListView(
                                      records: records,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: RecorderView(
                                      onSaved: _onRecordComplete,
                                    ),
                                  ),
                                ],
                              ),
                            )*/
                          ],
                        ),
                      ),
                      SizedBox(height: 10,),
                      Container(
                        color: Colors.white,
                        child: Column(
                          children: [
                            Container(

                              color: Colors.white,
                              padding: EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Icon(Icons.access_time,color: primaryColor,),
                                  ),
                                  Expanded(
                                      flex: 9,
                                      child: Text("What time would you like your service?",style: TextStyle(color: Colors.black,fontSize: 16),)
                                  ),
                                ],
                              ),
                            ),
                            Divider(color: Colors.grey[400],),
                            Container(
                              height: 40,
                              margin: EdgeInsets.all(10),
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: [
                                  InkWell(
                                    onTap: (){
                                        selectedTime="09:00 AM";
                                        timeSelected[0]=true;
                                        fillFalseSelectedTimeList(0);

                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(left:5,right: 5),
                                      padding: EdgeInsets.only(left:10,right: 10),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: timeSelected[0]?primaryColor:Colors.white,
                                        border: Border.all(color: Colors.grey),
                                        borderRadius: BorderRadius.circular(5)
                                      ),
                                      child: Text("09:00 AM",style: TextStyle(color:timeSelected[0]?Colors.white:Colors.black,fontSize: 18),textAlign: TextAlign.center,),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: (){
                                      selectedTime="10:00 AM";
                                      fillFalseSelectedTimeList(1);
                                      timeSelected[1]=true;


                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(left:5,right: 5),
                                      padding: EdgeInsets.only(left:10,right: 10),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: timeSelected[1]?primaryColor:Colors.white,
                                          border: Border.all(color: Colors.grey),
                                          borderRadius: BorderRadius.circular(5)
                                      ),
                                      child: Text("10:00 AM",style: TextStyle(color:timeSelected[1]?Colors.white:Colors.black,fontSize: 18),textAlign: TextAlign.center,),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: (){
                                      selectedTime="11:00 AM";
                                      timeSelected[2]=true;
                                      fillFalseSelectedTimeList(2);

                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(left:5,right: 5),
                                      padding: EdgeInsets.only(left:10,right: 10),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: timeSelected[2]?primaryColor:Colors.white,
                                          border: Border.all(color: Colors.grey),
                                          borderRadius: BorderRadius.circular(5)
                                      ),
                                      child: Text("11:00 AM",style: TextStyle(color:timeSelected[2]?Colors.white:Colors.black,fontSize: 18),textAlign: TextAlign.center,),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: (){
                                      selectedTime="12:00 PM";
                                      timeSelected[3]=true;
                                      fillFalseSelectedTimeList(3);

                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(left:5,right: 5),
                                      padding: EdgeInsets.only(left:10,right: 10),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: timeSelected[3]?primaryColor:Colors.white,
                                          border: Border.all(color: Colors.grey),
                                          borderRadius: BorderRadius.circular(5)
                                      ),
                                      child: Text("12:00 PM",style: TextStyle(color:timeSelected[3]?Colors.white:Colors.black,fontSize: 18),textAlign: TextAlign.center,),
                                    ),
                                  ),

                                  InkWell(
                                    onTap: (){
                                      selectedTime="01:00 PM";
                                      timeSelected[4]=true;
                                      fillFalseSelectedTimeList(4);

                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(left:5,right: 5),
                                      padding: EdgeInsets.only(left:10,right: 10),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: timeSelected[4]?primaryColor:Colors.white,
                                          border: Border.all(color: Colors.grey),
                                          borderRadius: BorderRadius.circular(5)
                                      ),
                                      child: Text("01:00 PM",style: TextStyle(color:timeSelected[4]?Colors.white:Colors.black,fontSize: 18),textAlign: TextAlign.center,),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: (){
                                      selectedTime="02:00 PM";
                                      timeSelected[5]=true;
                                      fillFalseSelectedTimeList(5);

                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(left:5,right: 5),
                                      padding: EdgeInsets.only(left:10,right: 10),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: timeSelected[5]?primaryColor:Colors.white,
                                          border: Border.all(color: Colors.grey),
                                          borderRadius: BorderRadius.circular(5)
                                      ),
                                      child: Text("02:00 PM",style: TextStyle(color:timeSelected[5]?Colors.white:Colors.black,fontSize: 18),textAlign: TextAlign.center,),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: (){
                                      selectedTime="03:00 PM";
                                      timeSelected[6]=true;
                                      fillFalseSelectedTimeList(6);

                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(left:5,right: 5),
                                      padding: EdgeInsets.only(left:10,right: 10),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: timeSelected[6]?primaryColor:Colors.white,
                                          border: Border.all(color: Colors.grey),
                                          borderRadius: BorderRadius.circular(5)
                                      ),
                                      child: Text("03:00 PM",style: TextStyle(color:timeSelected[6]?Colors.white:Colors.black,fontSize: 18),textAlign: TextAlign.center,),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: (){
                                      selectedTime="04:00 PM";
                                      timeSelected[7]=true;
                                      fillFalseSelectedTimeList(7);

                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(left:5,right: 5),
                                      padding: EdgeInsets.only(left:10,right: 10),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: timeSelected[7]?primaryColor:Colors.white,
                                          border: Border.all(color: Colors.grey),
                                          borderRadius: BorderRadius.circular(5)
                                      ),
                                      child: Text("04:00 PM",style: TextStyle(color:timeSelected[7]?Colors.white:Colors.black,fontSize: 18),textAlign: TextAlign.center,),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: (){
                                      selectedTime="05:00 PM";
                                      timeSelected[8]=true;
                                      fillFalseSelectedTimeList(8);

                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(left:5,right: 5),
                                      padding: EdgeInsets.only(left:10,right: 10),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: timeSelected[8]?primaryColor:Colors.white,
                                          border: Border.all(color: Colors.grey),
                                          borderRadius: BorderRadius.circular(5)
                                      ),
                                      child: Text("05:00 PM",style: TextStyle(color:timeSelected[8]?Colors.white:Colors.black,fontSize: 18),textAlign: TextAlign.center,),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: (){
                                      selectedTime="06:00 PM";
                                      timeSelected[9]=true;
                                      fillFalseSelectedTimeList(9);

                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(left:5,right: 5),
                                      padding: EdgeInsets.only(left:10,right: 10),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: timeSelected[9]?primaryColor:Colors.white,
                                          border: Border.all(color: Colors.grey),
                                          borderRadius: BorderRadius.circular(5)
                                      ),
                                      child: Text("06:00 PM",style: TextStyle(color:timeSelected[9]?Colors.white:Colors.black,fontSize: 18),textAlign: TextAlign.center,),
                                    ),
                                  ),

                                ],
                              ),
                            ),
                            /*Container(
                              height: 0,
                              child: Column(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: RecordListView(
                                      records: records,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: RecorderView(
                                      onSaved: _onRecordComplete,
                                    ),
                                  ),
                                ],
                              ),
                            )*/
                          ],
                        ),
                      ),
                      SizedBox(height: 10,),
                      Container(
                        color: Colors.white,
                        child: Column(
                          children: [
                            Container(

                              color: Colors.white,
                              padding: EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Icon(Icons.place,color: primaryColor,),
                                  ),
                                  Expanded(
                                      flex: 9,
                                      child: Text("Where would you like your service?",style: TextStyle(color: Colors.black,fontSize: 16),)
                                  ),
                                ],
                              ),
                            ),
                            Divider(color: Colors.grey[400],),
                            Container(
                              height: 40,
                              margin: EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 8,
                                    child: Text(location,style: TextStyle(fontSize: 16),),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: GestureDetector(
                                      child: Text("Select",style: TextStyle(color: primaryColor,fontSize: 16),),
                                      onTap: (){
                                        setState(() {
                                          locationContainer=true;
                                        });
                                      },
                                    )
                                  ),
                                ],
                              ),
                            ),
                            /*Container(
                              height: 0,
                              child: Column(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: RecordListView(
                                      records: records,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: RecorderView(
                                      onSaved: _onRecordComplete,
                                    ),
                                  ),
                                ],
                              ),
                            )*/
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 100,
                color: Colors.white,
                child: Row(
                  children: [
                    Expanded(
                        flex: 1,
                        child: Container(
                          margin: EdgeInsets.all(10),
                          padding: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("AED ${widget.price}",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w700,fontSize: 18),),
                              Text("Excluding VAT",style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w300,fontSize: 13),),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text("View Items",style: TextStyle(color: Colors.black,fontSize: 13),),
                                  Icon(Icons.keyboard_arrow_down,color: primaryColor,size: 20,),
                                ],
                              )
                            ],
                          ),
                        )
                    ),
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: () {
                          if(current==1){
                            if(descriptionController.text==""){
                              print("empty");
                              Toast.show("Description Box Is Empty", context, duration: Toast.LENGTH_LONG, gravity:  Toast.TOP);
                            }
                            else{
                              setState(() {
                                buttonText="Payment";
                                current=2;
                                controller.animateToPage(current,duration:Duration(seconds: 1),curve:Curves.ease);
                              });
                            }

                          }
                          else if(current==2){
                            List<String> select=[];
                            for(int i=0;i<widget.selectedServicesList.length;i++){
                              select.add(widget.selectedServicesList[i].id);
                            }
                            String dateTime=formatDate(_dateTime, [dd, '/', mm, '/', yyyy]);
                            if(descriptionController.text!="" && widget.selectedServicesList.length>0 && selectedTime!=null){
                              final databaseReference = FirebaseDatabase.instance.reference();
                              databaseReference.child("booking").child(user.uid).push().set({
                                'location': location,
                                'date': dateTime,
                                'time': selectedTime,
                                'description': descriptionController.text,
                                'url': imageVideoUrl,
                                'price': widget.price,
                                'status': "Active",
                                'service': select,
                                'offerId': widget.offerId,
                                'catId': widget.catId

                              }).then((value) => Toast.show("Submitted", context, duration: Toast.LENGTH_LONG, gravity:  Toast.TOP))
                              .catchError((error, stackTrace) {
                                print("inner: $error");
                                // although `throw SecondError()` has the same effect.
                                return Toast.show("Error : $error", context, duration: Toast.LENGTH_LONG, gravity:  Toast.TOP);
                              });

                            }
                            else{
                              Toast.show("Please Add All fields", context, duration: Toast.LENGTH_LONG, gravity:  Toast.TOP);
                            }
                          }
                          /*if(current<=2){
                            setState(() {
                              print(current);
                              current++;
                              if(current==2){
                                buttonText="Finish";


                              }
                              else{
                                buttonText="Proceed";
                              }
                            });

                            //this moves the next form into the screen with animation

                          }*/

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
                                Text(buttonText,style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 16),),
                                Icon(Icons.arrow_forward,color: Colors.white,size: 20,),
                              ],
                            )

                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),


            Align(
              alignment: Alignment.bottomCenter,
              child: AnimatedContainer(
                height: locationContainer?200:0,
                duration: const Duration(seconds: 1),
                curve: Curves.fastOutSlowIn,
                color: Colors.white,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: list.length,
                  itemBuilder: (BuildContext context,int index){
                    return GestureDetector(
                      child: Container(
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
                      ),
                      onTap: (){
                        setState(() {
                          locationContainer=false;
                          location=list[index].addressLine;
                        });
                      },
                    );
                  },
                ),
              ),
            )


          ],
        ),
      ),
    );
  }
  _onRecordComplete() {
    records.clear();
    appDirectory.list().listen((onData) {
      records.add(onData.path);
    }).onDone(() {
      records.sort();
      records = records.reversed.toList();
      setState(() {});
    });
  }
}
