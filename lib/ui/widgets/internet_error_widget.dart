import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:golden_thailand/blocs/internet_connection_bloc/internet_connection_bloc.dart';
import 'package:golden_thailand/core/app_theme_const.dart';

///to show when the internet is disconnected
class InternetErrorWidget extends StatelessWidget {
  const InternetErrorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.wifi_off_sharp,
              size: 36,
              color: SScolor.contrast,
            ),
            SizedBox(
              height: 10,
            ),
            Text("No Internet Connection"),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () async {
                BlocProvider.of<InternetConnectionBloc>(context)
                    .add(CheckConnectionEvent());
              },
              child: Text(
                "Try Again",
                style: TextStyle(fontWeight: FontWeight.w400),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: SScolor.primaryColor,
                foregroundColor: SScolor.whiteColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
