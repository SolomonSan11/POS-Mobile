import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:golden_thailand/blocs/internet_connection_bloc/internet_connection_bloc.dart';
import 'package:golden_thailand/ui/widgets/common_widget.dart';
import 'package:golden_thailand/ui/widgets/internet_error_widget.dart';

class InternetCheckWidget extends StatelessWidget {
  const InternetCheckWidget({
    super.key,
    required this.child,
    required this.onRefresh,
  });
  final Widget child;
  final Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InternetConnectionBloc, InternetConnectionState>(
      listener: (context, state) {
        if (state is InternetConnectedState) {
          onRefresh();
        } else {}
      },
      builder: (context, state) {
        if (state is InternetConnectedState) {
          return child;
        } else if (state is InternetDisconnectedState) {
          return Center(child: InternetErrorWidget());
        } else if (state is InternetLoadingState) {
          return loadingWidget();
        } else {
          return Container();
        }
      },
    );
  }
}
