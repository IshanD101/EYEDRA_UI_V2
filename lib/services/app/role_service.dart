import '../api/auth_service.dart';

class RoleService {
  final AuthService _authService = AuthService();

  // Check if user has specific role
  Future<bool> hasRole(String role) async {
    final userRole = await _authService.getUserRole();
    return userRole == role;
  }

  // Check if user can moderate content (Admins and Listeners)
  Future<bool> canModerate() async {
    final userRole = await _authService.getUserRole();
    return userRole == "Admin" || userRole == "Listener";
  }

  // Check if user is admin
  Future<bool> isAdmin() async {
    final userRole = await _authService.getUserRole();
    return userRole == "Admin";
  }

  // Check if user can create groups
  Future<bool> canCreateGroups() async {
    return await canModerate();
  }

  // Check if user can delete groups
  Future<bool> canDeleteGroups() async {
    return await canModerate();
  }

  // Get current user role
  Future<String> getCurrentRole() async {
    return await _authService.getUserRole();
  }
}

// A utility class to handle UI permissions
class UIPermissions {
  final bool canModerate;
  final bool canCreateGroups;
  final bool canDeleteGroups;
  final bool isAdmin;

  UIPermissions({
    required this.canModerate,
    required this.canCreateGroups,
    required this.canDeleteGroups,
    required this.isAdmin,
  });

  // Factory method to create UIPermissions from user role
  static Future<UIPermissions> fromRole() async {
    final roleService = RoleService();

    return UIPermissions(
      canModerate: await roleService.canModerate(),
      canCreateGroups: await roleService.canCreateGroups(),
      canDeleteGroups: await roleService.canDeleteGroups(),
      isAdmin: await roleService.isAdmin(),
    );
  }
}