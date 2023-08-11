// import 'dart:async';

// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:flutter/material.dart';

// class InternetConnectivity {
//   late Connectivity _connectivity;

//   StreamSubscription<ConnectivityResult>? _subscription;

//   Stream<ConnectivityResult> get connectivityStream =>
//       _connectivity.onConnectivityChanged;

//   Future<bool> checkInternetConnection() async {
//     final result = await _connectivity.checkConnectivity();
//     return result != ConnectivityResult.none;
//   }

//   Future<void> startMonitoring(BuildContext context) async {
//     _connectivity = Connectivity();
//     _subscription = _connectivity.onConnectivityChanged.listen((result) {
//       var a = result.name;
//       // Handle internet connectivity changes here
//       showLongSnackbar(context, "internet is ${result.name}");
//     });
//   }

//   Future<void> stopMonitoring() async {
//     await _subscription?.cancel();
//   }
// }