import 'package:flutter/material.dart';
import 'package:music_stream/httpcalls/soundcloud.dart';
import 'package:music_stream/pages/homescreen.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  final TextStyle _tStyle = TextStyle(
    color: Colors.black87,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: Text(
          'Music stream',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        elevation: 1.0,
        backgroundColor: Colors.white,
      ),
      endDrawer: Drawer(
        child: ListTile(
          onTap: () => addToCloud('633309999'),
          title: Text('Add to sound cloud'),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        //type: BottomNavigationBarType.shifting,
        selectedItemColor: Colors.orange,
        currentIndex: _selectedIndex,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            title: Text(
              'Home',
              style: _tStyle,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
            ),
            title: Text(
              'Discover',
              style: _tStyle,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.favorite_border,
            ),
            title: Text(
              'MyList',
              style: _tStyle,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person_outline,
            ),
            title: Text(
              'MyProfile',
              style: _tStyle,
            ),
          ),
        ],
      ),
      body: HomeScreen(),
    );
  }
}
