
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class NoInternetConnectionWidget extends StatelessWidget {
  const NoInternetConnectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment:
      MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          'assets/no_internet.svg',
          width: 200,
          height: 200,
          color: Colors.orange,
        ),
        Text(
          'No Internet Connection',
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ],
    );
  }
}
