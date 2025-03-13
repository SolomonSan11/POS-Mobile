part of 'internet_connection_bloc.dart';

@immutable
sealed class InternetConnectionEvent {}

class CheckConnectionEvent extends InternetConnectionEvent{}

class InternetOffEvent extends InternetConnectionEvent {} 

class InternetOnEvent extends InternetConnectionEvent {}

class InternetLoadingEvent extends InternetConnectionEvent {}
