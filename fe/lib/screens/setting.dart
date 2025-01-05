import 'package:fe/screens/change_password.dart';
import 'package:fe/screens/sign_in.dart';
import 'package:fe/screens/transaction_report_screen.dart';
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'QRcode.dart';
import 'payment_history_screen.dart';
import 'package:fe/screens/home.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int _selectedIndex = 3; // Mặc định chọn mục Settings
  String userName = 'Loading...'; // Hiển thị tên mặc định trước khi tải
  String? token;

  // Phương thức xử lý điều hướng khi nhấn vào các mục BottomNavigationBar
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Điều hướng đến các màn hình khác tùy theo mục đã chọn
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()), // Thay bằng màn hình Home của bạn
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => PaymentHistoryScreen()), // Thay bằng màn hình Email của bạn
        );
        break;
      case 3:
      // Giữ lại màn hình Settings
        break;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arguments = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (arguments != null && arguments.containsKey('token')) {
      token = arguments['token']; // Nhận token từ arguments
      fetchUserName(token!); // Gọi API để lấy thông tin người dùng khi có token
    }
  }

  void fetchUserName(String token) async {
    try {
      // Giả sử bạn đã có phương thức getUserInfo để gọi API
      final fetchedUserInfo = await getUserInfo(token); // Gọi API với token
      setState(() {
        if (fetchedUserInfo.containsKey('name')) {
          userName = fetchedUserInfo['name']; // Cập nhật tên người dùng
        } else {
          userName = 'Unknown User'; // Nếu không có tên, hiển thị Unknown User
        }
      });
    } catch (e) {
      debugPrint('Error fetching user info: $e');
      setState(() {
        userName = 'Error loading name'; // Hiển thị thông báo lỗi nếu không tải được tên
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2136D6),
      body: Stack(
        alignment: Alignment.center,
        children: [
          // Khung trắng chứa nội dung
          Positioned.fill(
            top: 80,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(vertical: 80, horizontal: 20),
                child: Column(
                  children: [
                    Center(
                      child: Text(
                        userName, // Hiển thị tên người dùng lấy từ API
                        style: TextStyle(
                          color: Color(0xFF2136D6),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    _buildSettingsItem(
                      title: "Password",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ChangePasswordScreen()),
                        );
                      },
                    ),
                    _buildSettingsItem(
                      title: "Touch ID",
                      onTap: () {},
                    ),
                    _buildSettingsItem(
                      title: "Languages",
                      onTap: () {},
                    ),
                    _buildSettingsItem(
                      title: "App information",
                      onTap: () {},
                    ),
                    _buildSettingsItem(
                      title: "Customer care",
                      trailingText: "19008989",
                      onTap: () {},
                    ),
                    _buildSettingsItem(
                      title: "Log Out",
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => SignInScreen()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Avatar giữa AppBar và khung trắng
          Positioned(
            top: 40,
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.white,
              child: CircleAvatar(
                radius: 46,
                backgroundImage: AssetImage('lib/images/avatar.png'), // Đường dẫn đến ảnh avatar
              ),
            ),
          ),
          // AppBar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Text(
                "Setting",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        ],
      ),
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
            case 3: // Mã QRcode
              final apiService = ApiService(); // Tạo instance của ApiService
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const QRcodeScreen(),
                  settings: RouteSettings(
                    arguments: {
                      'token': token, // Truyền token từ màn hình trước
                    },
                  ),
                ),
              );
              break;
            case 4: // Settings
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
          BottomNavigationBarItem(icon: Icon(Icons.qr_code_scanner), label: "Quét QR"),
          BottomNavigationBarItem(icon: Icon(Icons.mail), label: "Nhận tiền"),
          BottomNavigationBarItem(icon: Icon(Icons.qr_code), label: "Mã QR"),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: "Settings"),
        ],
      ),
    );
  }

  // Phương thức tạo mục cài đặt với hiệu ứng ripple
  Widget _buildSettingsItem({
    required String title,
    VoidCallback? onTap,
    String? trailingText,
  }) {
    return Material(
      color: Colors.transparent, // Không ảnh hưởng đến màu nền
      child: InkWell(
        onTap: onTap, // Thêm hành động khi chạm vào
        borderRadius: BorderRadius.circular(10), // Thiết lập border radius cho hiệu ứng ripple
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
          trailing: trailingText != null
              ? Text(
            trailingText,
            style: TextStyle(color: Colors.grey, fontSize: 14),
          )
              : Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        ),
      ),
    );
  }
}
