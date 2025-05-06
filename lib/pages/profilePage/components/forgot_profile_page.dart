import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lettutor/l10n/app_localizations.dart';
import 'package:lettutor/providers/auth_provider.dart';
import 'package:lettutor/providers/setting_provider.dart';
import 'package:lettutor/utilities/validator.dart';
import 'package:provider/provider.dart';

class ForgotProfilePage extends StatefulWidget {
  // Removed force parameter here
  const ForgotProfilePage({super.key}); // Removed force parameter here

  @override
  State<ForgotProfilePage> createState() => _ForgotProfilePageState();
}

class _ForgotProfilePageState extends State<ForgotProfilePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late Color myColor;
  late Size mediaSize;
  TextEditingController emailController = TextEditingController();
  bool rememberUser = false;

  bool loading = true;
  bool _isLocaleVietnamese = true;

  void _toggleLanguage() {
    final settingsProvider = Provider.of<SettingsProvider>(
      context,
      listen: false,
    );

    setState(() {
      if (settingsProvider.locale.languageCode == 'vi') {
        settingsProvider.setLocale(const Locale("en"));
      } else {
        settingsProvider.setLocale(const Locale("vi"));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    myColor = Theme.of(context).colorScheme.primary;
    return _buildMainContent(context);
  }

  Widget _buildMainContent(BuildContext context) {
    final SettingsProvider settingsProvider = Provider.of(
      context,
      listen: true,
    );
    _isLocaleVietnamese = settingsProvider.locale == const Locale("vi");

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            elevation: 0,
            title: SvgPicture.asset(
              'lib/assets/images/lettutor_logo.svg',
              semanticsLabel: 'My SVG',
              height: 36,
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 6),
                child: MaterialButton(
                  onPressed: _toggleLanguage,
                  minWidth: 20,
                  color: Colors.grey.shade300,
                  padding: const EdgeInsets.all(8),
                  shape: const CircleBorder(),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child:
                        _isLocaleVietnamese
                            ? SvgPicture.asset(
                              'lib/assets/images/vietnam.svg',
                              semanticsLabel: "My SVG",
                              height: 22,
                            )
                            : SvgPicture.asset(
                              'lib/assets/images/united-states.svg',
                              height: 22,
                            ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: ListView(
        children: [
          Image.asset('lib/assets/images/loginImage.png', fit: BoxFit.fitWidth),
          Padding(padding: const EdgeInsets.all(24.0), child: _buildForm()),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.always,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            alignment: Alignment.center,
            child: Text(
              AppLocalizations.of(context)!.resetPassword,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: myColor,
                fontSize: 32,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.forgotPasswordTitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildGreyText("EMAIL"),
          const SizedBox(height: 8),
          _buildInputField(
            emailController,
            'mail@example.com',
            validator: Validator.validateEmail,
          ),
          const SizedBox(height: 12),
          _buildResetButton(),
        ],
      ),
    );
  }

  Widget _buildGreyText(String text) {
    return Text(text, style: const TextStyle(color: Colors.grey));
  }

  Widget _buildPrimaryColorText(String text) {
    return Text(
      text,
      style: TextStyle(
        color: myColor,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Widget _buildInputField(
    TextEditingController controller,
    String hintText, {
    isPassword = false,
    Function? validator,
  }) {
    return TextFormField(
      validator: (value) {
        return validator!(value ?? "");
      },
      controller: controller,
      decoration: InputDecoration(
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey.shade400),
        isDense: true,
        contentPadding: EdgeInsets.all(16),
        suffixIcon: isPassword ? Icon(Icons.remove_red_eye) : null,
      ),
      obscureText: isPassword,
    );
  }

  Widget _buildResetButton() {
    var authProvider = Provider.of<AuthProvider>(context);
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          handleResetPassword(authProvider);
        }
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        backgroundColor: const Color.fromRGBO(4, 104, 211, 1.0),
        minimumSize: const Size.fromHeight(52),
      ),
      child: Text(
        AppLocalizations.of(context)!.resetLink.toUpperCase(),
        style: const TextStyle(
          fontSize: 20,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // handle forgot password
  void handleResetPassword(AuthProvider authProvider) async {
    bool success = await authProvider.sendPasswordResetEmail(
      emailController.text,
    );
    if (success) {
      print('Email đã được gửi');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Email yêu cầu đặt lại mật khẩu đã được gửi')),
      );
    } else {
      print('Email không được gửi');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gửi email thất bại, vui lòng thử lại')),
      );
    }
  }
}
