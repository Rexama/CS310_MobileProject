import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:week6_starter/models/Users.dart';

import 'db.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  DBService db = DBService();

  User? _userFromFirebase(User? user) {
    //
    return user ?? null;
  }

  Stream<User?> get user {
    //
    return _auth.authStateChanges().map(_userFromFirebase);
  }

  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User user = result.user!;
      db.addUserAutoID("anonymous", "anonymous", user.uid);

      print(user.toString());
      print("LOGIN USER:" + user.toString());
      return _userFromFirebase(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signupWithMailAndPass(String username, String mail, String pass) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: mail, password: pass);
      User user = result.user!;
      db.addUserAutoID(username, mail, user.uid);
      print(user.toString());
      return _userFromFirebase(user);
    } on FirebaseAuthException catch (e) {
      print("*******signup catch:********" + e.toString());
      if (e.code == 'email-already-in-use') {
        return ("1");
        //setmessage("This email is already in use");
      } else if (e.code == 'weak-password') {
        return ("2");
        //setmessage("Weak password");  //burayi biraktim
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future loginWithMailAndPass(String mail, String pass) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: mail, password: pass);
      User user = result.user!;
      late Users userClass;
      await db.firestoreInstance
          .collection("users")
          .where('userToken', isEqualTo: user.uid)
          .get()
          .then((querySnapshot) {
        userClass = Users.fromJson(querySnapshot.docs.first.data());
        print("I received that user from database: " + userClass.userName);
      });
      print(userClass.toString());
      if (!userClass.isActive) {
        db.deactivateUser(userClass.userId, true);
      }
      print("LOGIN USER:" + user.toString());
      return _userFromFirebase(user);
    } on FirebaseAuthException catch (e) {
      print(e.code.toString());
      if (e.code.toString() == 'user-not-found' || e.code.toString() == 'wrong-password') {
        //signupWithMailAndPass(mail, pass);
        return ("3");
      } else if (e.code.toString() == 'too-many-requests') {
        return ("4");
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future updatePass(String newPass, String mail, String oldPass) async
  {
    print("mail is: "+mail + "\noldpass is: " + oldPass + "\nnewpass is: " + newPass);
// Create a credential
    AuthCredential credential = EmailAuthProvider.credential(email: mail, password: oldPass);

// Reauthenticate



    try{
      var credRes = await FirebaseAuth.instance.currentUser!.reauthenticateWithCredential(credential);

      await _auth.currentUser!.updatePassword(newPass);
      print("UPDATE PASS RES: "+ "1 SUCCESS");
      return ("1");
    }
    on FirebaseAuthException catch (e){
      print(e.code.toString());
      if(e.code.toString() == 'user-not-found' || e.code.toString() == 'wrong-password')
        {
          return ("3");
        }
      else if (e.code.toString() == 'weak-password' || e.code.toString() == 'requires-recent-login') {
        //signupWithMailAndPass(mail, pass);
        return ("3");
      } else if (e.code.toString() == 'too-many-requests') {
        return ("4");
      }
      else {
        return("3");
      }
    } catch (e) {
      print(e.toString());
      return ("4");
    }
  }

  Future signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    print(credential.toString());
    UserCredential result = await FirebaseAuth.instance.signInWithCredential(credential);
    bool isUserNew = result.additionalUserInfo!.isNewUser;

    User? user = result.user;
    print(user.toString());

    if(user!.displayName != null && isUserNew)
    {
      db.addUserAutoID(user.displayName!, user.email!, user.uid);
    }


    return _userFromFirebase(user);
  }

  Future signOut() async {
    try {
      print("Tried to logout");
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }


  Future deleteUser() async {
    User user = await FirebaseAuth.instance.currentUser!;
    user.delete();
  }
}
