import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// Centralized toast utility for the whole app.
/// Use [AppToast.error], [AppToast.success], or [AppToast.info] everywhere
/// instead of [ScaffoldMessenger.showSnackBar].
class AppToast {
  AppToast._();

  static void error(String message) {
    Fluttertoast.cancel();
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: const Color(0xFFD32F2F),
      textColor: Colors.white,
      fontSize: 14.0,
    );
  }

  static void success(String message) {
    Fluttertoast.cancel();
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: const Color(0xFF2E7D32),
      textColor: Colors.white,
      fontSize: 14.0,
    );
  }

  static void info(String message) {
    Fluttertoast.cancel();
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: const Color(0xFF1B5E60),
      textColor: Colors.white,
      fontSize: 14.0,
    );
  }
}
