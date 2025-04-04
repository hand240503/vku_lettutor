import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lettutor/providers/setting_provider.dart';
import 'package:provider/provider.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final SettingsProvider settingsProvider = Provider.of(
      context,
      listen: true,
    );
    bool isLocaleVietnamese = settingsProvider.locale == const Locale("vi");

    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      title: SvgPicture.asset(
        'lib/assets/images/lettutor_logo.svg',
        semanticsLabel: "My SVG",
        height: 36,
      ),
      actions: [
        MaterialButton(
          onPressed: () {
            // set locale
            if (settingsProvider.locale == const Locale("vi")) {
              settingsProvider.setLocale(const Locale("en"));
            } else if (settingsProvider.locale == const Locale("en")) {
              settingsProvider.setLocale(const Locale("vi"));
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
        Container(
          child: IconButton(
            icon: const Icon(Icons.menu, color: Colors.grey),
            onPressed: () {
              Scaffold.of(context).openEndDrawer();
            },
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
