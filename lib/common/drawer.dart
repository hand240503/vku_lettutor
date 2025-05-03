import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lettutor/common/loading_overlay.dart';
import 'package:lettutor/l10n/app_localizations.dart';
import 'package:lettutor/pages/login_page/login_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/auth_provider.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          ListTile(
            title: Container(
              child: Consumer<AuthProvider>(
                builder: (
                  BuildContext context,
                  AuthProvider authProvider,
                  Widget? child,
                ) {
                  final user =
                      authProvider
                          .currentUser; // Lấy thông tin người dùng từ AuthProvider
                  return Row(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        width: 45,
                        height: 45,
                        decoration: const BoxDecoration(shape: BoxShape.circle),
                        child: ClipOval(
                          child: CachedNetworkImage(
                            width: double.maxFinite,
                            fit: BoxFit.fitHeight,
                            imageUrl:
                                "https://randomuser.me/api/portraits/men/75.jpg", // Sử dụng URL avatar từ user
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) => Center(
                                  child: CircularProgressIndicator(
                                    value: downloadProgress.progress,
                                  ),
                                ),
                            errorWidget:
                                (context, url, error) => Image.network(
                                  "https://sandbox.api.lettutor.com/avatar/default-avatar.jpg", // Hình ảnh mặc định nếu có lỗi
                                ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        user!
                            .lastName!, // Hiển thị tên người dùng, nếu không có thì hiển thị "Anonymous"
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/profilePage');
            },
          ),
          ListTile(
            title: Container(
              child: Row(
                children: [
                  Icon(Icons.school, size: 36, color: Colors.blue),
                  SizedBox(width: 12),
                  Text(
                    AppLocalizations.of(context)!.course,
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, "/coursesPage");
            },
          ),
          ListTile(
            title: Container(
              child: Row(
                children: [
                  Icon(Icons.people_alt, size: 36, color: Colors.blue),
                  SizedBox(width: 12),
                  Text(
                    AppLocalizations.of(context)!.becomeATutor,
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            onTap: () {
              Navigator.pushNamed(context, "/becomeATeacherPage");
            },
          ),
          ListTile(
            title: Container(
              child: Row(
                children: [
                  Icon(Icons.logout, size: 36, color: Colors.blue),
                  SizedBox(width: 12),
                  Text(
                    AppLocalizations.of(context)!.logout,
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            onTap: () {
              var authProvider = Provider.of<AuthProvider>(
                context,
                listen: false,
              );
              handleLogout(context, authProvider);
            },
          ),
        ],
      ),
    );
  }

  void handleLogout(BuildContext context, AuthProvider authProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.logout),
          content: Text(AppLocalizations.of(context)!.doYouWantLogout),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            TextButton(
              onPressed: () {
                logOut(authProvider);
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoadingOverlay(child: LoginPage()),
                  ),
                );
              },
              child: Text(AppLocalizations.of(context)!.logout),
            ),
          ],
        );
      },
    );
  }

  Future<void> logOut(AuthProvider authProvider) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      prefs.clear();
      authProvider.clearUserInfo();
    } catch (e) {
      // Xử lý lỗi nếu có
      print('Lỗi khi đăng xuất: $e');
    }
  }
}
