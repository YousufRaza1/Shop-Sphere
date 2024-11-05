import 'package:flutter/material.dart';
import '../../buttom_navigation_screen.dart';
import 'package:get/get.dart';
import '../View/login_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService extends GetxController {
  Rx<String> userEmail = "".obs;
  Rx<String> password = "".obs;
  Rx<String?> authUserEmail = Rx<String?>(null);
  LogedInUser user = LogedInUser();

  Rx<bool> isLoading = false.obs;
  Rx<bool> isValidForPassword = false.obs;
  Rx<bool> isValidForEmail = false.obs;
  Rx<AuthResponse?> authResponse = Rx<AuthResponse?>(null);


  Future<void> resetPassword(String email, BuildContext context) async {
    // isLoading.value = true;
    // try {
    //   await _auth.sendPasswordResetEmail(email: email);
    //   isLoading.value = false;
    //   // showToast(context, 'check your email');
    // } catch (e) {
    //   isLoading.value = false;
    //   showToast('Error: ${e}');
    //   // showToast(context, '${e}');
    // }
  }

  //
  // Future<void> signInWithGoogle(BuildContext context) async {
  //   isLoading.value = true;
  //   // GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
  //
  //   // if (gUser == null) {
  //   //   return ;
  //   // }
  //   //
  //   // GoogleSignInAuthentication gAuth = await gUser!.authentication;
  //   // final cradential = GoogleAuthProvider.credential(
  //   //     accessToken: gAuth.accessToken, idToken: gAuth.idToken);
  //   //
  //   // final userCradential = await _auth.signInWithCredential(cradential);
  //   // isLoading.value = false;
  //   // if (userCradential != null) {
  //   //   Navigator.pushReplacement(
  //   //     context,
  //   //     MaterialPageRoute(
  //   //         builder: (context) =>
  //   //             BottomNavScreen()), // Replace with your target screen
  //   //   );
  //   // } else {
  //   //   isLoading.value = false;
  //   //   showToast('Something went wrong');
  //   // }
  //
  //
  //   /// TODO: update the Web client ID with your own.
  //   ///
  //   /// Web Client ID that you registered with Google Cloud.
  //   const webClientId = '1098111597409-1ln5ugq19a4us6g5g0brltgj8sc49cki.apps.googleusercontent.com';
  //
  //   /// TODO: update the iOS client ID with your own.
  //   ///
  //   /// iOS Client ID that you registered with Google Cloud.
  //   const iosClientId = '1098111597409-i6g2b6cv4e3b1miu7isq3i8bdgscfo5l.apps.googleusercontent.com';
  //
  //
  //   final GoogleSignIn googleSignIn = GoogleSignIn(
  //     clientId: iosClientId,
  //     serverClientId: webClientId,
  //   );
  //   final googleUser = await googleSignIn.signIn();
  //   final googleAuth = await googleUser!.authentication;
  //   final accessToken = googleAuth.accessToken;
  //   final idToken = googleAuth.idToken;
  //
  //   if (accessToken == null) {
  //     throw 'No Access Token found.';
  //   }
  //   if (idToken == null) {
  //     throw 'No ID Token found.';
  //   }
  //
  //   Supabase.instance.client.auth.signInWithIdToken(
  //     provider: OAuthProvider.google,
  //     idToken: idToken,
  //     accessToken: accessToken,
  //   );
  //
  // }

  Future<void> signInWithGoogle(BuildContext context) async {
    isLoading.value = true; // Show loading state
    try {
      // Initialize GoogleSignIn with client IDs
      const webClientId = '1098111597409-1ln5ugq19a4us6g5g0brltgj8sc49cki.apps.googleusercontent.com';
      const iosClientId = '1098111597409-i6g2b6cv4e3b1miu7isq3i8bdgscfo5l.apps.googleusercontent.com';

      final GoogleSignIn googleSignIn = GoogleSignIn(
        clientId: iosClientId,
        serverClientId: webClientId,
      );

      // Attempt Google sign-in
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        isLoading.value = false;
        return; // User cancelled the sign-in
      }

      // Retrieve authentication tokens
      final googleAuth = await googleUser.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;

      if (accessToken == null || idToken == null) {
        throw Exception('Missing Google authentication tokens');
      }

      // Sign in with Supabase using tokens
      final response = await Supabase.instance.client.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      authResponse.value = response;
      // authUserEmail.value = response.user?.email;

      final responseUser = await Supabase.instance.client.auth.getUser();

      user.usrEmail = response.user!.email;
      // Check if the user signed in successfully
      if (response.user != null) {
        print('response.user!.email = ${response.user!.email}');
        user.usrEmail = response.user!.email;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BottomNavScreen(), // Replace with your target screen
          ),
        );
      } else {
        throw Exception('Google sign-in failed');
      }
    } catch (e) {
      showToast('Sign-in error: ${e.toString()}'); // Show an error message
    } finally {
      isLoading.value = false; // Reset loading state
    }
  }


  // Future<void> createUserWithEmailAndPassword(
  //     String email, String pass, BuildContext context) async {
  //   isLoading.value = true;
  //   // try {
  //   //   print('started');
  //   //   final credential = await _auth.createUserWithEmailAndPassword(
  //   //     email: email,
  //   //     password: pass,
  //   //   );
  //   //   print('ended');
  //   //   print(credential);
  //   //   isLoading.value = false;
  //   //
  //   //   // Navigate to the new screen if the user is successfully created
  //   //   if (credential.user != null) {
  //   //     Get.offAll(() => LoginScreen());
  //   //     // Navigator.pushReplacement(
  //   //     //   context,
  //   //     //   MaterialPageRoute(
  //   //     //       builder: (context) =>
  //   //     //           LoginScreen()), // Replace with your target screen
  //   //     // );
  //   //   }
  //   // } on FirebaseAuthException catch (e) {
  //   //   isLoading.value = false;
  //   //   showToast('${e.message}');
  //   //   if (e.code == 'weak-password') {
  //   //     print('The password provided is too weak.');
  //   //   } else if (e.code == 'email-already-in-use') {
  //   //     print('The account already exists for that email.');
  //   //   }
  //   //
  //   // } catch (e) {
  //   //   isLoading.value = false;
  //   //   showToast('${e}');
  //   //   print('error Firebase.....${e}');
  //   // }
  //   // isLoading.value = false;
  // }

  Future<void> createUserWithEmailAndPassword(
      String email, String pass, BuildContext context) async {
    isLoading.value = true;

    try {
      final AuthResponse response = await Supabase.instance.client.auth
          .signUp(password: pass, email: email);

      isLoading.value = false;
      print('${response.user}');
      print('${response.session}');

      if (response.user != null) {
        Get.offAll(() => LoginScreen());
      } else {
        // Show an error message if sign-up failed
        showToast('sign up fail');
      }
    } catch (e) {
      isLoading.value = false;
      showToast('$e');
      print('Sign-up error: $e');
    }
  }

  Future<void> signInWithEmailAndPassword(
      String email, String password, BuildContext context) async {
    // isLoading.value = true;

    try {
      final response = await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      authResponse.value = response;


      if (response.user != null) {
        print('Success login');

        user.usrEmail = response.user!.email;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BottomNavScreen()),
        );
      } else if (response.user == null) {
        // Handle sign-in error
        print('Error: sign in error');
        showToast('Error: sign in error');
      }
    } on AuthException catch (e) {
      // Specific auth-related exceptions

      print('AuthException: ${e.message}');
      showToast('AuthException: ${e.message}');
    } catch (e) {
      // General exceptions
      print('Error: $e');
      showToast('Error: $e');
    } finally {
      // isLoading.value = false;
    }
  }

  void isValidEmail(String email) {
    userEmail.value = email;
    String pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    RegExp regex = RegExp(pattern);
    isValidForEmail.value = regex.hasMatch(email);
  }

  void isValidPassword(String password, {int minLength = 4}) {
    this.password.value = password;
    isValidForPassword.value = password.length >= minLength;
  }

  void showToast(String message) {
    Get.snackbar(
      'Error', // Title of the snackbar
      message, // Message to display
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: 3),
      backgroundColor: Colors.red.withOpacity(0.8),
      colorText: Colors.white,
    );
  }
}


class LogedInUser {
  // Private constructor to prevent external instantiation.
  LogedInUser._();

  // The single instance of the class.
  static final LogedInUser _instance = LogedInUser._();

  // Factory constructor to provide access to the singleton instance.
  factory LogedInUser() {
    return _instance;
  }
  String? usrEmail = null;


}