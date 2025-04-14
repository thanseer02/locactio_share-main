import 'package:ODMGear/common/app_colors.dart';
import 'package:ODMGear/common/app_styles.dart';
import 'package:ODMGear/features/home/view/home_screen.dart';
import 'package:ODMGear/utils/extensions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/loginScreen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade50,
              Colors.white,
            ],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.account_circle, size: 100.spMin, color: Colors.blue),
                SizedBox(height: 40.spMin),
                Text(
                  'Welcome ODMGear',
                  style: tsS30W600,
                ),
                SizedBox(
                  height: 10.spMin,
                ),
                Text(
                  'Please sign in to continue',
                  style: tsS16W500,
                ),
                SizedBox(
                  height: 40.spMin,
                ),
                StaggeredGoogleSignInButton(
                  onPressed: () {
                    // signInWithGoogle();
                    Navigator.pushNamed(context,HomeScreen.routeName );
                  },
                  staggerAmount: 8.0,
                ),
                SizedBox(height: 20.spMin),
                Text(
                  'or sign in with email',
                  style: tsS15W500.copyWith(
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
Future<UserCredential?> signInWithGoogle() async {
    try {
      // Check if Google Play Services are available
      final isAvailable = await GoogleSignIn().isSignedIn();
      if (!isAvailable) {
        throw Exception('Google Play Services not available');
      }

      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn(
        scopes: ['email', 'profile'],
      ).signIn();

      if (googleUser == null) return null;

      // Obtain the auth details
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } on PlatformException catch (e) {
      if (e.code == 'sign_in_failed') {
        debugPrint('Google Sign-In Error: ${e.message}');
        // Handle specific error cases
        if (e.message!.contains('ApiException: 10')) {
          debugPrint('Configuration error - check SHA-1 and package name');
        }
      }
      return null;
    } catch (e) {
      debugPrint('Error during Google Sign-In: $e');
      return null;
    }
  }
}

class StaggeredGoogleSignInButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final double staggerAmount;

  const StaggeredGoogleSignInButton({
    Key? key,
    this.onPressed,
    this.staggerAmount = 8.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60.spMin,
      child: Stack(
        children: [
          // Background layer (staggered effect)
          Positioned(
            top: staggerAmount,
            left: staggerAmount,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8.spMin),
                border: Border.all(color: Colors.grey.shade300),
              ),
            ),
          ),

          // Main button
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: AppColors.chatBoxColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  8.spMin,
                ),
                side: BorderSide(color: Colors.grey.shade300),
              ),
              minimumSize: Size(
                double.infinity,
                50.spMin,
              ),
            ),
            onPressed: onPressed,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  height: 24.spMin,
                  width: 24.spMin,
                  'google'.asAssetSvg(),
                ),
                SizedBox(width: 12.spMin),
                Text(
                  'Sign in with Google',
                  style: tsS16W500.copyWith(color: Colors.black),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


}
