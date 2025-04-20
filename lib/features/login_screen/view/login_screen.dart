import 'package:ODMGear/common/app_styles.dart';
import 'package:ODMGear/features/home/view/home_screen.dart';
import 'package:ODMGear/features/login_screen/view_model/login_provider.dart';
import 'package:ODMGear/features/login_screen/widgets/google_button_widget.dart';
import 'package:ODMGear/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/loginScreen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
                    _handleSignIn();
                  },
                  staggerAmount: 8.0,
                ),
                SizedBox(height: 20.spMin),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleSignIn() async {
    try {
      _googleSignIn.signIn().then((value) async {
        if (value != null) {
          context.read<LoginViewModel>().addToFirebase(
                user: value,
                onSuccess: () {
                  Navigator.pushNamed(
                    context,
                    HomeScreen.routeName,
                  );
                },
              );
        }
      });
    } catch (error) {
      log('Error signing in: $error');
      // Handle the error here (e.g., show a message to the user)
    } 
  }
}
