import 'package:jaguar_jwt/jaguar_jwt.dart';
import '../Helper/Constant.dart';

String getToken() {
  final claimSet = JwtClaim(
    issuer: issuerName,
    maxAge: const Duration(minutes: tokenExpireTime),
    issuedAt: DateTime.now().toUtc(),
  );
  String token = issueJwtHS256(claimSet, jwtKey);
  print('token****$token');
  return token;
}

var token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE2ODE5MzA4ODQsImlzcyI6ImVzaG9wIiwiZXhwIjoxNjgxOTMyNjg0fQ.uOCVRlxtttSPweDB7UWWZURdGAanrtf2GOG6T_5EDhU";

Map<String, String> get headers => {
      'Authorization': 'Bearer ${token}',
    };
