import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'home.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  String? gender;
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;
  bool agreed = false;
  bool loading = false;
  String? error;

  Future<void> _register() async {
    setState(() {
      loading = true;
      error = null;
    });
    if (passwordController.text != confirmPasswordController.text) {
      setState(() {
        error = "Passwords do not match";
        loading = false;
      });
      return;
    }
    try {
      final authResponse = await Supabase.instance.client.auth.signUp(
        email: emailController.text.trim(),
        password: passwordController.text,
      );
      final user = authResponse.user;
      if (user != null) {
        await Supabase.instance.client.from('profiles').insert({
          'id': user.id,
          'full_name': fullNameController.text.trim(),
          'username': usernameController.text.trim(),
          'phone': phoneController.text.trim(),
          'gender': gender,
          'agreed': agreed,
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Registration successful! Logging you in...')),
          );
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const HomePage()),
            (route) => false,
          );
        }
      } else {
        setState(() {
          error = "Registration failed. Please try again.";
        });
      }
    } on AuthException catch (e) {
      setState(() {
        error = e.message;
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
                "Create your\nAccount",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Register a new Account",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 30),
              if (error != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(error!, style: const TextStyle(color: Colors.red)),
                ),
              TextField(
                controller: fullNameController,
                decoration: InputDecoration(
                  hintText: 'Full Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  hintText: 'Username',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: 'Email Address',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: phoneController,
                decoration: InputDecoration(
                  hintText: 'Phone Number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: gender,
                decoration: InputDecoration(
                  hintText: 'Gender',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                items: ['Male', 'Female', 'Other']
                    .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    gender = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passwordController,
                obscureText: obscurePassword,
                decoration: InputDecoration(
                  hintText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscurePassword ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        obscurePassword = !obscurePassword;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: confirmPasswordController,
                obscureText: obscureConfirmPassword,
                decoration: InputDecoration(
                  hintText: 'Confirm Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        obscureConfirmPassword = !obscureConfirmPassword;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Checkbox(
                    value: agreed,
                    onChanged: (value) {
                      setState(() {
                        agreed = value ?? false;
                      });
                    },
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          agreed = !agreed;
                        });
                      },
                      child: const Text(
                        "I agree to the Terms & Privacy Policy",
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
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
                  onPressed: (agreed && !loading) ? _register : null,
                  child: loading
                      ? const CircularProgressIndicator()
                      : const Text(
                          'Register',
                          style: TextStyle(color: Colors.black),
                        ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: const [
                  Expanded(child: Divider(thickness: 1)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text("Or register with"),
                  ),
                  Expanded(child: Divider(thickness: 1)),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _socialLoginButton("Google", Icons.g_mobiledata),
                  _socialLoginButton("Facebook", Icons.facebook),
                ],
              ),
              const SizedBox(height: 30),
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text.rich(
                    TextSpan(
                      text: "Already have an account? ",
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

  Widget _socialLoginButton(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.black),
          const SizedBox(width: 8),
          Text(label),
        ],
      ),
    );
  }
}