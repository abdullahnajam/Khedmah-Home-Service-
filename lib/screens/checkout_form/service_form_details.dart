import 'dart:io';

import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:toast/toast.dart';
import '../../data/values.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
class ServiceFormDetail extends StatefulWidget {
  int price;

  ServiceFormDetail(this.price);

  @override
  _ServiceFormDetailState createState() => _ServiceFormDetailState();
}

class _ServiceFormDetailState extends State<ServiceFormDetail> {
  int current=1;

  PageController controller = PageController();
  List<File> imageVideo=[];
  List<String> imageVideoUrl=[];
  List<File> audio=[];
  User user;
  getUser()async{
    user=await FirebaseAuth.instance.currentUser;
  }

  Directory appDirectory;
  Stream<FileSystemEntity> fileStream;
  List<String> records;
  DateTime _dateTime;
  String selectedTime;
  String buttonText="Proceed";

  @override
  void initState() {
    super.initState();
    records = [];
    getUser();
    getApplicationDocumentsDirectory().then((value) {
      appDirectory = value;
      appDirectory.list().listen((onData) {
        records.add(onData.path);
      }).onDone(() {
        records = records.reversed.toList();
        setState(() {});
      });
    });
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
                        itemCount: 1,
                        itemBuilder: (BuildContext context, int index){
                          return Container(
                            padding: EdgeInsets.all(10),
                            color: Colors.white,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("title/category",style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w300,fontSize: 14),),
                                SizedBox(height: 5,),
                                Text("Home Service title",style: TextStyle(color: Colors.black,fontSize: 16),)
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
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(left:5,right: 5),
                                      padding: EdgeInsets.only(left:10,right: 10),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey),
                                        borderRadius: BorderRadius.circular(5)
                                      ),
                                      child: Text("09:00 AM",style: TextStyle(fontSize: 18),textAlign: TextAlign.center,),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: (){
                                      selectedTime="10:00 AM";
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(left:5,right: 5),
                                      padding: EdgeInsets.only(left:10,right: 10),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          border: Border.all(color: Colors.grey),
                                          borderRadius: BorderRadius.circular(5)
                                      ),
                                      child: Text("10:00 AM",style: TextStyle(fontSize: 18),textAlign: TextAlign.center,),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: (){
                                      selectedTime="11:00 AM";
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(left:5,right: 5),
                                      padding: EdgeInsets.only(left:10,right: 10),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          border: Border.all(color: Colors.grey),
                                          borderRadius: BorderRadius.circular(5)
                                      ),
                                      child: Text("11:00 AM",style: TextStyle(fontSize: 18),textAlign: TextAlign.center,),
                                    ),
                                  )
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
                                    child: Text("my location",style: TextStyle(fontSize: 16),),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text("Change",style: TextStyle(color: primaryColor,fontSize: 16),),
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
                          if(current<=2){
                            setState(() {
                              print(current);
                              current++;
                              if(current==2){
                                buttonText="Finish";

                                final databaseReference = FirebaseDatabase.instance.reference();
                                databaseReference.child("booking").child(user.uid).set({
                                  'location': "location",
                                  'date': _dateTime,
                                  'time': selectedTime,
                                  'description': descriptionController.text,
                                  'url': imageVideoUrl,
                                  'price': widget.price,

                                });
                                Toast.show("Submitted", context, duration: Toast.LENGTH_LONG, gravity:  Toast.TOP);
                              }
                              else{
                                buttonText="Proceed";
                              }
                            });

                            //this moves the next form into the screen with animation
                            controller.animateToPage(current,duration:Duration(seconds: 1),curve:Curves.ease);
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
