library coffee_book;

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';

part 'pages/splash_page.dart';
part 'pages/coffee_list.dart';
part 'models/coffee.dart';
part 'services/storage.dart';
part 'util/authentication.dart';
part 'widgets/loading_indicator.dart';
part 'widgets/coffee_header.dart';
part 'widgets/coffee_widget.dart';

class CoffeeBookApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Coffee Book',
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        fontFamily: 'Helvetica Neue',
        primarySwatch: Colors.blueGrey,
      ),
      home: new SplashPage(),
      routes: <String, WidgetBuilder>{
        '/coffees': (BuildContext context) => new CoffeeBookApp(),
      },
    );
  }
}