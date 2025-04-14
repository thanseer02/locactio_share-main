import 'package:ODMGear/features/map_screen/map_screen.dart';
import 'package:flutter/material.dart';
import 'dart:math';

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
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.video_camera_front_rounded,
                    size: 80,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Video Connect',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Connect with anyone, anywhere',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 40),
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
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            TextField(
              controller: _roomIdController,
              decoration: InputDecoration(
                labelText: 'Room Code',
                prefixIcon: const Icon(Icons.meeting_room),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[50],
              ),
            ),
            const SizedBox(height: 24),
            _buildJoinButton(context),
            const SizedBox(height: 16),
            const Text(
              'or',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
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
          backgroundColor: const Color(0xFF6C63FF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: _isJoining ? null : () => _joinRoom(context),
        child: _isJoining
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text(
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
          side: const BorderSide(color: Color(0xFF6C63FF)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: _isCreating ? null : () => _createRoom(context),
        child: _isCreating
            ? const CircularProgressIndicator(color: Color(0xFF6C63FF))
            : const Text(
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
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call
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
    await Future.delayed(const Duration(seconds: 1)); // Simulate room creation
    final roomId = _generateRoomId();
    _roomIdController.text = roomId;
    setState(() => _isCreating = false);

    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MapScreen(roomId: roomId),
      ),
    );
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

