import 'package:flutter/material.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculator',
      theme: ThemeData.dark(),
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String userInput = '';
  String result = '0';

  final List<String> buttons = [
    'C', 'DEL', '%', '/',
    '7', '8', '9', 'x',
    '4', '5', '6', '-',
    '1', '2', '3', '+',
    '0', '.', '=', 
  ];

  void handleButton(String text) {
    setState(() {
      if (text == 'C') {
        userInput = '';
        result = '0';
      } else if (text == 'DEL') {
        if (userInput.isNotEmpty) {
          userInput = userInput.substring(0, userInput.length - 1);
        }
      } else if (text == '=') {
        calculate();
      } else {
        userInput += text;
      }
    });
  }

  void calculate() {
    try {
      String expression = userInput;
      expression = expression.replaceAll('x', '*');
      expression = expression.replaceAll('%', '/100');
      final res = _evaluateExpression(expression);
      result = res.toString();
    } catch (e) {
      result = 'Error';
    }
  }

  double _evaluateExpression(String exp) {
    // super simple expression evaluator
    final parser = RegExp(r'([*/+\-])');
    final parts = exp.split(parser);
    final ops = parser.allMatches(exp).map((m) => m.group(0)!).toList();

    double num = double.parse(parts[0]);
    for (int i = 0; i < ops.length; i++) {
      double next = double.parse(parts[i + 1]);
      switch (ops[i]) {
        case '+':
          num += next;
          break;
        case '-':
          num -= next;
          break;
        case '*':
          num *= next;
          break;
        case '/':
          num /= next;
          break;
      }
    }
    return num;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(userInput, style: const TextStyle(fontSize: 32, color: Colors.white70)),
          ),
          Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(result, style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold)),
          ),
          const Divider(color: Colors.white24),
          Expanded(
            flex: 3,
            child: GridView.builder(
              itemCount: buttons.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              padding: const EdgeInsets.all(12),
              itemBuilder: (context, index) {
                final btn = buttons[index];
                final isOperator = ['/', 'x', '-', '+', '=', '%'].contains(btn);
                return ElevatedButton(
                  onPressed: () => handleButton(btn),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isOperator ? Colors.orange : Colors.grey[850],
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    padding: const EdgeInsets.all(18),
                  ),
                  child: Text(
                    btn,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
