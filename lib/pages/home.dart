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
  int _selectedIndex = 1;
  final List<String> _buttonTitles = ['All', 'Daily', 'Weekly', 'Monthly', 'Yearly']; //index 0,1,2,3,4
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

  // DateTime _selectedDate = DateTime.now();

  DateTime today = DateTime.now();
  DateTime _beginingDateForFilter = DateTime.now();
  DateTime _endingDateForFilter = DateTime.now();
  // DateTime _endingDateForFilter = DateTime.now().subtract(Duration(days: 1));
  DateTime _selectedDate = DateTime.now();

  // DateTime startDate = DateTime.now();
  // DateTime endDate = DateTime.now();
  void _onTitlesTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if(_selectedIndex == 1){
      setState(() {
        _beginingDateForFilter = DateTime.now();
        _endingDateForFilter = DateTime.now();
        _selectedDate = DateTime.now();
      });
    }else if(_selectedIndex == 2){
      setState(() {
        _selectedDate = DateTime.now();
        _beginingDateForFilter = _selectedDate.subtract(Duration(days: _selectedDate.weekday ));
        _endingDateForFilter = _beginingDateForFilter.add(Duration(days: 6));
      });
    }
  }

  void _incrementDate() {
    if(_selectedIndex == 1) {
      setState(() {
        _beginingDateForFilter = _beginingDateForFilter.add(Duration(days: 1));
        _endingDateForFilter = _endingDateForFilter.add(Duration(days: 1));
        _selectedDate = _selectedDate.add(Duration(days: 1));
      });
    }else if(_selectedIndex == 2){
      setState(() {
        _beginingDateForFilter = _beginingDateForFilter.add(Duration(days: 7));
        _endingDateForFilter = _endingDateForFilter.add(Duration(days: 7));
        _selectedDate = _selectedDate.add(Duration(days: 7));
      });
    }

  }

  void _decrementDate() {
    if(_selectedIndex == 1) {
      setState(() {
        _beginingDateForFilter = _beginingDateForFilter.subtract(Duration(days: 1));
        _endingDateForFilter = _endingDateForFilter.subtract(Duration(days: 1));
        _selectedDate = _selectedDate.subtract(Duration(days: 1));
      });
    }else if(_selectedIndex == 2){
      setState(() {
        _beginingDateForFilter = _beginingDateForFilter.subtract(Duration(days: 7));
        _endingDateForFilter = _endingDateForFilter.subtract(Duration(days: 7));
        _selectedDate = _selectedDate.subtract(Duration(days: 7));
      });
    }
  }

  double _calculateCashInAmount(Box<CashModel> box,beginingDateForFilter,endingDateForFilter) {
    // DateTime startDate = beginingDateForFilter.subtract(const Duration(days: 1));
    DateTime startDate = DateTime(beginingDateForFilter.year, beginingDateForFilter.month, beginingDateForFilter.day);
    // DateTime endDate = endingDateForFilter.add(const Duration(days: 1));
    DateTime endDate = DateTime(endingDateForFilter.year, endingDateForFilter.month, endingDateForFilter.day);
    return box.values.cast<CashModel>()
      .where((transaction) =>
        transaction.date != null &&
        transaction.date!.isAtSameMomentAs(startDate) ||
        transaction.date!.isAfter(startDate) &&
        transaction.date!.isBefore(endDate)||
            transaction.date!.isAtSameMomentAs(endDate))
      .fold<double>(0.0, (total, transaction) =>
        total + (transaction.cashIn?.toDouble() ?? 0.0)
    );
  }

  double _calculateCashOutAmount(Box<CashModel> box,beginingDateForFilter,endingDateForFilter){
    DateTime startDate = DateTime(beginingDateForFilter.year, beginingDateForFilter.month, beginingDateForFilter.day);
    DateTime endDate = DateTime(endingDateForFilter.year, endingDateForFilter.month, endingDateForFilter.day);
    return box.values.cast<CashModel>()
        .where((transaction) =>
    transaction.date != null &&
        transaction.date!.isAtSameMomentAs(startDate) ||
        transaction.date!.isAfter(startDate) &&
            transaction.date!.isBefore(endDate)||
        transaction.date!.isAtSameMomentAs(endDate))
        .fold<double>(0.0, (total, transaction) =>
    total + (transaction.cashOut?.toDouble() ?? 0.0)
    );
  }

  double _balanceAmount(Box<CashModel> box){
    return _calculateCashInAmount(box,_beginingDateForFilter,_endingDateForFilter) - _calculateCashOutAmount(box,_beginingDateForFilter,_endingDateForFilter);
  }

  double _previousBalanceAmount(Box<CashModel> box,_beginingDateForFilter){
    // final today = DateTime.now();
    // final todayDate = DateTime(today.year, today.month, today.day);
    final beginingDateForFilter = DateTime(_beginingDateForFilter.year, _beginingDateForFilter.month, _beginingDateForFilter.day);
    return box.values.cast<CashModel>()
        .fold<double>(0.0, (total, transaction) {
      if (transaction.date?.year != null && transaction.date?.month != null && transaction.date?.day != null) {
        final transactionDate = DateTime(transaction.date!.year, transaction.date!.month, transaction.date!.day);
        if (transactionDate.isBefore(beginingDateForFilter)) {
          final cashIn = transaction.cashIn?.toDouble() ?? 0.0;
          final cashOut = transaction.cashOut?.toDouble() ?? 0.0;
          return total + cashIn - cashOut;
        }
      }
      return total;
    });
  }

  double _finalBalanceAmount(Box<CashModel> box){
    return _balanceAmount(box) + _previousBalanceAmount(box,_beginingDateForFilter);
  }

  List<CashModel> _getCashList(Box<CashModel> box,beginingDateForFilter,endingDateForFilter){
    DateTime startDate = beginingDateForFilter.subtract(const Duration(days: 1));
    DateTime endDate = endingDateForFilter.add(const Duration(days: 1));
    // DateTime startDate = DateTime(beginingDateForFilter.year, beginingDateForFilter.month, beginingDateForFilter.day);
    // DateTime endDate = DateTime(endingDateForFilter.year, endingDateForFilter.month, endingDateForFilter.day);


    startDate = DateTime(startDate.year, startDate.month, startDate.day);
    endDate = DateTime(endDate.year, endDate.month, endDate.day);
    return box.values.toList().cast<CashModel>().where((transaction) {
      if (transaction.date == null) {
        return false;
      }
      DateTime transactionDate = DateTime(transaction.date!.year, transaction.date!.month, transaction.date!.day);
      return transactionDate.isAfter(startDate) && transactionDate.isBefore(endDate);
    }).toList();
  }


  @override
  Widget build(BuildContext context) {
    bool isToday = _selectedDate.year == today.year && _selectedDate.month == today.month && _selectedDate.day == today.day;
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
                      _onTitlesTapped(index);
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: _decrementDate,
                    icon: Icon(Icons.arrow_left),
                  ),
                  SizedBox(width: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '${DateFormat('d MMM y').format(_beginingDateForFilter)}',
                        style: TextStyle(fontSize: 16),
                      ),
                      if(!isToday || _selectedIndex != 1)
                        Text(
                          '  ->  ${DateFormat('d MMM y').format(_endingDateForFilter)}',
                          style: TextStyle(fontSize: 16),
                        ),
                    ],
                  ),
                  SizedBox(width: 16),
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
                    final myData = _getCashList(box, _beginingDateForFilter,_endingDateForFilter);
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
                    //         myData.length,
                    //             (int index) => DataRow(
                    //           cells: [
                    //             DataCell(Text(myData[index].date.toString())),
                    //             DataCell(Text(myData[index].cashIn.toString())),
                    //             DataCell(Text(myData[index].cashOut.toString())),
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
                          myData.length,
                              (int index) => DataRow(
                            cells: [
                              DataCell(
                                  myData[index].date == null ? Text('') : Text(DateFormat('yyyy-MM-dd').format(myData[index].date!))
                              ),
                              DataCell(
                                  myData[index].cashIn == null ? Text('') :Text(myData[index].cashIn.toString())
                              ),
                              DataCell(
                                  myData[index].cashOut == null ? Text('') :Text(myData[index].cashOut.toString())
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
                            final totalCashIn = _calculateCashInAmount(box,_beginingDateForFilter,_endingDateForFilter);
                            return Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text('Total Cash In $totalCashIn'),
                            );
                          },
                        ),

                        ValueListenableBuilder<Box<CashModel>>(
                          valueListenable: Cashes.getData().listenable(),
                          builder: (BuildContext context,Box<CashModel> box, _) {
                            final totalCashOut = _calculateCashOutAmount(box,_beginingDateForFilter,_endingDateForFilter);
                            return Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text('Total Cash Out $totalCashOut'),
                            );
                          },
                        ),

                        ValueListenableBuilder<Box<CashModel>>(
                          valueListenable: Cashes.getData().listenable(),
                          builder: (BuildContext context,Box<CashModel> box, _) {
                            final balance = _balanceAmount(box);
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
                            final prevBalance = _previousBalanceAmount(box,_beginingDateForFilter);
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
                            final balance = _finalBalanceAmount(box);
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
