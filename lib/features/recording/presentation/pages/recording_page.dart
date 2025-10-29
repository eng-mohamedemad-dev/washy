import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wash_flutter/core/constants/app_colors.dart';

class RecordingPage extends StatefulWidget {
  const RecordingPage({super.key});

  @override
  State<RecordingPage> createState() => _RecordingPageState();
}

class _RecordingPageState extends State<RecordingPage> {
  bool _micGranted = false;
  bool _isRecording = false;

  @override
  void initState() {
    super.initState();
    _ensurePermission();
  }

  Future<void> _ensurePermission() async {
    final status = await Permission.microphone.request();
    setState(() {
      _micGranted = status.isGranted;
    });
  }

  void _toggleRecording() {
    if (!_micGranted) {
      _ensurePermission();
      return;
    }
    setState(() {
      _isRecording = !_isRecording;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.greyDark),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'تسجيل صوتي',
          style: TextStyle(color: AppColors.greyDark, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _isRecording ? Icons.mic : Icons.mic_none,
              size: 96,
              color: _isRecording ? Colors.red : AppColors.grey2,
            ),
            const SizedBox(height: 16),
            Text(
              _micGranted
                  ? (_isRecording ? 'جاري التسجيل...' : 'اضغط لبدء التسجيل')
                  : 'يحتاج إذن الميكروفون',
              style: const TextStyle(color: AppColors.greyDark),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _toggleRecording,
              icon: Icon(_isRecording ? Icons.stop : Icons.fiber_manual_record, color: Colors.white),
              label: Text(_isRecording ? 'إيقاف' : 'بدء التسجيل', style: const TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: _isRecording ? Colors.red : AppColors.washyBlue,
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}




