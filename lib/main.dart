import 'package:flutter/material.dart';

void main() => runApp(TemperatureConverterApp());

class TemperatureConverterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Converter',
      home: TemperatureConverterScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

enum ConversionType { fToC, cToF }

class TemperatureConverterScreen extends StatefulWidget {
  @override
  _TemperatureConverterScreenState createState() => _TemperatureConverterScreenState();
}

class _TemperatureConverterScreenState extends State<TemperatureConverterScreen> {
  ConversionType _selectedConversion = ConversionType.fToC;
  final TextEditingController _inputController = TextEditingController();
  String _convertedValue = '';
  List<String> _history = [];

  void _convert() {
    double? input = double.tryParse(_inputController.text);
    if (input == null) return;

    double result;
    String historyEntry;
    if (_selectedConversion == ConversionType.fToC) {
      result = (input - 32) * 5 / 9;
      _convertedValue = result.toStringAsFixed(2);
      historyEntry = 'F to C: $input => $_convertedValue';
    } else {
      result = input * 9 / 5 + 32;
      _convertedValue = result.toStringAsFixed(2);
      historyEntry = 'C to F: $input => $_convertedValue';
    }

    setState(() {
      _history.insert(0, historyEntry);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    Widget conversionRow = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 80,
          child: TextField(
            controller: _inputController,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
        ),
        SizedBox(width: 10),
        Text('='),
        SizedBox(width: 10),
        SizedBox(
          width: 80,
          child: Text(
            _convertedValue,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );

    Widget historyList = Expanded(
      child: ListView.builder(
        reverse: false,
        itemCount: _history.length,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
          child: Text(_history[index]),
        ),
      ),
    );

    Widget content = Padding(
      padding: const EdgeInsets.all(16.0),
      child: isPortrait
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Conversion:'),
                Row(
                  children: [
                    Radio<ConversionType>(
                      value: ConversionType.fToC,
                      groupValue: _selectedConversion,
                      onChanged: (val) => setState(() => _selectedConversion = val!),
                    ),
                    Text('Fahrenheit to Celsius'),
                    Radio<ConversionType>(
                      value: ConversionType.cToF,
                      groupValue: _selectedConversion,
                      onChanged: (val) => setState(() => _selectedConversion = val!),
                    ),
                    Text('Celsius to Fahrenheit'),
                  ],
                ),
                SizedBox(height: 16),
                conversionRow,
                SizedBox(height: 16),
                Center(
                  child: ElevatedButton(
                    onPressed: _convert,
                    child: Text('CONVERT'),
                  ),
                ),
                SizedBox(height: 16),
                Text('History:', style: TextStyle(fontWeight: FontWeight.bold)),
                historyList,
              ],
            )
          : Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Conversion:'),
                      Row(
                        children: [
                          Radio<ConversionType>(
                            value: ConversionType.fToC,
                            groupValue: _selectedConversion,
                            onChanged: (val) => setState(() => _selectedConversion = val!),
                          ),
                          Text('Fahrenheit to Celsius'),
                          Radio<ConversionType>(
                            value: ConversionType.cToF,
                            groupValue: _selectedConversion,
                            onChanged: (val) => setState(() => _selectedConversion = val!),
                          ),
                          Text('Celsius to Fahrenheit'),
                        ],
                      ),
                      SizedBox(height: 16),
                      conversionRow,
                      SizedBox(height: 16),
                      Center(
                        child: ElevatedButton(
                          onPressed: _convert,
                          child: Text('CONVERT'),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('History:', style: TextStyle(fontWeight: FontWeight.bold)),
                      historyList,
                    ],
                  ),
                ),
              ],
            ),
    );

    return Scaffold(
      appBar: AppBar(title: Text('Converter')),
      body: content,
    );
  }
}
