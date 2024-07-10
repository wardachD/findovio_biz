import 'package:flutter/material.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: const Row(
        children: [
          Icon(
            Icons.arrow_back_outlined,
            size: 22,
          ),
          // SizedBox(
          //   width: 10,
          // ),
          // Text(
          //   'Cofnij',
          //   style: TextStyle(
          //     fontSize: 20,
          //   ),
          // )
        ],
      ),
    );
  }
}
