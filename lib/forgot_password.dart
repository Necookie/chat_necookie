import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController emailController = TextEditingController();
  bool loading = false;
  String? message;

  Future<void> _sendResetLink() async {
    setState(() {
      loading = true;
      message = null;
    });
    try {
      await Supabase.instance.client.auth.resetPasswordForEmail(
        emailController.text.trim(),
      );
      setState(() {
        message = "Password reset email sent!";
      });
    } on AuthException catch (e) {
      setState(() {
        message = e.message;
      });
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Forgot Password",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Enter your email to reset your password",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 30),
              if (message != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    message!,
                    style: TextStyle(
                      color: message == "Password reset email sent!" ? Colors.green : Colors.red,
                    ),
                  ),
                ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.greenAccent.shade400,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: loading ? null : _sendResetLink,
                  child: loading
                      ? const CircularProgressIndicator()
                      : const Text(
                          'Send Reset Link',
                          style: TextStyle(color: Colors.black),
                        ),
                ),
              ),
              const SizedBox(height: 30),
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text.rich(
                    TextSpan(
                      text: "Remember your password? ",
                      children: [
                        TextSpan(
                          text: "Login",
                          style: TextStyle(color: Colors.green),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}