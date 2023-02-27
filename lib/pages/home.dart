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
        backgroundColor: Colors.grey[200],
        title: Text('Cash Book'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            TextButton.icon(
                onPressed: () {},
                icon: Icon(Icons.add_a_photo),
                label: Text('Add a photo'),
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
