import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lettutor/common/loading_overlay.dart';
import 'package:lettutor/l10n/app_localizations.dart';
import 'package:lettutor/providers/auth_provider.dart';
import 'package:lettutor/providers/setting_provider.dart';
import 'package:lettutor/router/app_routes.dart';
import 'package:lettutor/utilities/validator.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late Color myColor;
  late Size mediaSize;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool rememberUser = false;

  bool loading = true;
  bool isLoading = false;
  bool _isLocaleVietnamese = true;

  @override
  void initState() {
    super.initState();
    // _checkUserLoginStatus();
  }

  // void _checkUserLoginStatus() async {
  //   final authProvider = Provider.of<AuthProvider>(context, listen: false);
  //   if (authProvider.currentUser != null) {
  //     Navigator.pushReplacementNamed(context, AppRoutes.listTeacher);
  //   }
  // }

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
          Padding(padding: const EdgeInsets.all(24.0), child: _buidForm()),
        ],
      ),
    );
  }

  Widget _buidForm() {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUnfocus,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: myColor,
              fontSize: 32,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.descriptionTitle,
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
          const SizedBox(height: 16),
          _buildGreyText(AppLocalizations.of(context)!.password.toUpperCase()),
          const SizedBox(height: 8),
          _buildInputField(
            passwordController,
            AppLocalizations.of(context)!.hintPassword,
            isPassword: true,
            validator: Validator.validatePassword,
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () {
              // TODO: Tạo màn hình ForgotPasswordPage và thêm vào routes.
              Navigator.pushNamed(context, AppRoutes.forgotPassword);
            },
            child: _buildPrimaryColorText(
              AppLocalizations.of(context)!.forgotPassword,
            ),
          ),
          const SizedBox(height: 12),
          _buildLoginButton(),
          const SizedBox(height: 24),
          _buildOtherLogin(),
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
    bool isPassword = false,
    Function? validator,
  }) {
    bool isObscured = isPassword; // Trạng thái hiển thị mật khẩu

    return StatefulBuilder(
      builder: (context, setState) {
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
            suffixIcon:
                isPassword
                    ? IconButton(
                      icon: Icon(
                        isObscured ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          isObscured = !isObscured;
                        });
                      },
                    )
                    : null,
          ),
          obscureText: isObscured, // Sử dụng trạng thái hiện/ẩn mật khẩu
        );
      },
    );
  }

  Widget _buildLoginButton() {
    return ElevatedButton(
      onPressed:
          isLoading
              ? null // disable button while loading
              : () async {
                if (_formKey.currentState?.validate() ?? false) {
                  var authProvider = Provider.of<AuthProvider>(
                    context,
                    listen: false,
                  );
                  handleLoginByAccount(authProvider);
                }
              },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        backgroundColor: const Color.fromRGBO(4, 104, 211, 1.0),
        minimumSize: const Size.fromHeight(52),
      ),
      child:
          isLoading
              ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
              : Text(
                AppLocalizations.of(context)!.login.toUpperCase(),
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
    );
  }

  void handleLoginByAccount(AuthProvider authProvider) async {
    LoadingOverlay.of(context).show();
    try {
      String email = emailController.text;
      String password = passwordController.text;

      bool result = await authProvider.signInWithEmailAndPassword(
        email,
        password,
      );

      if (result) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Login successful")));
        Navigator.pushNamed(context, AppRoutes.bottomNavBar);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Login failed. Please check your credentials."),
          ),
        );
      }
    } catch (e) {
      print("Error during login: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("An error occurred: $e")));
    } finally {
      LoadingOverlay.of(context).hide();
    }
  }

  Widget _buildOtherLogin() {
    var authProvider = Provider.of<AuthProvider>(context, listen: false);
    return Center(
      child: Column(
        children: [
          _buildGreyText(AppLocalizations.of(context)!.orContinueWith),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  _handleLoginGoogle(context);
                },
                child: Tab(
                  icon: SvgPicture.asset("lib/assets/images/google-logo.svg"),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
              //TODO: Chưa có trang signUpPage
              Navigator.pushNamed(context, AppRoutes.signUp);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildGreyText(AppLocalizations.of(context)!.dontHaveAccount),
                Text(
                  AppLocalizations.of(context)!.signUp,
                  style: TextStyle(
                    color: myColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleLoginGoogle(BuildContext context) async {
    LoadingOverlay.of(context).show();
    try {
      var authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.loginWithGoogle(
        onSuccess: (user) {
          authProvider.saveLoginInfo(user);
          Navigator.pushReplacementNamed(context, AppRoutes.bottomNavBar);
        },
        onFail: (error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Hủy đăng nhập bằng tài khoản Google")),
          );
        },
      );
    } catch (e) {
      // Xử lý ngoại lệ nếu có
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Login failed: ${e.toString()}')));
    } finally {
      LoadingOverlay.of(context).hide();
    }
  }
}
