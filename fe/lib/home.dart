import 'package:fe/screens/bill_payment_screen.dart';
import 'package:fe/screens/pay_bill_screen.dart';
import 'package:fe/screens/payment_history_screen.dart';
import 'package:fe/screens/transaction_report_screen.dart';
import 'package:fe/screens/transfer_screen.dart';
// import 'package:fe/screens/QRScannerScreen.dart';

import 'package:flutter/material.dart';
import 'screens/api_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'screens/setting.dart';

void main() {
  runApp(const MyApp());
}

// Lấy thông tin người dùng
Future<Map<String, dynamic>> getUserInfo(String token) async {
  final String baseUrl = "http://10.0.2.2:8081";
  final url = Uri.parse(
      '$baseUrl/user/current-user'); // API endpoint để lấy thông tin người dùng

  try {
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Gửi token trong header
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body); // Trả về thông tin người dùng
    } else {
      throw Exception('Failed to fetch user info');
    }
  } catch (e) {
    return {'error': 'An error occurred: $e'};
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Banking App UI',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ApiService apiService = ApiService();
  String userName = 'Loading...'; // Tên mặc định trước khi tải
  Map<String, dynamic> userInfo =
      {}; // Khai báo biến userInfo để lưu thông tin người dùng
  String? token;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arguments =
    ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (arguments != null && arguments.containsKey('token')) {
      token = arguments['token'] as String; // Lưu token vào biến cấp lớp
      fetchUserName(token!); // Gọi API với token
    } else {
      setState(() {
        userName = 'Token not found';
      });
    }
  }

  void fetchUserName(String token) async {
    try {
      // Gọi API để lấy thông tin người dùng
      final fetchedUserInfo =
          await getUserInfo(token); // Lấy thông tin người dùng từ API

      setState(() {
        userInfo = fetchedUserInfo; // Cập nhật userInfo toàn cục
        if (userInfo.containsKey('name')) {
          userName = userInfo['name']; // Cập nhật tên người dùng
        } else {
          userName = 'Unknown User'; // Gán giá trị mặc định nếu không có tên
        }
      });
    } catch (e) {
      // Xử lý lỗi (ví dụ: lỗi mạng, token không hợp lệ)
      debugPrint('Error fetching user info: $e');
      setState(() {
        userName = 'Error loading name'; // Hiển thị lỗi cho người dùng
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        onTap: (index) {
          switch (index) {
            case 0: // Home
              break;
            // case 1: // Quét QR
            //   Navigator.push(
            //     context,
            //     MaterialPageRoute(builder: (context) => const QRScannerScreen()),
            //   );
              break;
            case 2: // Nhận tiền
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PaymentHistoryScreen()),
              );
              break;
            case 3: // Settings
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsScreen(),
                  settings: RouteSettings(
                    arguments: {
                      'token': token, // Truyền token để gọi API trong Settings
                    },
                  ),
                ),
              );
              break;
          }
        },//     }
        //   }
        // },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Quét QR"),
          BottomNavigationBarItem(icon: Icon(Icons.mail), label: "Nhận tiền"),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: "Settings"),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.only(
                  top: 60, left: 16, right: 16, bottom: 10),
              color: Colors.blue.shade800,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 24,
                        backgroundImage: NetworkImage(
                          'https://via.placeholder.com/150', // Replace with user image URL
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Hi, $userName', // Hiển thị tên người dùng từ API
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Stack(
                    children: [
                      const Icon(Icons.notifications,
                          color: Colors.white, size: 28),
                      Positioned(
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: const Text(
                            '3',
                            style: TextStyle(color: Colors.white, fontSize: 10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Bank Card - Padding giao diện thẻ ngân hàng ảo
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.blue.shade800,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      offset: const Offset(0, 4),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: -20,
                      right: -20,
                      child: Container(
                        height: 120,
                        width: 120,
                        decoration: BoxDecoration(
                          color: Colors.lightBlue.shade400,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Hiển thị tên người dùng từ API
                          Text(
                            userInfo.containsKey('name')
                                ? userInfo['name']
                                : 'Unknown User',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 20),
                          ),
                          const SizedBox(height: 10),
                          // Giữ nguyên tên thẻ ngân hàng
                          const Text(
                            'Amazon Platinum',
                            style:
                                TextStyle(color: Colors.white70, fontSize: 14),
                          ),
                          const SizedBox(height: 30),
                          // Hiển thị số thẻ chỉ với 4 số cuối
                          Text(
                            userInfo.containsKey('cardNumber')
                                ? '**** **** **** ${userInfo['cardNumber'].substring(userInfo['cardNumber'].length - 4)}'
                                : '**** **** **** 0000',
                            // Giá trị mặc định nếu không có thông tin số thẻ
                            style: const TextStyle(
                                color: Colors.white, fontSize: 16),
                          ),
                          const SizedBox(height: 20),
                          // Hiển thị số dư tài khoản
                          Text(
                            userInfo.containsKey('balance')
                                ? '\$${userInfo['balance']}'
                                : '\$0.00',
                            // Giá trị mặc định nếu không có thông tin số dư
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Grid Menu
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  MenuCard(
                    icon: Icons.account_balance_wallet,
                    label: "Account and Card",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TransactionReportScreen(),
                          settings: RouteSettings(arguments: {'token': token}), // Truyền token
                        ),
                      );
                    },
                  ),
                  MenuCard(
                    icon: Icons.compare_arrows,
                    label: "Transfer",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TransferScreen(),
                        ),
                      );
                    },
                  ),
                  MenuCard(
                    icon: Icons.atm,
                    label: "Withdraw",
                    onTap: () {},
                  ),
                  MenuCard(
                    icon: Icons.phone_android,
                    label: "Mobile prepaid",
                    onTap: () {},
                  ),
                  MenuCard(
                    icon: Icons.payment,
                    label: "Pay the Bill",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BillPaymentScreen(),
                        ),
                      );
                    },
                  ),
                  MenuCard(
                    icon: Icons.savings,
                    label: "Save online",
                    onTap: () {},
                  ),
                  MenuCard(
                    icon: Icons.credit_card,
                    label: "Credit card",
                    onTap: () {},
                  ),
                  MenuCard(
                    icon: Icons.receipt_long,
                    label: "Transaction report",
                    onTap: () {
                      if (token != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TransactionReportScreen(),
                            settings: RouteSettings(arguments: {'token': token}), // Truyền token
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Token not available")),
                        );
                      }
                    },

                  ),
                  MenuCard(
                    icon: Icons.person_add_alt_1,
                    label: "Beneficiary",
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// MenuCard Widget
class MenuCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap; // Thêm callback onTap

  const MenuCard(
      {super.key,
      required this.icon,
      required this.label,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Kích hoạt callback khi nhấn
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(12),
            child: Icon(icon, color: Colors.blue, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
