import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lettutor/data/model/user/user.dart';

class Tokens {
  final TokenInfo access;
  final TokenInfo refresh;

  Tokens({
    required this.access,
    required this.refresh,
  });

  factory Tokens.fromFirestore(Map<String, dynamic> data) {
    return Tokens(
      access: TokenInfo.fromFirestore(data['access']),
      refresh: TokenInfo.fromFirestore(data['refresh']),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'access': access.toFirestore(),
      'refresh': refresh.toFirestore(),
    };
  }
}

class TokenInfo {
  final String token;
  final String expires;

  TokenInfo({
    required this.token,
    required this.expires,
  });

  factory TokenInfo.fromFirestore(Map<String, dynamic> data) {
    return TokenInfo(
      token: data['token'],
      expires: data['expires'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'token': token,
      'expires': expires,
    };
  }
}

class UserData {
  User? user;
  Tokens? tokens;

  UserData({
    this.user,
    this.tokens,
  });

  factory UserData.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return UserData(
      user: data['user'] != null ? User.fromFirestore(data['user']) : null,
      tokens: data['tokens'] != null ? Tokens.fromFirestore(data['tokens']) : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'user': user?.toFirestore(),
      'tokens': tokens?.toFirestore(),
    };
  }
}