//import 'dart:async';
//
//import 'package:flutter/material.dart';
//
//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:google_sign_in/google_sign_in.dart';
//
//final FirebaseAuth _auth = FirebaseAuth.instance;
//final GoogleSignIn _googleSignIn = new GoogleSignIn();
//
//Future<String> _signInWithGoogle() async {
//  _googleSignIn.signOut();
//  final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
//  final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
//  final FirebaseUser user = await _auth.signInWithGoogle(
//    accessToken: googleAuth.accessToken,
//    idToken: googleAuth.idToken,
//  );
//  assert(user.email != null);
//  assert(user.displayName != null);
//  assert(!user.isAnonymous);
//  assert(await user.getIdToken() != null);
//
//  final FirebaseUser currentUser = await _auth.currentUser();
//  assert(user.uid == currentUser.uid);
//
//  print("User: $user");
//  return 'signInWithGoogle succeeded: $user';
//}
//
//void main() => runApp(new MyApp());
//
//class MyApp extends StatelessWidget {
//
//  final appTitle = 'Drawer Demo';
//
//  @override
//  Widget build(BuildContext context) {
//    return new MaterialApp(
//      title: appTitle,
//      theme: new ThemeData(
//        primarySwatch: Colors.blue,),
//      home: new GoogleSignInState(),
//    );
//  }
//}
//
//class MyHomePage extends StatefulWidget {
//  final String title;
//
//  MyHomePage({Key key, this.title}) : super(key: key);
//
//  @override
//  _MyHomePageState createState() => new _MyHomePageState();
//}
//
//class _MyHomePageState extends State<MyHomePage> {
//
//  @override
//  Widget build(BuildContext context) {
//    return new Scaffold(
//      drawer: new Drawer(
//        child: new ListView(
//          padding:  EdgeInsets.zero,
//          children: <Widget>[
//            new DrawerHeader(
//              child: new Text("drawer header"),
//              decoration: new BoxDecoration(
//                color: Colors.blue,
//              ),
//            ),
//            new ListTile(
//              leading: const Icon(Icons.person),
//              title: new Text("Coffees"),
//              onTap: () {
//                //method
//                Navigator.pop(context);
//              },
//            ),
//            new ListTile(
//              leading: const Icon(Icons.person),
//              title: new Text("Brew Profiles"),
//              onTap: () {
//                //method
//                Navigator.pop(context);
//              },
//            ),
//            new ListTile(
//              leading: const Icon(Icons.person),
//              title: new Text("Brew"),
//              onTap: () {
//                //method
//                Navigator.pop(context);
//              },
//            ),
//          ],
//        ),
//      ),
//      appBar: new AppBar(
//        title: new Text(widget.title),
//      ),
//      body: new Center(
//        child: new Column(
//          mainAxisAlignment: MainAxisAlignment.center,
//          children: <Widget>[
//            new Text(
//              'You have pushed the button this many times:',
//            ),
//          ],
//        ),
//      ),
//      floatingActionButton: new FloatingActionButton(
//        onPressed: (){_signInWithGoogle();},
//        tooltip: 'Increment',
//        child: new Icon(Icons.add),
//      ),
//    );
//  }
//}
//
//class GoogleSignInState extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return new Scaffold(
//      appBar: new AppBar(
//        title: new Text('First Screen'),
//      ),
//      body: new Center(
//        child: new RaisedButton(
//          child: new Text('Launch new screen'),
//          onPressed: () {
//            Navigator.push(
//              context,
//              new MaterialPageRoute(builder: (context) => new CoffeesState()),
//            );
//          },
//        ),
//      ),
//    );
//  }
//}
//
//class CoffeesState extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return new Scaffold(
//      appBar: new AppBar(
//        title: new Text("Second Screen"),
//      ),
//      body: new Center(
//        child: new RaisedButton(
//          onPressed: () {
//            Navigator.pop(context);
//          },
//          child: new Text('Go back!'),
//        ),
//      ),
//    );
//  }
//}
