import 'package:fe/screens/change_password.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

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
                        "Push Puttichai",
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
                  ],
                ),
              ),
            ),
          ),
          // Avatar nằm giữa AppBar và khung trắng
          Positioned(
            top: 40,
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.white,
              child: CircleAvatar(
                radius: 46,
                backgroundImage: AssetImage('lib/images/avatar.png'), // Đường dẫn đến ảnh
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
        type: BottomNavigationBarType.fixed,
        currentIndex: 3,
        selectedItemColor: Color(0xFF2136D6),
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.email), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: ""),
        ],
      ),
    );
  }

  // Hàm tạo mục cài đặt với hiệu ứng chạm (ripple effect)
  Widget _buildSettingsItem({
    required String title,
    VoidCallback? onTap,
    String? trailingText,
  }) {
    return Material(
      color: Colors.transparent, // Không ảnh hưởng đến màu nền
      child: InkWell(
        onTap: onTap, // Thêm hành động cho sự kiện chạm
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
