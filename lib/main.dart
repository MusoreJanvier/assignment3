import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity/connectivity.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';

import 'signin.dart';
import 'signup.dart';
import 'calculator.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;
  String _connectivityStatus = "Checking connectivity...";
  late FlutterLocalNotificationsPlugin _localNotificationsPlugin;
  late Battery _battery;
  StreamSubscription<BatteryState>? _batterySubscription;
  late ConnectivityResult _connectivityResult;

  @override
  void initState() {
    super.initState();
    _loadThemePreference();
    _initConnectivity();
    _initBatteryMonitor();
    _initLocalNotifications();
  }

  @override
  void dispose() {
    _batterySubscription?.cancel();
    super.dispose();
  }

  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    });
  }

  void _saveThemePreference(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', isDarkMode);
  }

  void _toggleTheme(bool value) {
    setState(() {
      _isDarkMode = value;
      _saveThemePreference(value);
    });
  }

  Future<void> _initConnectivity() async {
    try {
      _connectivityResult = await Connectivity().checkConnectivity();
      if (!mounted) return;
      _updateConnectivityStatus(_connectivityResult);
      Connectivity().onConnectivityChanged.listen(_updateConnectivityStatus);
    } catch (e) {
      print('Error: $e');
    }
  }

  void _updateConnectivityStatus(ConnectivityResult result) {
    setState(() {
      _connectivityResult = result;
      _connectivityStatus = _connectivityResult == ConnectivityResult.none ? "Disconnected" : "Connected";
    });

    Fluttertoast.cancel();
    Fluttertoast.showToast(
      msg: _connectivityStatus,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.grey[900],
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  void _initBatteryMonitor() {
    _battery = Battery();
    _batterySubscription = _battery.onBatteryStateChanged.listen((BatteryState state) async {
      if (state == BatteryState.charging) {
        int batteryLevel = await _battery.batteryLevel;
        if (batteryLevel >= 90) {
          _showBatteryNotification();
        }
      }
    });
  }

  void _initLocalNotifications() {
    _localNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
    _localNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _showBatteryNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'battery_channel',
      'Battery Notifications',
      channelDescription: 'Notification channel for battery alerts',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await _localNotificationsPlugin.show(
      0,
      'Battery Alert',
      'Battery is now 90% or more while charging',
      platformChannelSpecifics,
    );
    Fluttertoast.showToast(
      msg: "Battery is now 90% or more while charging",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.grey[900],
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: _isDarkMode ? Brightness.dark : Brightness.light,
      ),
      home: HomeScreen(
        isDarkMode: _isDarkMode,
        onToggleTheme: _toggleTheme,
        connectivityStatus: _connectivityStatus,
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final bool isDarkMode;
  final Function(bool) onToggleTheme;
  final String connectivityStatus;

  HomeScreen({required this.isDarkMode, required this.onToggleTheme, required this.connectivityStatus});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final List<Widget> _screens = [
    SignInScreen(),
    SignUpScreen(),
    ScientificCalculator(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text('My App'),
            Text(
              widget.connectivityStatus,
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
        actions: [
          Switch(
            value: widget.isDarkMode,
            onChanged: widget.onToggleTheme,
          ),
        ],
      ),
      body: _screens[_selectedIndex],
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.black,
              ),
              child: Text(
                'My App',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.login),
              title: Text('Sign In'),
              onTap: () {
                Navigator.pop(context);
                _onItemTapped(0);
              },
            ),
            ListTile(
              leading: Icon(Icons.person_add),
              title: Text('Sign Up'),
              onTap: () {
                Navigator.pop(context);
                _onItemTapped(1);
              },
            ),
            ListTile(
              leading: Icon(Icons.calculate),
              title: Text('Calculator'),
              onTap: () {
                Navigator.pop(context);
                _onItemTapped(2);
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.login),
            label: 'Sign In',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_add),
            label: 'Sign Up',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: 'Calculator',
          ),
        ],
      ),
    );
  }
}
