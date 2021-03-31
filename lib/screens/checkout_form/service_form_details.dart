import 'dart:io';
import '../../navigator/bottom_navigation.dart';
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
import '../../model/user.dart';
import '../../model/selected_service.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../profile/saved_address.dart';

class ServiceFormDetail extends StatefulWidget {
  int price;
  List<ServiceListModel> selectedServicesList=[];
  String offerId,catId,serviceName;
  String mainServiceId;


  ServiceFormDetail(this.mainServiceId,this.price,this.selectedServicesList,this.offerId,this.serviceName,this.catId);

  @override
  _ServiceFormDetailState createState() => _ServiceFormDetailState();
}

class _ServiceFormDetailState extends State<ServiceFormDetail> {
  int current=1;
  bool locationContainer=false;
  String location="Location";
  PageController controller = PageController();
  List<File> imageVideo=[];
  List<List<File>> images=[];
  List<List<String>> imageUrlList=[];
  List<String> imageVideoUrl=[];
  List<File> audio=[];
  User user;
  UserData userData;
  getUser()async{
    user=await FirebaseAuth.instance.currentUser;
  }
  getUserData() async {
    User getUserData=await FirebaseAuth.instance.currentUser;
    await databaseReference.child("User").child(getUserData.uid).once().then((
        DataSnapshot dataSnapshot) {
      userData = UserData.fromJson(dataSnapshot.value);
    });

  }
  final _formKey = GlobalKey<FormState>();
  final areaController=TextEditingController();
  final nameController=TextEditingController();
  final numberController=TextEditingController();
  final databaseReference = FirebaseDatabase.instance.reference();
  List<AddressModel> list=[];
  getUserAddress() async {
    User users=await FirebaseAuth.instance.currentUser;
    list.clear();
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

  IconData icon=Icons.keyboard_arrow_down;
  List<IconData> icons=[];
  List<bool> isExpanded=[];
  List<SelectedService> _selectedService=[];


  @override
  void initState() {
    super.initState();
    records = [];
    getUser();
    getUserData();
    fillSelectedTimeList();
    getUserAddress();
    for(int i=0;i<widget.selectedServicesList.length;i++){
      setState(() {
        icons.add(Icons.keyboard_arrow_down);
        isExpanded.add(false);
        images.add([]);
        imageUrlList.add([]);
        _controllers.add(new TextEditingController());
      });
    }
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

  Future pickImageFromCamera(int index) async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      //imageVideo.add(File(pickedFile.path));
      //images[index].add(File(pickedFile.path));
    });
    uploadImageToFirebase(index,context,File(pickedFile.path));
  }
  Future pickImageFromGallery(int index) async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      //imageVideo.add(File(pickedFile.path));
      //images[index].add(File(pickedFile.path));
    });
    uploadImageToFirebase(index,context,File(pickedFile.path));
  }
  final descriptionController=TextEditingController();
  List<TextEditingController> _controllers = new List();
  Future uploadImageToFirebase(int i,BuildContext context,File _imageFile) async {
    String fileName = _imageFile.path;
    StorageReference firebaseStorageRef =
    FirebaseStorage.instance.ref().child('bookingPics/${DateTime.now().millisecond}');
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    taskSnapshot.ref.getDownloadURL().then(
          (value)  {
            imageUrlList[i].add(value);
            setState(() {
              images[i].add(_imageFile);
            });
            print(value);
          },
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
                      totalSteps: 3, //total time the screen will change when next button is pressed
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
                  SingleChildScrollView(
                    physics: ScrollPhysics(),
                    child: Column(
                      children: [
                        Text("Service Packages",style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w300,fontSize: 14),),
                        SizedBox(height: 5,),
                        ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: widget.selectedServicesList.length,
                          itemBuilder: (BuildContext context, int index){
                            return Container(
                              padding: EdgeInsets.all(10),
                              color: Colors.white,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  Text(widget.selectedServicesList[index].title,style: TextStyle(color: Colors.black,fontSize: 16),),

                                  Container(

                                    color: Colors.white,
                                    padding: EdgeInsets.all(5),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Icon(Icons.edit,color: primaryColor,size: 20,),
                                        ),
                                        Expanded(
                                            flex: 8,
                                            child: Text("Please add any specifically instructions you would like your hero to know",style: TextStyle(color: Colors.black,fontSize: 12),)
                                        ),
                                        Expanded(
                                            flex: 1,
                                            child: GestureDetector(
                                              child: Icon(icons[index],size: 20,),
                                              onTap: (){
                                                setState(() {
                                                  if(isExpanded[index]){
                                                    icons[index]=Icons.keyboard_arrow_down;
                                                    isExpanded[index]=false;
                                                  }
                                                  else{
                                                    icons[index]=Icons.keyboard_arrow_up;
                                                    isExpanded[index]=true;
                                                  }
                                                });
                                              },
                                            )
                                        ),
                                      ],
                                    ),
                                  ),

                                  isExpanded[index]?
                                  Column(
                                    children: [
                                      Divider(color: Colors.grey[400],),
                                      Container(
                                        margin: EdgeInsets.all(5),
                                        child: Row(
                                          children: [
                                            Expanded(
                                                flex:9,
                                                child: Container(
                                                  margin: EdgeInsets.all(10),
                                                  child: TextField(
                                                    controller: _controllers[index],
                                                    maxLines: 3,
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
                                                                        pickImageFromGallery(index);
                                                                        Navigator.pop(context);
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
                                                                        pickImageFromCamera(index);
                                                                        Navigator.pop(context);
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
                                      images[index].length>0?Container(
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: images[index].length,
                                          itemBuilder: (BuildContext context,int imgIndex){
                                            return Container(
                                              margin: EdgeInsets.all(5),
                                              child: Image.file(images[index][imgIndex],width: 100,height: 150,fit: BoxFit.cover,),
                                            );
                                          },
                                        ),
                                        height: 100,
                                      ):Container()
                                    ],
                                  ):Container()

                                ],
                              ),
                            );
                          },
                        )
                      ],
                    ),
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
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Payment Summary",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w300),),
                      Container(
                        padding: EdgeInsets.all(10),
                        color: Colors.white,
                        child: Column(
                          children: [
                            Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("General",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w200,color: Colors.grey),),
                                      Text(widget.serviceName,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400),),
                                    ],
                                  )
                                ],
                              ),
                              padding: EdgeInsets.only(top: 10,bottom: 10),
                            ),
                            Divider(color: Colors.grey,thickness: 0.4,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Net Amount",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w200,color: Colors.black),),
                                Text("AED ${widget.price.toString()}",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700),),
                              ],
                            ),
                            Divider(color: Colors.grey,thickness: 0.4,),
                            Container(
                              child: Row(
                                children: [
                                  Image.asset("assets/images/money.png",width: 30,height: 30,),
                                  SizedBox(width: 10,),
                                  Text("Cash",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700),),
                                ],
                              ),
                              padding: EdgeInsets.only(top: 10,bottom: 10),
                            )
                          ],
                        ),
                      )
                    ],
                  )
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
                            bool isEmpty=false;
                            for(int i=0;i<_controllers.length;i++){
                              if(_controllers[i].text==""){
                                isEmpty=true;
                              }
                            }
                            if(isEmpty){
                              print("empty");
                              Toast.show("Description Box Is Empty", context, duration: Toast.LENGTH_LONG, gravity:  Toast.TOP);
                            }
                            else{
                              setState(() {
                                //buttonText="Payment";
                                current=2;
                                controller.animateToPage(1,duration:Duration(seconds: 1),curve:Curves.ease);
                              });
                            }

                          }
                          else if(current==2){
                            if(selectedTime==null || location=="Location"){

                              print("empty");
                              Toast.show("Please fill all data", context, duration: Toast.LENGTH_LONG, gravity:  Toast.TOP);
                            }
                            else{
                              setState(() {
                                buttonText="Payment";
                                current=3;
                                controller.animateToPage(2,duration:Duration(seconds: 1),curve:Curves.ease);
                              });
                            }
                          }
                          else if(current==3){
                            print(current);
                            List<String> select=[];
                            for(int i=0;i<widget.selectedServicesList.length;i++){
                              select.add(widget.selectedServicesList[i].id);
                            }
                            String dateTime=formatDate(_dateTime, [dd, '/', mm, '/', yyyy]);
                            final bookingIdReference = FirebaseDatabase.instance.reference();
                            bookingIdReference.child('booking_id').once().then((DataSnapshot bshot) {
                              print(bshot.value);
                              String bid="B${bshot.value}";
                              int nextId=bshot.value;
                              nextId++;
                              for(int i=0;i<widget.selectedServicesList.length;i++){
                                SelectedService selectedService=new SelectedService(
                                  _controllers[i].text,
                                  widget.selectedServicesList[i].title,
                                    widget.selectedServicesList[i].id,
                                    imageUrlList[i]
                                );
                                _selectedService.add(selectedService);
                              }
                              if(location!=null && widget.selectedServicesList.length>0 && selectedTime!=null){
                                final databaseReference = FirebaseDatabase.instance.reference();
                                databaseReference.child("booking").child(bid).set({
                                  'location': location,
                                  'user':user.uid,
                                  'username':userData.name,
                                  'date': dateTime,
                                  //'serivceDetails':_selectedService,
                                  'servicename':widget.serviceName,
                                  'time': selectedTime,
                                  'description': descriptionController.text,
                                  //'url': imageVideoUrl,
                                  'price': widget.price,
                                  'status': "Active",
                                  'service': select,
                                  'serviceId':widget.mainServiceId,
                                  'offerId': widget.offerId,
                                  'catId': widget.catId

                                }).then((value) {
                                  Toast.show("Submitted", context, duration: Toast.LENGTH_LONG, gravity:  Toast.TOP);
                                  for(int i=0;i<widget.selectedServicesList.length;i++){

                                    databaseReference.child("booking").child(bid).child('serviceSelected').push().set({
                                      'description': _controllers[i].text,
                                      'serviceName':widget.selectedServicesList[i].title,
                                      'serviceId':widget.selectedServicesList[i].id,
                                      'imgUrl':imageUrlList[i],
                                    }).then((value) {
                                      bookingIdReference.child('booking_id').set(nextId);
                                      Navigator.push(context, new MaterialPageRoute(
                                          builder: (context) => BottomNavBar(user.uid,true)));
                                    }).catchError((onError){
                                      FirebaseDatabase.instance.reference()
                                          .child('booking')
                                          .child(bid)
                                          .remove();
                                    });

                                  }


                                })
                                    .catchError((error, stackTrace) {
                                  print("inner: $error");
                                  // although `throw SecondError()` has the same effect.
                                  return Toast.show("Error : $error", context, duration: Toast.LENGTH_LONG, gravity:  Toast.TOP);
                                });

                              }
                              else{
                                Toast.show("Please Add All fields", context, duration: Toast.LENGTH_LONG, gravity:  Toast.TOP);
                              }
                            });

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
            ),


            Align(
              alignment: Alignment.bottomCenter,
              child: AnimatedContainer(
                height: locationContainer?200:0,
                duration: const Duration(seconds: 1),
                curve: Curves.fastOutSlowIn,
                color: Colors.white,
                child: list.length>0?
                ListView(
                  
                  children: [
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.all(5),
                      child: InkWell(
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
                                                    databaseReference.child("address").child(user.uid).push().set({
                                                      'addressLine': "${numberController.text}, ${nameController.text}, ${result.address}",
                                                      'area': areaController.text,
                                                      'flatNo': numberController.text,
                                                      'building': nameController.text,
                                                      'lat': result.latLng.latitude,
                                                      'long': result.latLng.longitude,


                                                    }).then((value) {
                                                      Toast.show("Saved", context, duration: Toast.LENGTH_LONG, gravity:  Toast.TOP);
                                                      getUserAddress();
                                                      Navigator.pop(context);
                                                      setState(() {
                                                        //locationContainer=
                                                      });

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
                                );
                              },
                            );
                          }
                        },
                        child: Text("Add Location",style: TextStyle(color: primaryColor),),
                      ),
                    ),
                    ListView.builder(
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
                    )
                  ],
                ):
                Center(
                  child: InkWell(
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
                                                databaseReference.child("address").child(user.uid).push().set({
                                                  'addressLine': "${numberController.text}, ${nameController.text}, ${result.address}",
                                                  'area': areaController.text,
                                                  'flatNo': numberController.text,
                                                  'building': nameController.text,
                                                  'lat': result.latLng.latitude,
                                                  'long': result.latLng.longitude,


                                                }).then((value) {
                                                  Toast.show("Saved", context, duration: Toast.LENGTH_LONG, gravity:  Toast.TOP);
                                                  getUserAddress();
                                                  Navigator.pop(context);
                                                  setState(() {
                                                    //locationContainer=
                                                  });

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
                            );
                          },
                        );
                      }
                    },
                    child: Text("Add Location",style: TextStyle(color: primaryColor),),
                  ),
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
