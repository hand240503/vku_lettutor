import 'dart:io';

import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lettutor/data/model/user/user.dart';
import 'package:lettutor/l10n/app_localizations.dart';
import 'package:lettutor/pages/profilePage/components/birthday-select.dart';
import 'package:lettutor/pages/profilePage/components/text-area.dart';
import 'package:lettutor/providers/user_provider.dart';
import 'package:lettutor/router/app_routes.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../utilities/validator.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController studyScheduleController = TextEditingController();
  final countryController = TextEditingController();
  List<String> itemsCategory = [];
  List<String> selectedCategory = [];
  late DateTime selectedDate;
  late bool hasInitValue = false;
  XFile? _pickedFile;
  late bool _isLoading = false;

  Future<void> changeImage() async {
    // Show options for image source (camera or gallery)
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.camera),
                title: Text(AppLocalizations.of(context)!.capturePhoto),
                onTap: () async {
                  Navigator.pop(context);
                  _captureImage();
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text(AppLocalizations.of(context)!.selectFromGallery),
                onTap: () async {
                  Navigator.pop(context);
                  _pickImage();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _captureImage() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    setState(() {
      _pickedFile = image;
    });
    if (_pickedFile != null) {
      // Update the profile picture with the new image URL
      // You may need to upload the image to a server and get the new URL
      // For simplicity, I'm using the local file path as the URL
      String newImageUrl = _pickedFile!.path;
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    setState(() {
      _pickedFile = image;
    });

    if (_pickedFile != null) {
      // Update the profile picture with the new image URL
      // You may need to upload the image to a server and get the new URL
      // For simplicity, I'm using the local file path as the URL
      String newImageUrl = _pickedFile!.path;
    }
  }

  void initValues(User userData) {
    setState(() {
      firstNameController.text = userData.firstName ?? "";
      lastNameController.text = userData.lastName ?? "";
      emailController.text = userData.email ?? "";
      phoneController.text = userData.phone ?? "";
      countryController.text = userData.country ?? "";
      if (userData.birthday != null) {
        try {
          selectedDate = DateTime.parse(userData.birthday!);
        } catch (e) {
          selectedDate = DateTime.now();
        }
      } else {
        selectedDate = DateTime.now();
      }

      hasInitValue = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    if (hasInitValue == false) {
      initValues(authProvider.currentUser!);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.profile,
          textAlign: TextAlign.center,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            color: Colors.white,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(width: 1.0, color: Colors.grey.shade300),
              right: BorderSide(width: 1.0, color: Colors.grey.shade300),
            ),
          ),
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Container(
              child: ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  SizedBox(height: 40),
                  Center(
                    child: Stack(
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 4,
                              color: Theme.of(context).scaffoldBackgroundColor,
                            ),
                            boxShadow: [
                              BoxShadow(
                                spreadRadius: 2,
                                blurRadius: 10,
                                color: Colors.black.withOpacity(0.1),
                              ),
                            ],
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image:
                                  _pickedFile != null
                                      ? FileImage(File(_pickedFile!.path))
                                          as ImageProvider<Object>
                                      : NetworkImage(
                                        authProvider.currentUser?.avatar ??
                                            "https://randomuser.me/api/portraits/men/75.jpg",
                                      ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () {
                              changeImage();
                            },
                            child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  width: 4,
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                ),
                                color: Colors.blue.shade700,
                              ),
                              child: Icon(Icons.edit, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: Text(
                      "${authProvider.currentUser?.firstName ?? ""} ${authProvider.currentUser?.lastName ?? ""}"
                          .trim(),

                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: _buildInfo(
                      "Account ID: ",
                      authProvider.currentUser!.id! ?? "",
                    ),
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.forgotProfilePage,
                        );
                      },
                      child: Container(
                        child: Text(
                          AppLocalizations.of(context)!.changePassword,
                          style: TextStyle(fontSize: 14, color: Colors.blue),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                  Container(
                    color: Colors.grey.shade200,
                    padding: EdgeInsets.all(15),
                    child: Text(
                      AppLocalizations.of(context)!.account,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  _buildForm(authProvider.currentUser!),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForm(User userData) {
    return Container(
      margin: EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.always,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            _buildGreyText(AppLocalizations.of(context)!.firstName),
            const SizedBox(height: 8),
            _buildInputField(
              firstNameController,
              AppLocalizations.of(context)!.firstName,
              true,
              validator: Validator.validateName,
            ),

            _buildGreyText(AppLocalizations.of(context)!.lastName),
            const SizedBox(height: 8),
            _buildInputField(
              lastNameController,
              AppLocalizations.of(context)!.lastName,
              true,
              validator: Validator.validateName,
            ),
            const SizedBox(height: 16),
            _buildGreyText(AppLocalizations.of(context)!.email),
            const SizedBox(height: 8),
            _buildInputField(
              emailController,
              AppLocalizations.of(context)!.enterYourEmail,
              false,
              validator: Validator.validateEmail,
            ),
            const SizedBox(height: 16),
            _buildGreyText(AppLocalizations.of(context)!.country),
            const SizedBox(height: 8),
            TextFormField(
              readOnly: true,
              onTap: () {
                showCountryPicker(
                  context: context,
                  showPhoneCode: false,
                  onSelect: (Country country) {
                    countryController.text = country.name;
                  },
                );
              },
              controller: countryController,
              style: TextStyle(fontSize: 14),
              decoration: InputDecoration(
                disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey.shade400,
                  ), // Set the color for disabled state
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                ),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                ),
                hintText: AppLocalizations.of(context)!.country,
                hintStyle: TextStyle(color: Colors.grey.shade400),
                isDense: true, // Added this
                contentPadding: EdgeInsets.all(12),
              ),
            ),
            const SizedBox(height: 16),
            _buildGreyText(AppLocalizations.of(context)!.phoneNumber),
            const SizedBox(height: 8),
            _buildInputField(
              phoneController,
              AppLocalizations.of(context)!.enterYourPhoneNumber,
              true,
              validator: Validator.validatePhoneNumber,
            ),
            const SizedBox(height: 16),
            _buildGreyText(AppLocalizations.of(context)!.birthday),
            const SizedBox(height: 8),
            BirthdayProfileSelect(
              dateTimeData: selectedDate,
              onBirthDayChanged: (String newBirthDay) {
                setState(() {
                  selectedDate = DateTime.parse(newBirthDay);
                });
              },
            ),
            const SizedBox(height: 16),
            const SizedBox(height: 8),
            const SizedBox(height: 16),
            _buildGreyText(AppLocalizations.of(context)!.studySchedule),
            const SizedBox(height: 8),
            CustomTextArea(
              controller: studyScheduleController,
              hintText: AppLocalizations.of(context)!.noteTheTime,
            ),
            const SizedBox(height: 12),
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return ElevatedButton(
      onPressed: () async {
        setState(() {
          _isLoading = true;
        });

        await handleSaveProfile();

        setState(() {
          _isLoading = false;
        });
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          // border radius
          borderRadius: BorderRadius.circular(8),
        ),
        backgroundColor: const Color.fromRGBO(4, 104, 211, 1.0),
        minimumSize: const Size.fromHeight(46),
      ),
      child:
          !_isLoading
              ? Text(
                AppLocalizations.of(context)!.saveChanges,
                style: TextStyle(fontSize: 16),
              )
              : SizedBox(
                height: 20,
                width: 20,
                child: const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              ),
    );
  }

  Widget _buildInfo(String title, String content) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(top: 10),
      child: Wrap(
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Text(content, style: TextStyle(fontSize: 16, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildInputField(
    TextEditingController controller,
    String hintText,
    bool isEnable, {
    isPassword = false,
    Function? validator,
  }) {
    return TextFormField(
      validator: (value) {
        return validator!(value ?? "");
      },
      enabled: isEnable,
      readOnly: !isEnable,
      controller: controller,
      style: TextStyle(fontSize: 14),
      decoration: InputDecoration(
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey.shade400,
          ), // Set the color for disabled state
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey.shade400),
        isDense: true, // Added this
        contentPadding: EdgeInsets.all(12),
        suffixIcon: isPassword ? Icon(Icons.remove_red_eye) : null,
      ),
      obscureText: isPassword,
    );
  }

  Widget _buildGreyText(String text) {
    return Text(text, style: const TextStyle(color: Colors.grey));
  }

  Future<void> handleSaveProfile() async {
    if (_formKey.currentState!.validate()) {
      AuthProvider authProvider = Provider.of<AuthProvider>(
        context,
        listen: false,
      );
      UserProvider userProvider = Provider.of<UserProvider>(
        context,
        listen: false,
      );

      String firstName = firstNameController.text.trim();
      String lastName = lastNameController.text.trim();
      String email = emailController.text.trim();
      String phone = phoneController.text.trim();
      String country = countryController.text.trim();
      String birthday = selectedDate.toIso8601String();

      String avatarUrl = authProvider.currentUser!.avatar ?? "";

      if (_pickedFile != null) {
        await userProvider.updateUserAvatar(
          authProvider,
          File(_pickedFile!.path),
          (downloadUrl) {
            avatarUrl = downloadUrl;

            User updatedUser = authProvider.currentUser!.copyWith(
              firstName: firstName,
              lastName: lastName,
              email: email,
              phone: phone,
              country: country,
              birthday: birthday,
              avatar: avatarUrl,
            );

            authProvider.saveLoginInfo(updatedUser);

            userProvider.updateUserProfile(
              updatedUser,
              (updatedUser) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      AppLocalizations.of(context)!.profileUpdatedSuccessfully,
                    ),
                  ),
                );
                Navigator.pop(context);
              },
              (error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      AppLocalizations.of(context)!.errorUpdatingProfile,
                    ),
                  ),
                );
              },
            );
          },
          (error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Failed to upload avatar: $error")),
            );
          },
        );
      } else {
        // Nếu không có ảnh avatar mới, chỉ cập nhật thông tin người dùng mà không thay đổi avatar
        User updatedUser = authProvider.currentUser!.copyWith(
          firstName: firstName,
          lastName: lastName,
          email: email,
          phone: phone,
          country: country,
          birthday: birthday,
          avatar: avatarUrl, // Giữ nguyên avatar cũ
        );

        authProvider.saveLoginInfo(updatedUser);

        userProvider.updateUserProfile(
          updatedUser,
          (updatedUser) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  AppLocalizations.of(context)!.profileUpdatedSuccessfully,
                ),
              ),
            );
            Navigator.pop(context);
          },
          (error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  AppLocalizations.of(context)!.errorUpdatingProfile,
                ),
              ),
            );
          },
        );
      }
    }
  }
}
