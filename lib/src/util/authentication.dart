part of coffee_book;

final FirebaseAuth auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = new GoogleSignIn();

Future<Null> _ensureLoggedIn() async {
  GoogleSignInAccount user = googleSignIn.currentUser;

  if (user == null)
    user = await googleSignIn.signInSilently();
  if (user == null) {
    await googleSignIn.signIn();
  }
  if (await auth.currentUser() == null) {
    GoogleSignInAuthentication credentials = await googleSignIn.currentUser.authentication;
    await auth.signInWithGoogle(
      accessToken: credentials.accessToken,
      idToken: credentials.idToken,
    );
    print("DDDDDDDDDDDDD");
    print(user);
  }
}

Future<Null> _signOutWithGoogle() async {
  // Sign out with firebase
  await auth.signOut();
  // Sign out with google
  await googleSignIn.signOut();
}