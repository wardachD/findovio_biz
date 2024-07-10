import 'package:findovio_business/eula/privacy_screen.dart';
import 'package:flutter/material.dart';

void showUserProfileOptions(BuildContext context, String optionText) {
  showModalBottomSheet(
    showDragHandle: true,
    barrierColor: const Color.fromARGB(214, 0, 0, 0),
    isScrollControlled: true,
    context: context,
    builder: (BuildContext context) {
      return SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            switch (optionText) {
              case 'polityka_prywatności':
                return const PrivacyPolicyPage(
                    policyType: "polityka_prywatności");
              case 'regulamin':
                return const PrivacyPolicyPage(policyType: "regulamin");
              default:
                return Container(); // Return an empty container or default widget
            }
          },
        ),
      );
    },
  );
}
