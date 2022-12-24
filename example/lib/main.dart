import 'dart:typed_data';

import 'package:base83/base83.dart';
import 'package:flutter/material.dart';

const String _initialBlurhash = 'LEHLh[WB2yk8pyoJadR*.7kCMdnj';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blurhash & Base83',
      theme: ThemeData(
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          alignLabelWithHint: true,
        ),
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Uint8List? _bitmap;
  bool _showOriginalImage = true;

  @override
  void initState() {
    _createBlurhash(_initialBlurhash);

    super.initState();
  }

  void _createBlurhash(String value) {
    _bitmap = Blurhash.decode(value, 400, 224);
    _showOriginalImage = value == _initialBlurhash;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final bitmap = _bitmap;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Blurhash & Base83'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: <Widget>[
          TextFormField(
            initialValue: _initialBlurhash,
            onChanged: _createBlurhash,
          ),
          const SizedBox(height: 16),
          if (bitmap != null)
            Center(
              child: ConstrainedBox(
                constraints:
                    const BoxConstraints(maxWidth: 400, maxHeight: 224),
                child: Image.memory(
                  bitmap,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          if (_showOriginalImage) const SizedBox(height: 16),
          if (_showOriginalImage)
            Center(
              child: ConstrainedBox(
                constraints:
                    const BoxConstraints(maxWidth: 400, maxHeight: 224),
                child: Image.network(
                  'https://blurha.sh/12c2aca29ea896a628be.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            )
        ],
      ),
    );
  }
}
