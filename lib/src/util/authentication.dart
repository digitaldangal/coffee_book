part of coffee_book;

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = new GoogleSignIn();

Future<FirebaseUser> signInWithGoogle() async {
  signOutWithGoogle();
  // Attempt to get the currently authenticated user
  GoogleSignInAccount currentUser = _googleSignIn.currentUser;
  if (currentUser == null) {
    // Attempt to sign in without user interaction
    currentUser = await _googleSignIn.signInSilently();
  }
  if (currentUser == null) {
    // Force the user to interactively sign in
    currentUser = await _googleSignIn.signIn();
  }

  print("AAAAAAAAAAAA " + currentUser.toString());
  final GoogleSignInAuthentication auth = await currentUser.authentication;

  print("BBBBBBBBBBBB " );

  // Authenticate with firebase
  final FirebaseUser user = await _auth.signInWithGoogle(
    idToken: auth.idToken,
    accessToken: auth.accessToken,
  );

  print("CCCCCCCCCCCCC " +user.toString());
  assert(user != null);
  assert(!user.isAnonymous);

  print("DDDDDDDDDDDDDDD " +user.toString());
  return user;
}

Future<Null> signOutWithGoogle() async {
  // Sign out with firebase
  await _auth.signOut();
  // Sign out with google
  await _googleSignIn.signOut();
}