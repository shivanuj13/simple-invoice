import 'package:flutter/material.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About"),
      ),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Text('''
Welcome to Simple Invoice App!!

It is a simple invoice app that helps you to create and manage your invoices. You can create your own company profile and manage your customers and products.

You can create invoices and send them to your customers via email or WhatsApp. You can also download the invoice as a PDF file.

Our app is free to use. You can create unlimited invoices and manage unlimited customers and products.

With our clean and simple user interface, you can easily create and manage your invoices. You can also customize your invoice with your company logo.

Thank you for using our app. If you have any questions or suggestions, please feel free to contact us at anuj.pussgrc@gmail.com
'''),
        ),
      ),
    );
  }
}
