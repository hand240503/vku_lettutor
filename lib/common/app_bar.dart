import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lettutor/providers/setting_provider.dart';
import 'package:provider/provider.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showMenu; // Thêm biến showMenu

  const CustomAppBar({super.key, this.showMenu = true}); // Mặc định là true

  @override
  Widget build(BuildContext context) {
    final SettingsProvider settingsProvider = Provider.of(
      context,
      listen: true,
    );
    bool isLocaleVietnamese = settingsProvider.locale == const Locale("vi");

    return AppBar(
      automaticallyImplyLeading: false, // Không dùng nút back tự động
      backgroundColor: Colors.white,
      title: SvgPicture.asset(
        'lib/assets/images/lettutor_logo.svg',
        semanticsLabel: "My SVG",
        height: 36,
      ),
      actions: [
        MaterialButton(
          onPressed: () {
            if (settingsProvider.locale == const Locale("vi")) {
              settingsProvider.setLocale(const Locale("en"));
            } else {
              settingsProvider.setLocale(const Locale("vi"));
            }
          },
          minWidth: 20,
          color: Colors.grey.shade300,
          textColor: Colors.white,
          padding: const EdgeInsets.all(6),
          shape: const CircleBorder(),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child:
                isLocaleVietnamese
                    ? SvgPicture.asset(
                      'lib/assets/images/vietnam.svg',
                      semanticsLabel: "My SVG",
                      height: 18,
                    )
                    : SvgPicture.asset(
                      'lib/assets/images/united-states.svg',
                      height: 18,
                    ),
          ),
        ),
        IconButton(
          icon: Icon(
            showMenu ? Icons.menu : Icons.arrow_back,
            color: Colors.grey,
          ),
          onPressed: () {
            if (showMenu) {
              Scaffold.of(context).openEndDrawer();
            } else {
              Navigator.maybePop(context);
            }
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
