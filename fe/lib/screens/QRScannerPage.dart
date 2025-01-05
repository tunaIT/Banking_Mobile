// import 'package:flutter/material.dart';
// import 'package:barcode_scan2/barcode_scan2.dart'; // Thư viện barcode_scan2
// import 'package:permission_handler/permission_handler.dart'; // Kiểm tra quyền camera
// import 'package:url_launcher/url_launcher.dart'; // Để mở liên kết từ QR code
//
// class QRScannerPage extends StatefulWidget {
//   @override
//   _QRScannerPageState createState() => _QRScannerPageState();
// }
//
// class _QRScannerPageState extends State<QRScannerPage> {
//   PermissionStatus? _cameraPermissionStatus;
//
//   @override
//   void initState() {
//     super.initState();
//     _checkPermissionsAndScan();
//   }
//
//   // Kiểm tra quyền camera và quét QR ngay khi vào trang
//   Future<void> _checkPermissionsAndScan() async {
//     final status = await Permission.camera.request();
//     setState(() {
//       _cameraPermissionStatus = status;
//     });
//
//     if (status.isGranted) {
//       _scanQRCode();
//     } else if (status.isPermanentlyDenied) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(
//             "Ứng dụng cần quyền camera để quét mã QR. Vui lòng cấp quyền trong Cài đặt.",
//           ),
//           action: SnackBarAction(
//             label: "Cài đặt",
//             onPressed: openAppSettings,
//           ),
//         ),
//       );
//     }
//   }
//
//   // Hàm quét mã QR
//   Future<void> _scanQRCode() async {
//     try {
//       ScanResult scanResult = await BarcodeScanner.scan();
//       String data = scanResult.rawContent;
//
//       if (data.isNotEmpty) {
//         _handleScannedData(data);
//       } else {
//         _showErrorDialog("Không nhận được dữ liệu từ mã QR.");
//       }
//     } catch (e) {
//       _showErrorDialog("Lỗi trong quá trình quét mã QR: $e");
//     }
//   }
//
//   // Xử lý dữ liệu quét được
//   Future<void> _handleScannedData(String data) async {
//     if (Uri.tryParse(data)?.hasAbsolutePath ?? false) {
//       if (await canLaunch(data)) {
//         await launch(data);
//       } else {
//         _showErrorDialog("Không thể mở liên kết từ mã QR.");
//       }
//     } else {
//       _showErrorDialog("Dữ liệu mã QR không hợp lệ.");
//     }
//   }
//
//   // Hiển thị thông báo lỗi
//   void _showErrorDialog(String message) {
//     showDialog(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         title: Text("Lỗi"),
//         content: Text(message),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.of(ctx).pop();
//             },
//             child: Text("Đóng"),
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Color(0xFF2136D6),
//         title: Text("Quét Mã QR"),
//         foregroundColor: Colors.white,
//       ),
//       body: _cameraPermissionStatus == null
//           ? Center(child: CircularProgressIndicator())
//           : _cameraPermissionStatus == PermissionStatus.granted
//           ? Center(child: Text("Đang quét mã QR..."))
//           : _buildPermissionDenied(),
//     );
//   }
//
//   // Giao diện khi quyền camera bị từ chối
//   Widget _buildPermissionDenied() {
//     return Center(
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Text(
//             "Ứng dụng cần quyền camera để quét mã QR.",
//             textAlign: TextAlign.center,
//           ),
//           SizedBox(height: 20),
//           ElevatedButton(
//             onPressed: openAppSettings,
//             child: Text("Mở Cài đặt"),
//           ),
//         ],
//       ),
//     );
//   }
// }
