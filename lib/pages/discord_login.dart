import 'package:flutter/material.dart';

class DiscordLoginScreen extends StatelessWidget {
  const DiscordLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Discord認証')),
      body: const Center(
        child: Text('ここでDiscord認証を行います'),
      ),
    );
  }
}
