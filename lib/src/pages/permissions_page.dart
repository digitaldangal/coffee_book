part of coffee_book;

enum PermissionState {
  GRANTED,
  DENIED,
  SHOW_RATIONALE //  Refer https://developer.android.com/training/permissions/requesting.html#explain
}

class PermissionsPage extends StatefulWidget {
  @override
  State createState() => new _PermissionsPageState();
}

class _PermissionsPageState extends State<PermissionsPage> {
  static const _methodChannel = const MethodChannel('runtimepermission');
  BuildContext _scaffoldContext;

  @override
  void initState() {
    super.initState();
    viewDisplayed();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Runtime Permission example"),
      ),
      body: new Builder(
        builder: (BuildContext context) {
          _scaffoldContext = context;
          return _buildBody();
        },
      ),
    );
  }

  Widget _buildBody() {
    return new Center(
      child: new CircularProgressIndicator(),
    );
  }

  Future viewDisplayed() async {
    PermissionState permissionState = await checkPermissions();
    switch (permissionState) {
      case PermissionState.GRANTED:
        // Give the navigation animations, etc, some time to finish
        new Future.delayed(new Duration(seconds: 1)).then((_) => Navigator.push(
            context,
            new MaterialPageRoute(builder: (context) => new SplashPage())));
        break;
      case PermissionState.DENIED:
        await new Future.delayed(new Duration(seconds: 1));
        showErrorMessage();
        break;
      case PermissionState.SHOW_RATIONALE:
        showPermissionRationale();
        break;
    }
    return null;
  }

  Future<PermissionState> checkPermissions() async {
    try {
      final int result = await _methodChannel.invokeMethod('hasPermission');
      return new Future.value(PermissionState.values.elementAt(result));
    } on PlatformException catch (e) {
      print('Exception ' + e.toString());
    }
    return new Future.value(PermissionState.DENIED);
  }

  void showErrorMessage() {
    Scaffold.of(_scaffoldContext).showSnackBar(new SnackBar(
          content: new Text('No permission'),
          duration: new Duration(seconds: 5),
        ));
  }

  Future showPermissionRationale() {
    return showDialog<Null>(
      context: context,
      barrierDismissible: false, // user must tap button!
      child: new AlertDialog(
        title: new Text('Coffees Permission'),
        content: new SingleChildScrollView(
          child: new ListBody(
            children: <Widget>[
              new Text('We need this permission because ...'),
            ],
          ),
        ),
        actions: <Widget>[
          new FlatButton(
            child: new Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
              viewDisplayed();
            },
          ),
        ],
      ),
    );
  }
}
