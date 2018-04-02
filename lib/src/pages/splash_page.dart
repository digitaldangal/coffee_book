part of coffee_book;

class SplashPage extends StatefulWidget {
  @override
  State createState() => new _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    // Listen for our auth event (on reload or start)
    // Go to our /coffees page once logged in
//    _auth.onAuthStateChanged.firstWhere((user) => user != null).then((user) {
//      Navigator.of(context).pushReplacementNamed('/coffees');
//    });

    // Give the navigation animations, etc, some time to finish
    new Future.delayed(new Duration(seconds: 1)).then(
            (_) => signInWithGoogle()
                .then((FirebaseUser user) => user != null)
                .then((user)
                    {
                      Navigator.of(context).pushReplacementNamed('/coffees');
                    })
                .catchError((e) => print(e)));
  }

  @override
  Widget build(BuildContext context) {
    return new LoadingIndicator();
  }
}