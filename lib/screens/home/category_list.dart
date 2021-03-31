import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../data/values.dart';
import '../service/service_details.dart';
import '../../model/category_model.dart';
import '../../model/home_service.dart';
import '../../model/offeredServiceModel.dart';
import 'package:firebase_database/firebase_database.dart';

class CategoryList extends StatefulWidget {
  String serviceId;String serviceName;


  CategoryList(this.serviceId, this.serviceName);

  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  ScrollController _scrollController;

  bool lastStatus = true;

  _scrollListener() {
    if (isShrink != lastStatus) {
      setState(() {
        lastStatus = isShrink;
      });
    }
  }

  bool get isShrink {
    return _scrollController.hasClients &&
        _scrollController.offset > (200 - kToolbarHeight);
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    super.dispose();
  }
  final databaseReference = FirebaseDatabase.instance.reference();

  Future<List<CategoryModel>> getCategories() async {
    List<CategoryModel> list=[];
    await databaseReference.child("service").child(widget.serviceId).child("categories").once().then((DataSnapshot dataSnapshot){
      if(dataSnapshot.value!=null){
        var KEYS= dataSnapshot.value.keys;
        var DATA=dataSnapshot.value;
        if(KEYS!=null){
          for(var individualKey in KEYS){
            CategoryModel categoryModel = new CategoryModel(
                individualKey,
                DATA[individualKey]['name']
            );
            print("key ${categoryModel.id}");
            list.add(categoryModel);
          }
        }
      }


    });
    return list;
  }
  Future<List<OfferedServiceModel>> getOfferedSerivces(String id) async {
    List<OfferedServiceModel> list=[];
    await databaseReference.child("service").child(widget.serviceId).child("categories").child(id).child("servicesOffered").once().then((DataSnapshot dataSnapshot){
      if(dataSnapshot.value!=null){
        var KEYS= dataSnapshot.value.keys;
        var DATA=dataSnapshot.value;

        for(var individualKey in KEYS){
          OfferedServiceModel offeredServiceModel = new OfferedServiceModel(
            individualKey,
            DATA[individualKey]['name'],
            DATA[individualKey]['rate'],
            DATA[individualKey]['description'],
            DATA[individualKey]['title'],
            DATA[individualKey]['image'],
          );
          print("key ${offeredServiceModel.id}");
          list.add(offeredServiceModel);
      }




      }
    });
    return list;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              leading: isShrink
                  ? Icon(
                      Icons.arrow_back,
                      color: primaryColor,
                    )
                  : GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
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
              expandedHeight: 200.0,
              floating: false,
              pinned: true,
              backgroundColor: Colors.white,
              flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: !isShrink
                      ? Text("",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                          ))
                      : Text(
                    widget.serviceName,
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              color: Colors.black),
                        ),
                  background: Container(
                      child: Container(
                        margin: EdgeInsets.only(top: 100, left: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.serviceName,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700)),
                            GestureDetector(
                              onTap: () {},
                              child: Text("Find Out More",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13.0,
                                    decoration: TextDecoration.underline,
                                    decorationStyle: TextDecorationStyle.solid,
                                    decorationColor: primaryColor, decorationThickness: 1,
                                  )),
                            )
                          ],
                        ),
                      ),
                      decoration: new BoxDecoration(color: backgroundColor
                          /*image: new DecorationImage(
                            fit: BoxFit.cover,
                            image: new AssetImage("assets/images/relax.png"),
                          )*/
                          ))),
            ),
          ];
        },
        body: Container(
          height: MediaQuery.of(context).size.height,
          child: ListView(
            shrinkWrap: true,
            children: [

              Container(
                height: 30,
                child:FutureBuilder<List<CategoryModel>>(
                  future: getCategories(),
                  builder: (context,snapshot){
                    if(snapshot.hasData){
                      if(snapshot.data!=null && snapshot.data.length>0){
                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data.length,
                          itemBuilder: (BuildContext context,int index){
                            return GestureDetector(
                              onTap: (){

                              },
                              child: Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.only(left: 15,right: 15),
                                margin: EdgeInsets.only(left: 5,right: 5),
                                child: Text(snapshot.data[index].name,style: TextStyle(color: Colors.grey[500],fontSize: 12),),
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(20)
                                ),
                              ),
                            );
                          },

                        );
                      }
                      else {
                        return new Center(
                          child: Container(
                            child: Text("No Data Found"),
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
              ),
              FutureBuilder<List<CategoryModel>>(
                future: getCategories(),
                builder: (context,snapshot){
                  if(snapshot.hasData){
                    if(snapshot.data!=null && snapshot.data.length>0){
                      return ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context,int index){
                          return Container(
                              child: Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(top: 20,bottom: 10,left: 10,right: 10),
                                    child: Row(
                                      children: [
                                        Text(
                                          snapshot.data[index].name,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 15,
                                              color: Colors.black),
                                        ),
                                        Expanded(
                                            child: Container(
                                              margin: EdgeInsets.only(left: 15,right: 15),
                                              child: Divider(
                                                color: Colors.grey,
                                              ),
                                            )
                                        )
                                      ],
                                    ),
                                  ),
                                  snapshot.data[index].id!=null?Container(
                                      margin: EdgeInsets.only(left: 10,right: 10),
                                      child: FutureBuilder<List<OfferedServiceModel>>(
                                        future: getOfferedSerivces(snapshot.data[index].id),
                                        builder: (context,serviceshot){
                                          if(serviceshot.hasData){
                                            if(serviceshot.data!=null && serviceshot.data.length>0){
                                              return GridView.builder(
                                                  shrinkWrap: true,
                                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount: 2,
                                                    childAspectRatio: MediaQuery.of(context).size.width*0.77 / (MediaQuery.of(context).size.height*0.4),
                                                  ),
                                                  itemCount: serviceshot.data.length,
                                                  itemBuilder: (BuildContext ctx, index) {
                                                    return GestureDetector(
                                                      onTap: (){
                                                        Navigator.push(context, new MaterialPageRoute(
                                                            builder: (context) => ServiceDetail(widget.serviceId,snapshot.data[index].id,serviceshot.data[index])));
                                                      },
                                                      child: Container(
                                                        margin: EdgeInsets.all(20),
                                                        width: 100,
                                                        padding: EdgeInsets.only(top: 10,bottom: 5,left: 10,right: 10),
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Container(
                                                                height: 40,
                                                                width: 40,
                                                                decoration: new BoxDecoration(
                                                                    shape: BoxShape.circle,
                                                                    image: new DecorationImage(
                                                                      fit: BoxFit.fill,
                                                                      image: new NetworkImage(serviceshot.data[index].image),
                                                                    )
                                                                )
                                                            ),
                                                            SizedBox(height: 10,),
                                                            Text(
                                                              serviceshot.data[index].name,
                                                              style: TextStyle(fontSize: 12,fontWeight: FontWeight.w400),
                                                              textAlign: TextAlign.start,
                                                            ),
                                                            SizedBox(height: 10,),
                                                            Text(
                                                              serviceshot.data[index].rate,
                                                              style: TextStyle(fontSize: 10,color: Colors.grey,fontWeight: FontWeight.w300),
                                                              textAlign: TextAlign.start,
                                                            ),
                                                            SizedBox(height: 10,),
                                                            Icon(Icons.arrow_forward,color: primaryColor,)
                                                          ],
                                                        ),
                                                        decoration: BoxDecoration(
                                                            color: Color(0xfff1f6fa),
                                                            borderRadius: BorderRadius.circular(15)),
                                                      ),
                                                    );
                                                  });
                                            }
                                            else {
                                              return new Center(
                                                child: Container(
                                                  child: Text("No Data Found"),
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
                                      )
                                  ):
                                  Container(),
                                ],
                              )
                          );
                        },

                      );
                    }
                    else {
                      return new Center(
                        child: Container(
                          child: Text("No Data Found"),
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

            ],
          ),
        )
      ),
    );
  }
}
