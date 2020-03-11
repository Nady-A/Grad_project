import 'package:flutter/material.dart';
import 'package:grad_project/screens/featured/featured.dart';
import '../profile/my_profile.dart';
import '../add/add.dart';
import '../home/home.dart';
import '../events/events.dart';

class MainNavigationPage extends StatefulWidget {
  @override
  _MainNavigationPageState createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: <Widget>[
          Featured(),
          Home(),
          //Add(),
          Container(),
          Events(),
          MyProfile(),
        ],

      ),

      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        onTap: (i){

          if(i == 2){
            Navigator.pushNamed(context, '/add_post');
          }else{
            setState(() {
              _currentIndex = i;
            });
          }
        },

        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            title: Text('Discover'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            title: Text('Add'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.equalizer),
            title: Text('Events'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text('Profile'),
          ),
        ],
      ),
    );
  }
}
