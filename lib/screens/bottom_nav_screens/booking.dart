import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../data/values.dart';
class Booking extends StatefulWidget {
  @override
  _BookingState createState() => _BookingState();
}

class _BookingState extends State<Booking>  with SingleTickerProviderStateMixin{
  TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: <Widget>[
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
                    child: Text("Bookings",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 13),),
                  )

                ],
              ),
            ),

            DefaultTabController(
                length: 2, // length of tabs
                initialIndex: 0,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Container(
                        color: Colors.white,
                        child: TabBar(
                          labelStyle: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),
                          indicatorColor: Colors.black,
                          indicator: UnderlineTabIndicator(
                            borderSide: BorderSide(width: 4.0),
                          ),
                          labelColor: Colors.black,
                          unselectedLabelColor: Colors.grey,
                          tabs: [
                            Tab(text: 'Active'),
                            Tab(text: 'History'),
                          ],
                        ),
                      ),
                      Container( //height of TabBarView
                          height: MediaQuery.of(context).size.height*0.74,

                          child: TabBarView(children: <Widget>[
                            Container(
                              child: Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Image.asset("assets/images/empty.png",width: 150,height: 150,),
                                      Text('Your active bookings will appear here', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300)),
                                    ],
                                  )
                              ),
                            ),
                            Container(
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Image.asset("assets/images/empty.png",width: 150,height: 150,),
                                    Text('Your History bookings will appear here', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300)),
                                  ],
                                )
                              ),
                            ),
                          ])
                      )

                ])
            ),
          ]),
        ),
      ),
    );
  }

  /*@override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      child: ListView(
        children: [
          // give the tab bar a height [can change hheight to preferred height]
          Container(
            height: 45,
            child: TabBar(
              controller: _tabController,
              // give the indicator a decoration (color and border radius)
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  25.0,
                ),
                color: Colors.green,
              ),
              labelColor: Colors.white,
              unselectedLabelColor: Colors.black,
              tabs: [
                // first tab [you can add an icon using the icon property]
                Tab(
                  text: 'Place Bid',
                ),

                // second tab [you can add an icon using the icon property]
                Tab(
                  text: 'Buy Now',
                ),
              ],
            ),
          ),
          // tab bar view here
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // first tab bar view widget
                Center(
                  child: Text(
                    'Place Bid',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                // second tab bar view widget
                Center(
                  child: Text(
                    'Buy Now',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }*/

  /*@override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        initialIndex: 0,
        length: 2,
        child: Scaffold(
          body: Container(
            height: double.maxFinite,
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
                  child: Stack(
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 15),
                        alignment: Alignment.centerLeft,
                        child: Icon(Icons.arrow_back,color: primaryColor,),
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: Text("Bookings",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 13),),
                      )

                    ],
                  ),
                ),
                Container(
                  height: 100,
                  child: TabBar(
                    controller: _tabController,
                    tabs: [
                      Tab(text:"Booking"),
                      Tab(text: "History",),

                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      Icon(Icons.directions_car),
                      Icon(Icons.directions_transit)
                    ],
                  ),
                )
              ],
            ),
          )
        )
      )
    );
  }*/
}
