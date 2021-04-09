import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sky_meditation/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn();
  final _db = Firestore.instance;

  User user;

  get authState => _auth.currentUser();

  AuthService() {
    _auth.currentUser().then((u) => getUser(u.uid).then((val) => user = val));
  }

  Future<dynamic> signInWithGoogle() async {
    final googleAuth = await (await _googleSignIn.signIn()).authentication;
    final authResult = await _auth.signInWithCredential(
      GoogleAuthProvider.getCredential(
          idToken: googleAuth.idToken, accessToken: googleAuth.accessToken),
    );

    if (authResult.additionalUserInfo.isNewUser)
      _createUserData(authResult.user);

    user = await getUser(authResult.user.uid);

    return user;
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  _createUserData(FirebaseUser user) async {
    await _db.collection('users').document(user.uid).setData({
      'display_name': user.displayName ?? user.email,
      'email': user.email,
      'photo_url': user.photoUrl,
    }, merge: true);
  }

  updateDisplayName(String name) async {
    _db.collection('users').document(user.uid).setData({'display_name': name},
        merge: true).then((value) async => user = await getUser(user.uid));
  }

  Future<User> getUser(String uid) async {
    final userData = await _db.collection('users').document(uid).get();
    return User.from(userData);
  }

  Stream<QuerySnapshot> getMeditationSessionsAsStream() {
    return _db
        .collection('appdata')
        .document(user.uid)
        .collection('sessions')
        .snapshots();
  }

  Future<QuerySnapshot> getMeditationSessionsAsFuture() {
    return _db
        .collection('appdata')
        .document(user.uid)
        .collection('sessions')
        .getDocuments();
  }

  Future<DocumentReference> postMeditationSession(Map sessionDetails) async {
    sessionDetails['play_time'] =
        (sessionDetails['play_time'] as Duration).toString();
    sessionDetails['away_time'] =
        (sessionDetails['away_time'] as Duration).toString();
    return await _db
        .collection('appdata')
        .document(user.uid)
        .collection('sessions')
        .add(sessionDetails);
  }

  Stream<QuerySnapshot> getMeditationNotesAsStream() {
    return _db
        .collection('appdata')
        .document(user.uid)
        .collection('notes')
        .snapshots();
  }

  Future<DocumentReference> postMeditationNote(Map note) async {
    note['written_on'] = DateTime.now();
    return await _db
        .collection('appdata')
        .document(user.uid)
        .collection('notes')
        .add(note);
  }
}

final authService = AuthService();
