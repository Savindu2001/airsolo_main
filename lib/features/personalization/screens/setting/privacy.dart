import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:iconsax/iconsax.dart';

class PrivacyPolicyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Legal Information'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          _buildLegalItem(
            context,
            icon: Iconsax.lock,
            title: 'Privacy Policy',
            content: _privacyPolicyContent,
          ),
          Divider(),
          _buildLegalItem(
            context,
            icon: Iconsax.document_favorite,
            title: 'Terms & Conditions',
            content: _termsConditionsContent,
          ),
          Divider(),
          _buildLegalItem(
            context,
            icon: Iconsax.information,
            title: 'App Details',
            content: _appDetailsContent,
          ),
        ],
      ),
    );
  }

  Widget _buildLegalItem(BuildContext context, {
    required IconData icon,
    required String title,
    required String content,
  }) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).primaryColor),
      title: Text(title, style: Get.textTheme.headlineSmall),
      trailing: Icon(Icons.chevron_right),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LegalDetailPage(
              title: title,
              content: content,
            ),
          ),
        );
      },
    );
  }

  // Sample content - replace with your actual content
  final String _privacyPolicyContent = '''
# Privacy Policy

Last updated: January 1, 2025

1. Information We Collect

We collect information you provide directly to us, such as when you create an account, make a booking, or contact customer support.

2. How We Use Your Information

We use the information we collect to:
- Provide and improve our services
- Process transactions
- Communicate with you
- Personalize your experience

3. Information Sharing

We do not sell your personal information to third parties. We may share information with service providers who assist us in operating our services.
''';

  final String _termsConditionsContent = '''
# Terms & Conditions

Last updated: January 1, 2023

 1. Acceptance of Terms

By using our app, you agree to these Terms and Conditions. If you do not agree, please do not use our app.

 2. User Responsibilities

You agree to:
- Provide accurate information
- Use the app for lawful purposes only
- Not engage in fraudulent activities

 3. Service Modifications

We reserve the right to modify or discontinue the app at any time without notice.
''';

  final String _appDetailsContent = '''
 App Details

 Version
1.0.0

 Developer
Savindu Senanayake - Nsbm

## Contact
support@airsolo.com

## Release Date
May 5, 2025

## Features
- Book taxis
- Reserve hostels
- View booking history
- Manage payments
''';
}

class LegalDetailPage extends StatelessWidget {
  final String title;
  final String content;

  const LegalDetailPage({
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Text(
          content,
          style: TextStyle(fontSize: 16, height: 1.5),
        ),
      ),
    );
  }
}