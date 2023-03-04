import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:cashbook/models/cash_model.dart';
import 'package:intl/intl.dart';
import 'package:hive/hive.dart';
import 'package:cashbook/boxes/cashes.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:convert';

class CashOut extends StatefulWidget {
  const CashOut({Key? key}) : super(key: key);

  @override
  State<CashOut> createState() => _CashOutState();
}

class _CashOutState extends State<CashOut> {
  DateTime selectedDate = DateTime.now();


  TextEditingController _amountController = TextEditingController();
  TextEditingController _noteController = TextEditingController();
  TextEditingController _dateController = TextEditingController();

  void _onButtonPressed() async{
    final dateString = _dateController.text;
    final format = DateFormat('M/d/yyyy');

    try {
      final formatedDate = format.parse(dateString);

      final data = CashModel(
          date: formatedDate,
          cashOut: double.parse(_amountController.text),
          description: _noteController.text
      );

      final cashEntry = Cashes.getData();
      cashEntry.add(data);
      data.save();

      _amountController.clear();
      _noteController.clear();
      _dateController.clear();

      print(cashEntry);
      print("abcd");
      Navigator.pushNamed(context, '/');
    }catch(e){
      print('Invalid date format $e');
    }
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
    // _cashBox.put(1, "Prashant");
    // print(_cashBox.get(1));
  }

  void readData(){

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[600],
        title: Text('Cash Out'),
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
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter amount',
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
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                  ),
                  onPressed: () {
                    _onButtonPressed();
                  },
                  child: Text(
                    'Save Cash Out',
                  )
              ),
            ),
          ],
        ),
      ),
    );
  }
}
