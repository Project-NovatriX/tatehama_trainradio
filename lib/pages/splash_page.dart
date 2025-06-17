import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  bool _showLoading = false;
  bool _showError = false;
  String _errorMessage = '';
  bool _showLoginButton = false;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _controller.forward().whenComplete(() {
      setState(() {
        _showLoading = true;
      });
      _startInitialization();
    });
  }

  Future<void> _startInitialization() async {
    try {
      final response =
          await http.get(Uri.parse('https://www.google.com')).timeout(
        const Duration(seconds: 5),
        onTimeout: () => throw TimeoutException('タイムアウトしました'),
      );

      if (response.statusCode == 200) {
        setState(() {
          _showLoginButton = true;
          _showLoading = false;
        });
      } else {
        throw Exception('無効なステータスコード: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _showError = true;
        _showLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  Widget _buildLoginButton() {
    return ElevatedButton.icon(
      onPressed: () {
        // TODO: Discordログイン処理
      },
      icon: Image.asset(
        'assets/images/Discord.png',
        height: 24,
      ),
      label: const Text('Discordでログイン'),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF5865F2),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        elevation: 4,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // ロゴとタイトル：少し上寄せ
            Positioned(
              top: MediaQuery.of(context).size.height * 0.2,
              left: 0,
              right: 0,
              child: FadeTransition(
                opacity: _animation,
                child: Column(
                  children: [
                    Image.asset('assets/images/logo.png', width: 200),
                    const SizedBox(height: 20),
                    const Text(
                      '館浜電鉄列車無線',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ローディング、エラー、ボタン：画面中央下
            Positioned(
              bottom: MediaQuery.of(context).size.height * 0.15,
              left: 0,
              right: 0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_showLoading) ...[
                    const CircularProgressIndicator(),
                    const SizedBox(height: 12),
                    const Text('起動中...', style: TextStyle(color: Colors.white)),
                  ],
                  if (_showError) ...[
                    const Icon(Icons.error, color: Colors.redAccent, size: 48),
                    const SizedBox(height: 8),
                    const Text(
                      '起動失敗',
                      style: TextStyle(
                          color: Colors.redAccent,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Text(
                        _errorMessage,
                        style: const TextStyle(color: Colors.white70),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                  if (_showLoginButton) ...[
                    const SizedBox(height: 24),
                    _buildLoginButton(),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
