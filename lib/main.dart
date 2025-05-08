import 'package:flutter/material.dart';
import 'package:lettutor/data/services/noti_service.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  // Đảm bảo rằng việc khởi tạo xong trước khi chạy ứng dụng
  WidgetsFlutterBinding.ensureInitialized();

  // Khởi tạo dịch vụ thông báo
  await LocalNotificationService().initialize();

  // Yêu cầu quyền thông báo
  await requestNotificationPermission();
  await requestExactAlarmPermission();
  // Sau khi khởi tạo xong, chạy ứng dụng
  runApp(MyApp());
}

// Phương thức yêu cầu quyền thông báo
Future<void> requestNotificationPermission() async {
  // Kiểm tra quyền thông báo
  PermissionStatus status = await Permission.notification.status;
  if (!status.isGranted) {
    // Yêu cầu quyền thông báo
    PermissionStatus newStatus = await Permission.notification.request();
    if (newStatus.isGranted) {
      print("Notification permission granted!");
    } else {
      print("Notification permission denied!");
    }
  } else {
    print("Notification permission already granted");
  }
}

Future<void> requestExactAlarmPermission() async {
  PermissionStatus status = await Permission.scheduleExactAlarm.status;
  if (!status.isGranted) {
    PermissionStatus newStatus = await Permission.scheduleExactAlarm.request();
    if (newStatus.isGranted) {
      print("Exact alarm permission granted!");
    } else {
      print("Exact alarm permission denied!");
    }
  } else {
    print("Exact alarm permission already granted");
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Notification Example',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
        appBar: AppBar(title: Text('Flutter Local Notifications')),
        body: Center(
          child: ElevatedButton(
            onPressed: () async {
              await LocalNotificationService().showNotification(
                id: 1,
                title: 'Lịch học',
                body: 'Đã đến giờ học của bạn!',
                payload: 'Lịch học',
              );
            },
            child: Text('Kiểm tra thông báo đã lên lịch'),
          ),
        ),
      ),
    );
  }
}
