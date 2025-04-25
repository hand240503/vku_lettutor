import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../providers/auth_provider.dart';
import '../../providers/setting_provider.dart';
import '../../utilities/validator.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late Color myColor;
  late Size mediaSize;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool rememberUser = false;
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
        preferredSize: const Size.fromHeight(
          kToolbarHeight,
        ), // Định kích thước AppBar
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2), // Màu bóng
                spreadRadius: 2, // Độ lan rộng của bóng
                blurRadius: 6, // Độ mờ của bóng
                offset: Offset(0, 3), // Điều chỉnh vị trí bóng (X, Y)
              ),
            ],
          ),
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            elevation: 0, // Tắt bóng mặc định của AppBar
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
          Text(
            AppLocalizations.of(context)!.title,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: myColor, fontSize: 32, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 16),
           Text(
            AppLocalizations.of(context)!.descriptionTitle,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildGreyText("EMAIL"),
          const SizedBox(height: 8),
          _buildInputField(emailController, 'mail@example.com', validator: Validator.validateEmail),
          const SizedBox(height: 16),
          _buildGreyText(AppLocalizations.of(context)!.password),
          const SizedBox(height: 8),
          _buildInputField(passwordController, AppLocalizations.of(context)!.hintPassword,
              isPassword: true, validator: Validator.validatePassword),
          const SizedBox(height: 16),
          _buildGreyText(AppLocalizations.of(context)!.confirmPassword),
          const SizedBox(height: 8),
          _buildInputField(confirmPasswordController, AppLocalizations.of(context)!.confirmPassword,
              isPassword: true, validator: Validator.validateConfirmPassword, isConfirmPassword: true),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () {
              // TODO: Tạo màn hình ForgotPasswordPage và thêm vào routes.
              Navigator.pushNamed(context, '/forgotPasswordPage');
            },
            child: _buildPrimaryColorText(
              AppLocalizations.of(context)!.forgotPassword,
            ),
          ),
          const SizedBox(height: 12),
          _buildSignUpButton(),
          const SizedBox(height: 24),
          _buildOtherLogin(),
        ],
      ),
    );
  }

  Widget _buildGreyText(String text) {
    return Text(
      text,
      style: const TextStyle(color: Colors.grey),
    );
  }

  Widget _buildPrimaryColorText(String text) {
    return Text(text,
        style: TextStyle(
            color: myColor, fontSize: 16, fontWeight: FontWeight.w400));
  }

  Widget _buildInputField(TextEditingController controller, String hintText,
      {isPassword = false, Function? validator, isConfirmPassword}) {
    return TextFormField(
      controller: controller,
      validator: (value) {
        return isConfirmPassword ?? false ? validator!( passwordController.text, value) : validator!(value ?? "");
      },
      decoration: InputDecoration(
        border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0))),
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey.shade400),
        isDense: true, // Added this
        contentPadding: EdgeInsets.all(16),
        suffixIcon: isPassword ? Icon(Icons.remove_red_eye) : null,
      ),
      obscureText: isPassword,
    );
  }

  Widget _buildSignUpButton() {
    var authProvider = Provider.of<AuthProvider>(context, listen: false);
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          //handleCreateAccount(authProvider);
        }
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          // border radius
            borderRadius: BorderRadius.circular(8)),
        backgroundColor: const Color.fromRGBO(4, 104, 211, 1.0),
        minimumSize: const Size.fromHeight(52),
      ),
      child:  Text(
        AppLocalizations.of(context)!.signUp.toUpperCase(),
        style: TextStyle(
            fontSize: 20,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildOtherLogin() {
    return Center(
      child: Column(
        children: [
          _buildGreyText(AppLocalizations.of(context)!.orContinueWith),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Tab(icon: SvgPicture.asset("lib/assets/images/facebook-logo.svg")),
              Tab(icon: SvgPicture.asset("lib/assets/images/google-logo.svg")),
              Padding(
                padding: const EdgeInsets.only(left: 6),
                child: MaterialButton(
                    onPressed: () {},
                    textColor: Colors.white,
                    minWidth: 32,
                    padding: const EdgeInsets.all(8),
                    shape: CircleBorder(
                        side: BorderSide(
                            width: 1, style: BorderStyle.solid, color: myColor)),
                    child: ClipRRect(
                        borderRadius:
                        BorderRadius.circular(10), // Adjust the radius as needed
                        child: const Icon(
                          Icons.phone_android,
                          color: Colors.grey,
                          size: 30,
                        )
                    )
                ),
              )],
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: (){
              Navigator.pushNamed(context, '/loginPage');
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildGreyText(AppLocalizations.of(context)!.alreadyHaveAccount),
                Text(AppLocalizations.of(context)!.login,
                    style: TextStyle(
                        color: myColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w500)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
