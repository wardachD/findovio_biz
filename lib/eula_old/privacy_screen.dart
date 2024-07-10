// import 'package:flutter/material.dart';
// import 'package:flutter_html/flutter_html.dart';
// import 'package:get/get.dart';

// class PrivacyPolicyPage extends StatelessWidget {
//   final String policyType;

//   const PrivacyPolicyPage({super.key, required this.policyType});

//   @override
//   Widget build(BuildContext context) {
//     switch (policyType) {
//       case 'polityka_prywatności':
//         htmlData =
//             politykaPrywatnosci; // Assuming you have a variable named politykaPrywatnosci containing the HTML content of your privacy policy
//         break;
//       case 'regulamin':
//         htmlData =
//             regulamin; // Assuming you have a variable named regulamin containing the HTML content of your terms
//         break;
//       default:
//         // Handle default case
//         break;
//     }

//     return Container(
//       padding: const EdgeInsets.fromLTRB(25, 6, 25, 0),
//       decoration: const BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       child: Column(
//         children: [
//           Column(
//             children: [
//               GestureDetector(
//                 onTap: () => Get.back(),
//                 child: const Row(
//                   children: [
//                     Icon(Icons.arrow_back),
//                     SizedBox(
//                       width: 8,
//                     ),
//                     Text(
//                       'Cofnij',
//                       style: TextStyle(fontSize: 20.0),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(
//                 height: 14,
//               ),
//               SizedBox(
//                 height: MediaQuery.of(context).size.height * 0.7,
//                 child: SingleChildScrollView(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Html(
//                         data: htmlData,
//                         onLinkTap: (url, attributes, element) {
//                           launchUrl(Uri.parse(url.toString()));
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
