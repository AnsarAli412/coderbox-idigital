import 'package:flutter/material.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({Key? key}) : super(key: key);

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child:DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              'Favourite',
            ),
            leading: new IconButton(
                icon: new Icon(Icons.arrow_back),
                color: Colors.red,
                onPressed: () {
                  Navigator.of(context).pop();
                }),
            backgroundColor: Colors.white,
            bottom: TabBar(
              labelColor: Colors.red,
              // controller: tabController,
              onTap: (index) {
                // setState(() {
                //   currentTabIndex = index;
                // });
                // switch (currentTabIndex) {
                //   case 0:
                //     tabController.animateTo(1);
                //     break;
                //   case 1:
                //     tabController.animateTo(2);
                //     break;
                //   case 2:
                //     tabController.animateTo(3);
                //     break;
                //   case 3:
                //     tabController.animateTo(4);
                //     break;
                // }
              },
              tabs: [
                Container(
                  margin: EdgeInsets.only(bottom: 10.0),
                  child: Text(
                    'Team',
                    style: TextStyle(fontSize: 10),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 10.0),
                  child: Text(
                    'Matches',
                    style: TextStyle(fontSize: 10),
                  ),
                )
                // ),
                // Container(
                //   margin: EdgeInsets.only(bottom: 10.0),
                //   child: Text(
                //     'Players',
                //     style: TextStyle(fontSize: 10),
                //   ),
                // ),
                // Container(
                //   margin: EdgeInsets.only(bottom: 10.0),
                //   child: Text(
                //     'Tournament',
                //     style: TextStyle(fontSize: 10),
                //   ),
                // ),
              ],
            ),
          ),
          body: Container(
            padding: EdgeInsets.all(10),
            child: TabBarView(
              // controller: tabController,
              children: [
                Container(),
                Container()
                // FavouriteTeamFragment(),
                // FavouriteMatchFragment(),
                // FavouritePlayerFragment(
                //   ById: 0,
                //   GameId: 0,
                //   PlayerBy: 'FAVOURITE',
                //   isAdmin: false,
                // ),
                // FavouriteTournamentFragment(),
              ],
            ),
          ),
        ),
      )
    );
  }
}
