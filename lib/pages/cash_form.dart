import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:convert';

class CashForm extends StatefulWidget {
  const CashForm({Key? key}) : super(key: key);

  @override
  State<CashForm> createState() => _CashFormState();
}

class _CashFormState extends State<CashForm> {
  DateTime selectedDate = DateTime.now();
  final _cashBox = Hive.box('cashbook');

  TextEditingController _amountController = TextEditingController();
  TextEditingController _noteController = TextEditingController();
  TextEditingController _dateController = TextEditingController();

  String _amount = '';
  String _note = '';
  String _date = '';

  void _onButtonPressed() async{
    setState(() {
      _amount = _amountController.text;
      _note = _noteController.text;
      _date = _dateController.text;
    });
    Map<String, dynamic> data = {
      'amount': _amount,
      'note': _note,
      'date': _date,
    };

    int jsonCount = 0;
    for (var key in _cashBox.keys) {
      final value = _cashBox.get(key);
      if (value is String) {
        try {
          final json = jsonDecode(value);
          _cashBox.put(key, json); // overwrite the string value with the JSON object
        } catch (e) {
          // the value is not a valid JSON string
        }
      }
      if (value is Map<String, dynamic>) {
        jsonCount++;
      }
    }
    await _cashBox.put(jsonCount+1, jsonEncode(data));
    print(_cashBox.get(1));
    print(jsonCount);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1900),
        lastDate: DateTime.now());
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        _dateController.text =
            DateFormat.yMd().format(selectedDate);
      });
  }

  void writeData(){
    _cashBox.put(1, "Prashant");
    print(_cashBox.get(1));
  }

  void readData(){

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[600],
        title: Text('Cash In'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
             Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextField(
                controller: _amountController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter a amount',
                  suffixIcon: Icon(Icons.money_sharp),
                ),
              ),
            ),

             Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextField(
                controller: _noteController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Notes',
                  suffixIcon: Icon(Icons.add_card),
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextFormField(
                controller: _dateController,
                onTap: () => _selectDate(context),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Date',
                  hintText: 'Choose date',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please choose a date';
                  }
                  return null;
                },
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                  ),
                  onPressed: () {
                    _onButtonPressed();
                  },
                  child: Text(
                      'Save Cash In',
                  )
              ),
            ),
          ],
        ),
      ),
    );
  }
}
