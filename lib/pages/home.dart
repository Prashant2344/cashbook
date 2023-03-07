import 'package:cashbook/boxes/cashes.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:cashbook/models/cash_model.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<String> _buttonTitles = ['All', 'Daily', 'Weekly', 'Monthly', 'Yearly'];
  // late Box<CashModel> _cashBox;
  // List<CashModel> _transactions = [];
  //
  // @override
  // void initState() {
  //   super.initState();
  //   _cashBox = Hive.box<CashModel>('cashBox');
  //   _transactions = _cashBox.values.cast<CashModel>().toList();
  // }

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

  double _calculateCashInAmount(Box<CashModel> box) {
    return box.values.cast<CashModel>()
        .fold<double>(0.0, (total, transaction) =>
    total + (transaction.cashIn?.toDouble() ?? 0.0)
    );
  }

  double _calculateCashOutAmount(Box<CashModel> box){
    // double totalCost = 0.0;
    // final transactions = box.values.toList().cast<CashModel>();
    // for (final transaction in transactions) {
    //   final cost = transaction.cashOut ?? 0.0 as double;
    //   totalCost += cost;
    // }
    // return totalCost;

    return box.values.cast<CashModel>()
        .fold<double>(0.0, (total, transaction) =>
    total + (transaction.cashOut?.toDouble() ?? 0.0)
    );
  }

  double _balanceAmount(Box<CashModel> box){
    return _calculateCashInAmount(box) - _calculateCashOutAmount(box);
  }

  double _previousBalanceAmount(Box<CashModel> box){
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    return box.values.cast<CashModel>()
        .fold<double>(0.0, (total, transaction) {
      if (transaction.date?.year != null && transaction.date?.month != null && transaction.date?.day != null) {
        final transactionDate = DateTime(transaction.date!.year, transaction.date!.month, transaction.date!.day);
        if (transactionDate.isBefore(todayDate)) {
          final cashIn = transaction.cashIn?.toDouble() ?? 0.0;
          return total + cashIn;
        }
      }
      return total;
    });
  }

  double _finalBalanceAmount(Box<CashModel> box){
    return _balanceAmount(box) - _previousBalanceAmount(box);
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
            Expanded(
              flex: 2,
              child: Row(
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
            ),

            Expanded(
              flex: 1,
              child: Row(
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
            ),

            //Data table
            Expanded(
              flex: 12,
              child: Container(
                width: double.infinity,
                // height: 300.0,
                child: ValueListenableBuilder<Box<CashModel>>(
                  valueListenable: Cashes.getData().listenable(),
                  builder: (BuildContext context, Box<CashModel> box, _) {
                    final myModels = box.values.toList().cast<CashModel>();
                    // return SingleChildScrollView(
                    //   scrollDirection: Axis.horizontal,
                    //   child: ConstrainedBox(
                    //     constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width),
                    //     child: DataTable(
                    //       columns: [
                    //         DataColumn(label: Text('Date')),
                    //         DataColumn(label: Text('Cash In')),
                    //         DataColumn(label: Text('Cash Out')),
                    //       ],
                    //       rows: List<DataRow>.generate(
                    //         myModels.length,
                    //             (int index) => DataRow(
                    //           cells: [
                    //             DataCell(Text(myModels[index].date.toString())),
                    //             DataCell(Text(myModels[index].cashIn.toString())),
                    //             DataCell(Text(myModels[index].cashOut.toString())),
                    //           ],
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // );

                    return SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: DataTable(
                        columns: [
                          DataColumn(label: Text('Date')),
                          DataColumn(label: Text('Cash In')),
                          DataColumn(label: Text('Cash Out')),
                        ],
                        rows: List<DataRow>.generate(
                          myModels.length,
                              (int index) => DataRow(
                            cells: [
                              DataCell(
                                  myModels[index].date == null ? Text('') : Text(DateFormat('yyyy-MM-dd').format(myModels[index].date!))
                              ),
                              DataCell(
                                  myModels[index].cashIn == null ? Text('') :Text(myModels[index].cashIn.toString())
                              ),
                              DataCell(
                                  myModels[index].cashOut == null ? Text('') :Text(myModels[index].cashOut.toString())
                              ),
                            ],
                          ),
                        ),
                      ),
                    );

                  },
                ),
              ),
            ),

            // SingleChildScrollView(
            //   child: DataTable(
            //     columns: [
            //       DataColumn(
            //         label: Text('Date'),
            //       ),
            //       DataColumn(
            //         label: Text('Cash In'),
            //       ),
            //       DataColumn(
            //         label: Text('Cash Out'),
            //       ),
            //     ],
            //     rows: List<DataRow>.generate(
            //       data.length,
            //           (int index) {
            //         return DataRow(
            //           cells: [
            //             DataCell(Text(data[index][0])),
            //             DataCell(Text(data[index][1])),
            //             DataCell(Text(data[index][2])),
            //           ],
            //         );
            //       },
            //     ),
            //   ),
            // ),

            Expanded(
              flex: 2,
              child: Row(
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
                      Navigator.pushNamed(context, '/cashout');
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
            ),

            Expanded(
              flex: 4,
              child: Container(
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
                        ValueListenableBuilder<Box<CashModel>>(
                          valueListenable: Cashes.getData().listenable(),
                          builder: (BuildContext context,Box<CashModel> box, _) {
                            final totalCashIn = _calculateCashInAmount(box); // assuming you have a function that calculates total cost
                            return Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text('Total Cash In $totalCashIn'),
                            );
                          },
                        ),

                        ValueListenableBuilder<Box<CashModel>>(
                          valueListenable: Cashes.getData().listenable(),
                          builder: (BuildContext context,Box<CashModel> box, _) {
                            final totalCashOut = _calculateCashOutAmount(box); // assuming you have a function that calculates total cost
                            return Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text('Total Cash Out $totalCashOut'),
                            );
                          },
                        ),

                        ValueListenableBuilder<Box<CashModel>>(
                          valueListenable: Cashes.getData().listenable(),
                          builder: (BuildContext context,Box<CashModel> box, _) {
                            final balance = _balanceAmount(box); // assuming you have a function that calculates total cost
                            return Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text('Balance $balance'),
                            );
                          },
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
                          child: Text('Previous Balance'),
                        ),
                        ValueListenableBuilder<Box<CashModel>>(
                          valueListenable: Cashes.getData().listenable(),
                          builder: (BuildContext context,Box<CashModel> box, _) {
                            final prevBalance = _previousBalanceAmount(box); // assuming you have a function that calculates total cost
                            return Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text('$prevBalance'),
                            );
                          },
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
                        ValueListenableBuilder<Box<CashModel>>(
                          valueListenable: Cashes.getData().listenable(),
                          builder: (BuildContext context,Box<CashModel> box, _) {
                            final balance = _finalBalanceAmount(box); // assuming you have a function that calculates total cost
                            return Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text('$balance'),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                )
              ),
            )
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     _calculateAmount();
      //   },
      //   child: Icon(Icons.add),
      // ),
    );
  }
}
