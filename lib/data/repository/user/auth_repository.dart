import 'package:cloud_firestore/cloud_firestore.dart';
          import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
          import '../../model/user/user.dart';
          import '../../model/user/user_data.dart';

          class AuthRepository {
            final firebase_auth.FirebaseAuth _firebaseAuth = firebase_auth.FirebaseAuth.instance;
            final FirebaseFirestore _firestore = FirebaseFirestore.instance;

            Future<UserData> getUserDataByFirebaseId(String firebaseUid) async {
              // Get the user document from Firestore
              final userDoc = await _firestore.collection('users').doc(firebaseUid).get();

              if (userDoc.exists) {
                final userData = userDoc.data() as Map<String, dynamic>;

                // Create the User object from the document data
                final user = User(
                  id: userDoc.id,
                  email: userData['email'],
                  firstName: userData['firstName'] ?? '',
                  lastName: userData['lastName'] ?? '',
                  phone: userData['phone'],
                  roles: userData['roles'] != null ? List<String>.from(userData['roles']) : [],
                  languages: userData['languages'],
                  birthday: userData['birthday'],
                  isActive: userData['isActive'] ?? true,
                );

                // Return user with tokens
                return UserData(
                  user: user,
                  tokens: Tokens(
                    access: TokenInfo(
                      token: userData['accessToken'] ?? '',
                      expires: userData['accessTokenExpires'] ?? '',
                    ),
                    refresh: TokenInfo(
                      token: userData['refreshToken'] ?? '',
                      expires: userData['refreshTokenExpires'] ?? '',
                    ),
                  ),
                );
              } else {
                throw Exception('User not found');
              }
            }

            Future<UserData> registerUser(String firebaseUid, String email, Map<String, dynamic> additionalData) async {
              // Create user document in Firestore
              await _firestore.collection('users').doc(firebaseUid).set({
                'email': email,
                'createdAt': FieldValue.serverTimestamp(),
                ...additionalData,
              });

              // Get the token
              final currentUser = _firebaseAuth.currentUser;
              final token = await currentUser?.getIdToken() ?? '';

              // Create user object
              final user = User(
                id: firebaseUid,
                email: email,
                firstName: additionalData['firstName'] ?? '',
                lastName: additionalData['lastName'] ?? '',
                phone: additionalData['phone'],
                roles: additionalData['roles'] != null ? List<String>.from(additionalData['roles']) : [],
                languages: additionalData['languages'],
                birthday: additionalData['birthday'],
                isActive: additionalData['isActive'] ?? true,
              );

              // Return user with tokens
              return UserData(
                user: user,
                tokens: Tokens(
                  access: TokenInfo(
                    token: token,
                    expires: '', // Add proper expiry time if available
                  ),
                  refresh: TokenInfo(
                    token: '', // Firebase handles token refresh automatically
                    expires: '',
                  ),
                ),
              );
            }

            Future<bool> forgotPassword(String email) async {
              try {
                await _firebaseAuth.sendPasswordResetEmail(email: email);
                return true;
              } catch (e) {
                print('Failed to send password reset email: $e');
                return false;
              }
            }

            Future<bool> changePassword(String currentPassword, String newPassword) async {
              try {
                final user = _firebaseAuth.currentUser;
                if (user == null) return false;

                // Re-authenticate the user before changing password
                final credential = firebase_auth.EmailAuthProvider.credential(
                  email: user.email!,
                  password: currentPassword
                );

                await user.reauthenticateWithCredential(credential);
                await user.updatePassword(newPassword);
                return true;
              } catch (e) {
                print('Failed to change password: $e');
                return false;
              }
            }
          }