import 'package:jwt_decoder/jwt_decoder.dart';
import './auth_servcie.dart';

class RoleManager {
  final AuthService _authService = AuthService();

  Future<String> getUserRole() async {
    String? token = await _authService.getToken();
    if (token != null) {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      return decodedToken['role']; // Ensure your backend sends 'role' in the token
    }
    return 'guest';
  }
}
