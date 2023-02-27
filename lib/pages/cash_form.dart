import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CashForm extends StatefulWidget {
  const CashForm({Key? key}) : super(key: key);

  @override
  State<CashForm> createState() => _CashFormState();
}

class _CashFormState extends State<CashForm> {
  TextEditingController _textEditingController = TextEditingController();
  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1900),
        lastDate: DateTime.now());
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        _textEditingController.text =
            DateFormat.yMd().format(selectedDate);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[600],
        title: Text('Cash In'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter a amount',
                  suffixIcon: Icon(Icons.money_sharp),
                ),
              ),
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextField(
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
                controller: _textEditingController,
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
                  onPressed: () {},
                  child: Text('Select date')
              ),
            ),
          ],
        ),
      ),
    );
  }
}
