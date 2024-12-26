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

class LanguageSelectionPage extends StatefulWidget {
  const LanguageSelectionPage({super.key});

  @override
  State<LanguageSelectionPage> createState() => _LanguageSelectionPageState();
}


class _LanguageSelectionPageState extends State<LanguageSelectionPage> {
  // Danh sách các ngôn ngữ với trạng thái isSelected
  final List<Map<String, dynamic>> _languages = [
    {'language': 'Vietnamese', 'assetPath': 'lib/images/flag_vietnam.png', 'isSelected': false},
    {'language': 'French', 'assetPath': 'lib/images/flag_french.png', 'isSelected': false},
    {'language': 'English', 'assetPath': 'lib/images/flag_english.png', 'isSelected': true},
    {'language': 'Japanese', 'assetPath': 'lib/images/flag_japan.png', 'isSelected': false},
    {'language': 'Portuguese', 'assetPath': 'lib/images/flag_portuguese.png', 'isSelected': false},
    {'language': 'China', 'assetPath': 'lib/images/flag_china.png', 'isSelected': false},
    {'language': 'Korea', 'assetPath': 'lib/images/flag_korea.png', 'isSelected': false},
    {'language': 'Nicaragua', 'assetPath': 'lib/images/flag_nicaragua.png', 'isSelected': false},
    {'language': 'Russia', 'assetPath': 'lib/images/flag_russia.png', 'isSelected': false},
  ];

  // Hàm thay đổi trạng thái
  void _onLanguageSelected(int index) {
    setState(() {
      for (int i = 0; i < _languages.length; i++) {
        _languages[i]['isSelected'] = i == index;
      }
    });
  }

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
      body: ListView.builder(
        itemCount: _languages.length,
        itemBuilder: (context, index) {
          final language = _languages[index];
          return _buildLanguageTile(
            context,
            language['language'],
            language['assetPath'],
            isSelected: language['isSelected'],
            onTap: () => _onLanguageSelected(index),
          );
        },
      ),
    );
  }

  Widget _buildLanguageTile(
      BuildContext context,
      String language,
      String flagAssetPath, {
        required bool isSelected,
        required VoidCallback onTap,
      }) {
    return Column(
      children: [
        ListTile(
          leading: SizedBox(
            width: 50,
            height: 50,
            child: Image.asset(
              flagAssetPath, // Sử dụng hình ảnh từ Asset
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
          onTap: onTap, // Gọi hàm khi nhấn vào ListTile
        ),
        const Divider(),
      ],
    );
  }
}