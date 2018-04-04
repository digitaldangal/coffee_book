library coffee_book;

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';
import 'package:flutter/services.dart';

part 'pages/splash_page.dart';

part 'pages/list.dart';

part 'pages/item_form_page.dart';

part 'pages/permissions_page.dart';

part 'models/coffee.dart';

part 'models/item.dart';

part 'services/storage.dart';

part 'util/authentication.dart';

part 'widgets/loading_indicator.dart';

part 'widgets/item_header.dart';

part 'widgets/drawer_widget.dart';

part 'widgets/item_widget.dart';
part 'widgets/coffee_form_widget.dart';

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
        home: new PermissionsPage());
  }
}
