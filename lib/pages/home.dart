import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<String> _buttonTitles = ['All', 'Daily', 'Weekly', 'Monthly', 'Yearly'];

  final List<List<String>> data = [
    ['March 1', '500', '-'],
    ['March 2', '600', '-'],
    ['March 3', '-', '700'],
    ['March 4', '-', '100'],
    ['March 6', '1000', '-'],
  ];

  DateTime _selectedDate = DateTime.now();

  void _incrementDate() {
    setState(() {
      _selectedDate = _selectedDate.add(Duration(days: 1));
    });
  }

  void _decrementDate() {
    setState(() {
      _selectedDate = _selectedDate.subtract(Duration(days: 1));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[600],
        title: Text('Cash Book'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                _buttonTitles.length,
                    (index) => ElevatedButton(
                  onPressed: () {
                    // Add your onPressed code here.
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.blueGrey),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                    ),
                  ),
                  child: Text(_buttonTitles[index]),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: _decrementDate,
                  icon: Icon(Icons.arrow_left),
                ),
                Text(
                  DateFormat('EEE, MMM dd').format(_selectedDate),
                  style: TextStyle(fontSize: 18.0),
                ),
                IconButton(
                  onPressed: _incrementDate,
                  icon: Icon(Icons.arrow_right),
                ),
              ],
            ),
            SingleChildScrollView(
              child: DataTable(
                columns: [
                  DataColumn(
                    label: Text('Date'),
                  ),
                  DataColumn(
                    label: Text('Cash In'),
                  ),
                  DataColumn(
                    label: Text('Cash Out'),
                  ),
                ],
                rows: List<DataRow>.generate(
                  data.length,
                      (int index) {
                    return DataRow(
                      cells: [
                        DataCell(Text(data[index][0])),
                        DataCell(Text(data[index][1])),
                        DataCell(Text(data[index][2])),
                      ],
                    );
                  },
                ),
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/form');
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                  ),
                  child: Text("Cash In"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/form');
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text("Cash Out"),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.fromLTRB(5.0, 20.0, 5.0, 10.0),
              child: Table(
                border: TableBorder.all(),
                columnWidths: {
                  0: FlexColumnWidth(2),
                  1: FlexColumnWidth(1),
                  2: FlexColumnWidth(1),
                },
                children: [
                  TableRow(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Total Cash In'),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Total Cash Out'),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Balance'),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(''),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Previoys Balance'),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('500'),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(''),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Balance'),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('500'),
                      ),
                    ],
                  ),
                ],
              )
            )
          ],
        ),
      ),
    );
  }
}
