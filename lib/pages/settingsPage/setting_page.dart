import 'package:flutter/material.dart';
import 'package:lettutor/common/app_bar.dart';
import 'package:lettutor/common/loading_overlay.dart';
import 'package:lettutor/l10n/app_localizations.dart';
import 'package:lettutor/pages/login_page/login_page.dart';
import 'package:lettutor/providers/auth_provider.dart';
import 'package:lettutor/providers/setting_provider.dart';
import 'package:lettutor/router/app_routes.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  String selectedLanguage = 'English';
  bool isDarkMode = false;
  bool notificationsEnabled = true;
  bool _hasLoadedMode = false;

  @override
  Widget build(BuildContext context) {
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(
      context,
      listen: true,
    );

    if (!_hasLoadedMode) {
      isDarkMode = settingsProvider.themeMode == ThemeMode.dark;
      _hasLoadedMode = true;
    }

    return Scaffold(
      appBar: const CustomAppBar(showMenu: false),
      body: Container(
        padding: const EdgeInsets.all(10),
        color: isDarkMode ? Colors.black : Colors.white,
        child: ListView(
          children: [
            Consumer<AuthProvider>(
              builder: (
                BuildContext context,
                AuthProvider authProvider,
                Widget? child,
              ) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                      authProvider.currentUser?.avatar ??
                          "https://randomuser.me/api/portraits/men/75.jpg",
                    ),
                  ),
                  title: Text(
                    "${authProvider.currentUser?.firstName ?? ''} ${authProvider.currentUser?.lastName ?? 'Anonymous'}"
                        .trim(),
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  subtitle: Text(
                    AppLocalizations.of(context)!.profile,
                    style: TextStyle(
                      color: isDarkMode ? Colors.white70 : Colors.black54,
                    ),
                  ),
                  trailing: Icon(
                    Icons.edit,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                  onTap: () {
                    Navigator.of(
                      context,
                      rootNavigator: true,
                    ).pushNamed(AppRoutes.profile);
                  },
                );
              },
            ),
            ListTile(
              leading: Icon(
                Icons.dark_mode_rounded,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
              title: Text(
                'Dark Mode',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              trailing: Switch.adaptive(
                value: isDarkMode,
                onChanged: (value) {
                  setState(() {
                    isDarkMode = value;
                  });
                  settingsProvider.toggleTheme(value);
                  _showSnackBar(
                    context,
                    isDarkMode ? 'Dark Mode Enabled' : 'Dark Mode Disabled',
                  );
                },
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.language,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
              title: Text(
                AppLocalizations.of(context)!.language,
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              subtitle: Text(
                selectedLanguage,
                style: TextStyle(
                  color: isDarkMode ? Colors.white70 : Colors.black54,
                ),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(
                        AppLocalizations.of(context)!.language,
                        style: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                      content: DropdownButton<String>(
                        value: selectedLanguage,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedLanguage = newValue!;
                          });
                          Future.delayed(Duration.zero, () {
                            if (selectedLanguage == 'English') {
                              settingsProvider.setLocale(const Locale("en"));
                            } else if (selectedLanguage == 'Vietnamese') {
                              settingsProvider.setLocale(const Locale("vi"));
                            }
                            _showSnackBar(
                              context,
                              'Language changed to $selectedLanguage',
                            );
                          });
                        },
                        items:
                            <String>[
                              'English',
                              'Vietnamese',
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            AppLocalizations.of(context)!.cancel,
                            style: TextStyle(
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Ok",
                            style: TextStyle(
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            ListTile(
              leading: Icon(
                Icons.notifications_rounded,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
              title: Text(
                'Notifications',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              trailing: Switch.adaptive(
                value: settingsProvider.notificationsEnabled,
                onChanged: (value) {
                  settingsProvider.toggleNotifications(value);
                  _showSnackBar(
                    context,
                    value ? 'Notifications Enabled' : 'Notifications Disabled',
                  );
                },
              ),
            ),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.red),
              title: Text(
                AppLocalizations.of(context)!.logout,
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              subtitle: Text(
                AppLocalizations.of(context)!.logoutDes,
                style: TextStyle(
                  color: isDarkMode ? Colors.white70 : Colors.black54,
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
      ),
    );
  }

  void handleLogout(BuildContext context, AuthProvider authProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            AppLocalizations.of(context)!.logout,
            style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
          ),
          content: Text(
            AppLocalizations.of(context)!.doYouWantLogout,
            style: TextStyle(
              color: isDarkMode ? Colors.white70 : Colors.black54,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                AppLocalizations.of(context)!.cancel,
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
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
                _showSnackBar(context, 'You have logged out successfully.');
              },
              child: Text(
                AppLocalizations.of(context)!.logout,
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> logOut(AuthProvider authProvider) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    authProvider.clearUserInfo();
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: Duration(seconds: 2)),
    );
  }
}
