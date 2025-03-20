import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chess Clock',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown),
        useMaterial3: true,
      ),
      home: const ChessClockPage(),
    );
  }
}

class ChessClockPage extends StatefulWidget {
  const ChessClockPage({super.key});

  @override
  State<ChessClockPage> createState() => _ChessClockPageState();
}

class _ChessClockPageState extends State<ChessClockPage> {
  static const int initialTime = 300; // 5 minutes per player
  int _player1Time = initialTime;
  int _player2Time = initialTime;
  bool _isPlayer1Turn = true;
  Timer? _timer;

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_isPlayer1Turn) {
          if (_player1Time > 0) {
            _player1Time--;
          } else {
            _timer?.cancel();
          }
        } else {
          if (_player2Time > 0) {
            _player2Time--;
          } else {
            _timer?.cancel();
          }
        }
      });
    });
  }

  void _switchTurn() {
    setState(() {
      _isPlayer1Turn = !_isPlayer1Turn;
      _startTimer();
    });
  }

  void _resetClock() {
    setState(() {
      _timer?.cancel();
      _player1Time = initialTime;
      _player2Time = initialTime;
      _isPlayer1Turn = true;
    });
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int secs = seconds % 60;
    return '$minutes:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chess Clock'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: _isPlayer1Turn ? _switchTurn : null,
              child: Container(
                color: _isPlayer1Turn ? Colors.greenAccent : Colors.white,
                alignment: Alignment.center,
                child: Text(
                  _formatTime(_player1Time),
                  style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          const Divider(height: 2, color: Colors.black),
          Expanded(
            child: GestureDetector(
              onTap: !_isPlayer1Turn ? _switchTurn : null,
              child: Container(
                color: !_isPlayer1Turn ? Colors.greenAccent : Colors.white,
                alignment: Alignment.center,
                child: Text(
                  _formatTime(_player2Time),
                  style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _resetClock,
            child: const Text('Reset Clock'),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
