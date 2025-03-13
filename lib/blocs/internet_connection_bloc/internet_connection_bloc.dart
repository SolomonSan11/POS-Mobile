import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:meta/meta.dart';
part 'internet_connection_event.dart';
part 'internet_connection_state.dart';

class InternetConnectionBloc
    extends Bloc<InternetConnectionEvent, InternetConnectionState> {
  StreamSubscription<List<ConnectivityResult>>? connectivitySubscription;

  InternetConnectionBloc() : super(InternetConnectionInitial()) {
    // Listen to events
    on<InternetOffEvent>((event, emit) => emit(InternetDisconnectedState()));

    on<InternetOnEvent>((event, emit) => emit(InternetConnectedState()));

    on<InternetLoadingEvent>((event, emit) => emit(InternetLoadingState()));

    // Initialize the connectivity subscription
    connectivitySubscription = Connectivity().onConnectivityChanged.listen(
      (
        List<ConnectivityResult> result,
      ) async {
        add(InternetLoadingEvent());

        await Future.delayed(Duration(milliseconds: 100));

        if (result.contains(ConnectivityResult.wifi) ||
            result.contains(ConnectivityResult.mobile)) {
          print("gain data");
          add(InternetOnEvent());
        } else {
          print("loss data");
          add(InternetOffEvent());
        }
      },
    );
  }

  @override
  Future<void> close() {
    connectivitySubscription?.cancel();
    return super.close();
  }
}
