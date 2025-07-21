import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EmailOtpPage extends StatefulWidget {
  @override
  _EmailOtpPageState createState() => _EmailOtpPageState();
}

class _EmailOtpPageState extends State<EmailOtpPage> {
  final emailController = TextEditingController();
  final otpController = TextEditingController();
  String? generatedOtp;

  Future<void> sendOtp() async {
    final email = emailController.text.trim();
    generatedOtp = (100000 + Random().nextInt(899999)).toString();

    await FirebaseFirestore.instance.collection('emailOtps').doc(email).set({
      'otp': generatedOtp,
      'timestamp': Timestamp.now(),
    });

    // After this, Zapier will send the email (set up in Part 3)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('OTP sent to $email')),
    );
  }

  Future<void> verifyOtp() async {
    final email = emailController.text.trim();
    final enteredOtp = otpController.text.trim();

    final doc = await FirebaseFirestore.instance.collection('emailOtps').doc(email).get();

    if (!doc.exists) {
      _showMessage("OTP not found");
      return;
    }

    final data = doc.data()!;
    final timestamp = (data['timestamp'] as Timestamp).toDate();
    final storedOtp = data['otp'];

    final isExpired = DateTime.now().difference(timestamp).inMinutes > 5;

    if (isExpired) {
      _showMessage("OTP expired");
    } else if (enteredOtp == storedOtp) {
      _showMessage("OTP verified successfully ✅");
    } else {
      _showMessage("Incorrect OTP ❌");
    }
  }

  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Email OTP Verification")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          TextField(controller: emailController, decoration: InputDecoration(labelText: "Email")),
          ElevatedButton(onPressed: sendOtp, child: Text("Send OTP")),
          TextField(controller: otpController, decoration: InputDecoration(labelText: "Enter OTP")),
          ElevatedButton(onPressed: verifyOtp, child: Text("Verify OTP")),
        ]),
      ),
    );
  }
}
