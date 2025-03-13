part of 'internet_connection_bloc.dart';

@immutable
sealed class InternetConnectionState {}

final class InternetConnectionInitial extends InternetConnectionState {}

final class InternetLoadingState extends InternetConnectionState {}

final class InternetConnectedState extends InternetConnectionState {}

final class InternetDisconnectedState extends InternetConnectionState {}
