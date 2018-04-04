part of coffee_book;

class DrawerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return new Drawer(
      child: new ListView(
        primary: false,
        children: <Widget>[
          new DrawerHeader(
            child: new Center(
              child: new Text(
                "Item Book",
                style: themeData.textTheme.title,
              ),
            ),
          ),
          new ListTile(
            title: const Text('Logout', textAlign: TextAlign.right),
            trailing: const Icon(Icons.exit_to_app),
            onTap: () async {
              await signOutWithGoogle();
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
        ],
      ),
    );
  }
}
