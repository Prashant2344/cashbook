import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
            TextButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/form');
                },
                icon: Icon(Icons.money),
                label: Text('Cash In'),
            ),
            SizedBox(height: 20.0),
            Row(
              children: <Widget>[
                Text('Select a photo'),
                Text('Second row')
              ],
            ),
            SizedBox(height: 20.0),
            Text('Second column')
          ],
        ),
      ),
    );
  }
}
