// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';

// class AuthService {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final GoogleSignIn _googleSignIn = GoogleSignIn();

//   // Get current user
//   User? get currentUser => _auth.currentUser;

//   // Auth state changes stream
//   Stream<User?> get authStateChanges => _auth.authStateChanges();

//   // Email validation
//   bool isValidEmail(String email) {
//     return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
//   }

//   // Password validation
//   bool isValidPassword(String password) {
//     return password.length >= 6;
//   }

//   // Sign in with email and password
//   Future<User?> signInWithEmailAndPassword(String email, String password) async {
//     try {
//       UserCredential credential = await _auth.signInWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//       return credential.user;
//     } on FirebaseAuthException catch (e) {
//       throw Exception(_getErrorMessage(e.code));
//     } catch (e) {
//       throw Exception('An unexpected error occurred. Please try again.');
//     }
//   }

//   // Register with email and password
//   Future<User?> registerWithEmailAndPassword(String email, String password) async {
//     try {
//       UserCredential credential = await _auth.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
      
//       // Send email verification
//       await credential.user?.sendEmailVerification();
      
//       return credential.user;
//     } on FirebaseAuthException catch (e) {
//       throw Exception(_getErrorMessage(e.code));
//     } catch (e) {
//       throw Exception('An unexpected error occurred. Please try again.');
//     }
//   }

//   // Sign in with Google
//   Future<User?> signInWithGoogle() async {
//     try {
//       // Trigger the authentication flow
//       final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
//       if (googleUser == null) {
//         // User canceled the sign-in
//         return null;
//       }

//       // Obtain the auth details from the request
//       final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

//       // Create a new credential
//       final credential = GoogleAuthProvider.credential(
//         accessToken: googleAuth.accessToken,
//         idToken: googleAuth.idToken,
//       );

//       // Sign in to Firebase with the Google credential
//       UserCredential userCredential = await _auth.signInWithCredential(credential);
//       return userCredential.user;
//     } on FirebaseAuthException catch (e) {
//       throw Exception(_getErrorMessage(e.code));
//     } catch (e) {
//       throw Exception('Google sign-in failed. Please try again.');
//     }
//   }

//   // Reset password
//   Future<void> resetPassword(String email) async {
//     try {
//       await _auth.sendPasswordResetEmail(email: email);
//     } on FirebaseAuthException catch (e) {
//       throw Exception(_getErrorMessage(e.code));
//     } catch (e) {
//       throw Exception('Failed to send password reset email. Please try again.');
//     }
//   }

//   // Sign out
//   Future<void> signOut() async {
//     try {
//       await _googleSignIn.signOut();
//       await _auth.signOut();
//     } catch (e) {
//       throw Exception('Sign out failed. Please try again.');
//     }
//   }

//   // Delete account
//   Future<void> deleteAccount() async {
//     try {
//       User? user = _auth.currentUser;
//       if (user != null) {
//         await user.delete();
//       }
//     } on FirebaseAuthException catch (e) {
//       throw Exception(_getErrorMessage(e.code));
//     } catch (e) {
//       throw Exception('Failed to delete account. Please try again.');
//     }
//   }

//   // Update password
//   Future<void> updatePassword(String newPassword) async {
//     try {
//       User? user = _auth.currentUser;
//       if (user != null) {
//         await user.updatePassword(newPassword);
//       }
//     } on FirebaseAuthException catch (e) {
//       throw Exception(_getErrorMessage(e.code));
//     } catch (e) {
//       throw Exception('Failed to update password. Please try again.');
//     }
//   }

//   // Update email
//   Future<void> updateEmail(String newEmail) async {
//     try {
//       User? user = _auth.currentUser;
//       if (user != null) {
//         await user.verifyBeforeUpdateEmail(newEmail);
//       }
//     } on FirebaseAuthException catch (e) {
//       throw Exception(_getErrorMessage(e.code));
//     } catch (e) {
//       throw Exception('Failed to update email. Please try again.');
//     }
//   }

//   // Send email verification
//   Future<void> sendEmailVerification() async {
//     try {
//       User? user = _auth.currentUser;
//       if (user != null && !user.emailVerified) {
//         await user.sendEmailVerification();
//       }
//     } on FirebaseAuthException catch (e) {
//       throw Exception(_getErrorMessage(e.code));
//     } catch (e) {
//       throw Exception('Failed to send verification email. Please try again.');
//     }
//   }

//   // Reload user
//   Future<void> reloadUser() async {
//     try {
//       User? user = _auth.currentUser;
//       if (user != null) {
//         await user.reload();
//       }
//     } catch (e) {
//       throw Exception('Failed to reload user data. Please try again.');
//     }
//   }

//   // Reauthenticate user
//   Future<void> reauthenticateUser(String email, String password) async {
//     try {
//       User? user = _auth.currentUser;
//       if (user != null) {
//         AuthCredential credential = EmailAuthProvider.credential(
//           email: email,
//           password: password,
//         );
//         await user.reauthenticateWithCredential(credential);
//       }
//     } on FirebaseAuthException catch (e) {
//       throw Exception(_getErrorMessage(e.code));
//     } catch (e) {
//       throw Exception('Failed to reauthenticate. Please try again.');
//     }
//   }

//   // Get user-friendly error messages
//   String _getErrorMessage(String errorCode) {
//     switch (errorCode) {
//       case 'user-not-found':
//         return 'No user found with this email address.';
//       case 'wrong-password':
//         return 'Incorrect password. Please try again.';
//       case 'email-already-in-use':
//         return 'An account already exists with this email address.';
//       case 'invalid-email':
//         return 'Please enter a valid email address.';
//       case 'weak-password':
//         return 'Password is too weak. Please choose a stronger password.';
//       case 'user-disabled':
//         return 'This account has been disabled. Please contact support.';
//       case 'too-many-requests':
//         return 'Too many failed attempts. Please try again later.';
//       case 'operation-not-allowed':
//         return 'This sign-in method is not allowed.';
//       case 'invalid-credential':
//         return 'Invalid credentials. Please check your email and password.';
//       case 'account-exists-with-different-credential':
//         return 'An account already exists with the same email but different sign-in credentials.';
//       case 'requires-recent-login':
//         return 'This operation requires recent authentication. Please sign in again.';
//       case 'credential-already-in-use':
//         return 'This credential is already associated with a different user account.';
//       case 'invalid-verification-code':
//         return 'Invalid verification code. Please try again.';
//       case 'invalid-verification-id':
//         return 'Invalid verification ID. Please try again.';
//       case 'network-request-failed':
//         return 'Network error. Please check your connection and try again.';
//       default:
//         return 'An error occurred. Please try again.';
//     }
//   }
// }