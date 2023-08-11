import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class InternetConnectivity extends StatefulWidget {
  final Widget child;

  const InternetConnectivity({super.key, required this.child});

  @override
  State<InternetConnectivity> createState() => _InternetConnectivityState();
}

class _InternetConnectivityState extends State<InternetConnectivity> {
  late Connectivity _connectivity;

  StreamSubscription<ConnectivityResult>? _subscription;
  Stream<ConnectivityResult>? _connectivityStream;

  @override
  void initState() {
    super.initState();
    _connectivity = Connectivity();
    _connectivityStream = _connectivity.onConnectivityChanged;
    startMonitoring();
  }

  @override
  void dispose() {
    stopMonitoring();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ConnectivityResult>(
      stream: _connectivityStream,
      builder: (context, snapshot) {
        final isConnected = snapshot.data;
        return FutureBuilder<bool>(
          future: _isInternetAvailable(isConnected),
          builder: (context, internetSnapshot) {
            if (snapshot.connectionState == ConnectionState.waiting ||
                internetSnapshot.connectionState == ConnectionState.waiting) {
              return _buildNoInternetScreen();
              // Display a loading screen if waiting for the result
            } else if (internetSnapshot.hasError) {
              return _buildNoInternetScreen();
              // Display an error screen if an error occurred
            } else {
              final isConnected = internetSnapshot.data ?? false;
              return isConnected ? widget.child : _buildNoInternetScreen();
            }
          },
        );
      },
    );
  }

  Future<bool> _isInternetAvailable(
      ConnectivityResult? connectivityResult) async {
    if (connectivityResult == null) return false;
    if (connectivityResult == ConnectivityResult.none) return false;

    // Additional check by pinging a reliable server
    // Replace with an actual server address you want to ping
    const serverToPing = 'http://www.google.com';
    final isPingSuccessful = await _pingServer(serverToPing);
    return isPingSuccessful;
  }

  Future<bool> _pingServer(String server) async {
    try {
      final response = await http.head(Uri.parse(server));
      debugPrint('response ping ${response.statusCode}');

      return response.statusCode == 200;
      // Successful response indicates internet access
    } catch (e) {
      return false; // Error indicates no internet access
    }
  }

  Widget _buildNoInternetScreen() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("No internet connection"),
            ElevatedButton(
              onPressed: () async {
                final isAvailable = await checkInternetConnection();
                if (isAvailable) {
                  setState(() {}); // Rebuild with the child widget
                }
              },
              child: const Text("Retry"),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> checkInternetConnection() async {
    final result = await _connectivity.checkConnectivity();
    debugPrint('internet is$result');

    return result != ConnectivityResult.none;
  }

  Future<void> stopMonitoring() async {
    await _subscription?.cancel();
  }

  Future<void> startMonitoring() async {
    _subscription = _connectivityStream?.listen((result) {
      var a = result.toString();
      debugPrint('result $a');
    });
  }
}
