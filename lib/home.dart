import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy user data for the side panel
    final user = Supabase.instance.client.auth.currentUser;

    return Scaffold(
      body: Row(
        children: [
          // Side Panel
          Container(
            width: 260,
            color: Colors.grey[100],
            child: Column(
              children: [
                const SizedBox(height: 40),
                CircleAvatar(
                  radius: 36,
                  backgroundColor: Colors.greenAccent.shade400,
                  child: const Icon(Icons.person, size: 40, color: Colors.white),
                ),
                const SizedBox(height: 12),
                Text(
                  user?.email ?? "User",
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 24),
                ListTile(
                  leading: const Icon(Icons.chat_bubble_outline),
                  title: const Text("Conversations"),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.settings_outlined),
                  title: const Text("Settings"),
                  onTap: () {},
                ),
                const Spacer(),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: const Text("Logout", style: TextStyle(color: Colors.red)),
                  onTap: () async {
                    await Supabase.instance.client.auth.signOut();
                    if (context.mounted) {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => const Placeholder()), // Replace Placeholder with LoginPage
                        (route) => false,
                      );
                    }
                  },
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
          // Main Chat Area
          Expanded(
            child: Container(
              color: Colors.white,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.chat_bubble_outline, size: 80, color: Colors.greenAccent.shade400),
                    const SizedBox(height: 24),
                    const Text(
                      "Welcome to Chat!",
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Select a conversation or start a new one.",
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}