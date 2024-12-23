import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Language Selection',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LanguageSelectionPage(),
    );
  }
}

class LanguageSelectionPage extends StatelessWidget {
  const LanguageSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Language',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: ListView(
        children: [
          _buildLanguageTile(
            context,
            'Vietnamese',
            'https://upload.wikimedia.org/wikipedia/commons/thumb/2/21/Flag_of_Vietnam.svg/1024px-Flag_of_Vietnam.svg.png',
            isSelected: false,
          ),
          _buildLanguageTile(
            context,
            'French',
            'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c3/Flag_of_France.svg/1024px-Flag_of_France.svg.png',
            isSelected: false,
          ),
          _buildLanguageTile(
            context,
            'English',
            'https://upload.wikimedia.org/wikipedia/en/a/a4/Flag_of_the_United_States.svg',
            isSelected: true,
          ),
          _buildLanguageTile(
            context,
            'Japanese',
            'https://upload.wikimedia.org/wikipedia/commons/thumb/9/9e/Flag_of_Japan.svg/1024px-Flag_of_Japan.svg.png',
            isSelected: false,
          ),
          _buildLanguageTile(
            context,
            'Portuguese',
            'https://upload.wikimedia.org/wikipedia/commons/thumb/5/5c/Flag_of_Portugal.svg/1024px-Flag_of_Portugal.svg.png',
            isSelected: false,
          ),
          _buildLanguageTile(
            context,
            'China',
            'https://upload.wikimedia.org/wikipedia/commons/thumb/0/0d/Flag_of_China.svg/1024px-Flag_of_China.svg.png',
            isSelected: false,
          ),
          _buildLanguageTile(
            context,
            'Korea',
            'https://upload.wikimedia.org/wikipedia/commons/thumb/0/09/Flag_of_South_Korea.svg/1024px-Flag_of_South_Korea.svg.png',
            isSelected: false,
          ),
          _buildLanguageTile(
            context,
            'Nicaragua',
            'https://upload.wikimedia.org/wikipedia/commons/thumb/1/19/Flag_of_Nicaragua.svg/1024px-Flag_of_Nicaragua.svg.png',
            isSelected: false,
          ),
          _buildLanguageTile(
            context,
            'Russia',
            'https://upload.wikimedia.org/wikipedia/commons/thumb/f/f3/Flag_of_Russia.svg/1024px-Flag_of_Russia.svg.png',
            isSelected: false,
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageTile(BuildContext context, String language, String flagUrl, {required bool isSelected}) {
    return Column(
      children: [
        ListTile(
          leading: SizedBox(
            width: 50,
            height: 50,
            child: Image.network(
              flagUrl,
              fit: BoxFit.cover,
            ),
          ),
          title: Text(
            language,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          ),
          trailing: isSelected
              ? const Icon(
            Icons.check,
            color: Colors.blue,
          )
              : null,
          onTap: () {
            // Handle language selection
          },
        ),
        const Divider(),
      ],
    );
  }
}