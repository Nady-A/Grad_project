import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:grad_project/screens/profile/favorites.dart';
import 'package:grad_project/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {

  @override
  Widget build(BuildContext context) {
    return new Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
//            child: Align(child: Text('Talentya'), alignment: Alignment.bottomCenter),
            child: Align(child: Image.asset('assets/Talentya.png') , alignment: Alignment.bottomCenter,),
            decoration: BoxDecoration(
//              color: Colors.blue.shade100,
              image: DecorationImage(
                image: AssetImage('assets/Logo.png'),
//                image: NetworkImage('https://firebasestorage.googleapis.com/v0/b/talentapp-dc5b9.appspot.com/o/files%2Flogopng.png?alt=media&token=aeec9206-2ed6-4790-9df9-5cff2247dfd9'),
              ),
            ),
          ),
          ListTile(
            title: Text("Favorites"),
            onTap: () async {
              FirebaseUser user = await FirebaseAuth.instance.currentUser();
              String uid = user.uid;
              Navigator.push(context, MaterialPageRoute(builder: (context) => Favorites(uid: uid)));
            },
          ),
          ListTile(
            title: Text('Log Out'),
            onTap: () async{
              await Provider.of<Authenticator>(context).signOut();
            },
          ),
        ],
      ),
    );
  }
}