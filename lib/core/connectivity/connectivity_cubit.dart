import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Tracks real-time network connectivity.
/// Single Responsibility: connectivity state only.
class ConnectivityCubit extends Cubit<bool> {
  ConnectivityCubit() : super(true) {
    _init();
  }

  late final StreamSubscription<List<ConnectivityResult>> _sub;

  Future<void> _init() async {
    // Check initial state
    final result = await Connectivity().checkConnectivity();
    emit(_isConnected(result));

    // Listen for changes
    _sub = Connectivity().onConnectivityChanged.listen((results) {
      emit(_isConnected(results));
    });
  }

  bool _isConnected(List<ConnectivityResult> results) =>
      results.any((r) => r != ConnectivityResult.none);

  @override
  Future<void> close() {
    _sub.cancel();
    return super.close();
  }
}
