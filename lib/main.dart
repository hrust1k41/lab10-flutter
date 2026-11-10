import 'package:flutter/material.dart';

const robotUrl =
    'https://emojiisland.com/cdn/shop/products/Robot_Emoji_Icon_abe1111a-1293-4668-bdf9-9ceb05cff58e_large.png?v=1571606090';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Text previewer',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        appBarTheme: const AppBarTheme(centerTitle: true),
      ),
      home: const InputScreen(),
    );
  }
}


class InputScreen extends StatefulWidget {
  const InputScreen({super.key});

  @override
  State<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  final _controller = TextEditingController();
  double _fontSize = 35;

  Future<void> _openPreview() async {
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (context) => PreviewScreen(
          text: _controller.text,
          fontSize: _fontSize,
        ),
      ),
    );

    if (!mounted) return;

    if (result == 'ok') {
      _showMessage('Cool!');
    } else if (result == 'cancel') {
      _showMessage('Let’s try something else');
    } else {
      _showMessage("Don't know what to say");
    }
  }

  void _showMessage(String message) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          icon: Image.network(robotUrl, height: 50),
          title: Text(message, textAlign: TextAlign.center),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Text previewer'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  labelText: 'Text',
                  helperText: 'Enter some text',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Text('Font size: ${_fontSize.round()}'),
                  Expanded(
                    child: Slider(
                      value: _fontSize,
                      min: 10,
                      max: 100,
                      onChanged: (value) {
                        setState(() {
                          _fontSize = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _openPreview,
                child: const Text('Preview'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class PreviewScreen extends StatelessWidget {
  const PreviewScreen({super.key, required this.text, required this.fontSize});

  final String text;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Preview'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(text, style: TextStyle(fontSize: fontSize)),
            const SizedBox(height: 16),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                FilledButton(
                  onPressed: () => Navigator.pop(context, 'ok'),
                  child: const Text('Ok'),
                ),
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: () => Navigator.pop(context, 'cancel'),
                  child: const Text('Cancel'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}