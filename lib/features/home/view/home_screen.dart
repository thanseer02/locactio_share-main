import 'package:ODMGear/common/app_styles.dart';
import 'package:ODMGear/features/login_screen/home_provider.dart';
import 'package:ODMGear/features/map_screen/map_screen.dart';
import 'package:ODMGear/helpers/sp_helper.dart';
import 'package:ODMGear/utils/sp_keys.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/home';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _roomIdController = TextEditingController();
  bool _isJoining = false;
  bool _isCreating = false;

  @override
  void dispose() {
    _roomIdController.dispose();
    super.dispose();
  }

@override
  void initState() {
    super.initState();
    setImage();
  }

  Future<void> setImage() async {
    context.read<HomeProvider>().profileImge =
        await SpHelper.getString(keyUserImage) ?? '';
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF6C63FF), Color(0xFF3A2EFF)],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(24.spMin),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                
                  SizedBox(height: 16.spMin),
                  Text(
                    'MAP Connect',
                    style: ts34CBlack.copyWith(
                      color: Colors.white,
                    ),  
                  ),
                  SizedBox(height: 8.spMin),
                  Text(
                    'Connect with anyone, anywhere',
                    style: tsS16W400.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 40.spMin,
                  ),
                  _buildRoomCard(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoomCard(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          16.spMin,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(24.spMin),
        child: Column(
          children: [
            TextField(
              controller: _roomIdController,
              decoration: InputDecoration(
                labelText: 'Room Code',
                prefixIcon: Icon(Icons.meeting_room),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[50],
              ),
            ),
            SizedBox(
              height: 24.spMin,
            ),
            _buildJoinButton(context),
            SizedBox(
              height: 16.spMin,
            ),
            Text(
              'or',
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(
              height: 16.spMin,
            ),
            _buildCreateButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildJoinButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF6C63FF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: _isJoining ? null : () => _joinRoom(context),
        child: _isJoining
            ? CircularProgressIndicator(color: Colors.white)
            : Text(
                'Join Room',
                style: TextStyle(fontSize: 16),
              ),
      ),
    );
  }

  Widget _buildCreateButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Color(0xFF6C63FF)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: _isCreating ? null : () => _createRoom(context),
        child: _isCreating
            ? CircularProgressIndicator(color: Color(0xFF6C63FF))
            : Text(
                'Create New Room',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF6C63FF),
                ),
              ),
      ),
    );
  }

  Future<void> _joinRoom(BuildContext context) async {
    final roomId = _roomIdController.text.trim();
    if (roomId.isEmpty) {
      _showSnackBar(context, 'Please enter a room code');
      return;
    }

    setState(() => _isJoining = true);
    try {
      await Future.delayed(Duration(seconds: 1)); // Simulate API call
    } catch (e) {
      _showSnackBar(context, 'Error: ${e.toString()}');
      setState(() => _isJoining = false);
      return;
    }

    setState(() => _isJoining = false);
    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MapScreen(roomId: roomId),
      ),
    );
  }

  Future<void> _createRoom(BuildContext context) async {
    setState(() => _isCreating = true);
    await Future.delayed(Duration(seconds: 1)); // Simulate room creation
    final roomId = _generateRoomId();
    _roomIdController.text = roomId;
    setState(() => _isCreating = false);

    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    CollectionReference usersCollection = await _firestore.collection('rooms');
    try {
      await usersCollection.add({
        'roomId': roomId,
        'createdAt': FieldValue.serverTimestamp(),
        'useName': await SpHelper.getString(keyUserName),
        'userId': await SpHelper.getString(keyUserId),
      }).then((value) {
        _showSnackBar(context, 'Room created successfully!');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MapScreen(roomId: roomId),
          ),
        );
      });
    } catch (e) {
      _showSnackBar(context, 'Error creating room: $e');
      return;
    }

    if (!mounted) return;


  
  }

  String _generateRoomId() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final random = Random();

    String generatePart(int length) {
      return List.generate(length, (_) => chars[random.nextInt(chars.length)])
          .join();
    }

    return '${generatePart(3)}-${generatePart(3)}';
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

