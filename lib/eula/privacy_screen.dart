import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';

import '../eula_old/terms_and_gdpr.dart';

class PrivacyPolicyPage extends StatelessWidget {
  final String policyType;

  const PrivacyPolicyPage({super.key, required this.policyType});

  @override
  Widget build(BuildContext context) {
    String htmlData = '';

    switch (policyType) {
      case 'polityka_prywatności':
        htmlData =
            politykaPrywatnosci; // Assuming you have a variable named politykaPrywatnosci containing the HTML content of your privacy policy
        break;
      case 'regulamin':
        htmlData =
            regulamin; // Assuming you have a variable named regulamin containing the HTML content of your terms
        break;
      default:
        // Handle default case
        break;
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),
            Row(
              children: [
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Icon(Icons.arrow_back_ios),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 12),
                  child: const Text(
                    'Dodaj/usuń lub modyfikuj usługi',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            const Divider(
                color: Color.fromARGB(255, 228, 228, 228), height: 24),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Html(
                      data: htmlData,
                      onLinkTap: (url, attributes, element) =>
                          launchUrl(Uri.parse(url.toString())),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
