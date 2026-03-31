import 'package:pler_to_pler_app/features/authentication/data/models/auth_model.dart';
import 'package:pler_to_pler_app/features/authentication/data/models/user_model.dart';
import 'package:pler_to_pler_app/services/network/api_client.dart';
import 'package:pler_to_pler_app/services/api_urls.dart';

/// Remote Data Source - Handles API calls
/// This is where the actual HTTP requests happen
abstract class AuthRemoteDataSource {
  Future<AuthModel> login({
    required String email,
    required String password,
    required String role,
  });

  Future<AuthModel> register({
    required String email,
    required String password,
    required String role,
  });

  Future<AuthModel> verifyOtp({
    required String email,
    required String otp,
  });

  Future<void> forgotPassword({required String email});

  Future<UserModel> getCurrentUser();

  Future<UserModel> updateProfile({
    String? name,
    String? phone,
    String? bio,
    String? profilePicture,
  });
}

/// Implementation of Remote Data Source
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  @override
  Future<AuthModel> login({
    required String email,
    required String password,
    required String role,
  }) async {
    final response = await ApiClient.postData(
      ApiUrls.login,
      {
        'email': email,
        'password': password,
        'role': role.toLowerCase(),
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return AuthModel.fromJson(response.body);
    } else {
      throw Exception(response.statusText ?? 'Login failed');
    }
  }

  @override
  Future<AuthModel> register({
    required String email,
    required String password,
    required String role,
  }) async {
    final response = await ApiClient.postData(
      ApiUrls.register,
      {
        'email': email,
        'password': password,
        'role': role.toLowerCase(),
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return AuthModel.fromJson(response.body);
    } else {
      throw Exception(response.statusText ?? 'Registration failed');
    }
  }

  @override
  Future<AuthModel> verifyOtp({
    required String email,
    required String otp,
  }) async {
    final response = await ApiClient.postData(
      ApiUrls.verifyOtp,
      {
        'email': email,
        'otp': otp,
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return AuthModel.fromJson(response.body);
    } else {
      throw Exception(response.statusText ?? 'OTP verification failed');
    }
  }

  @override
  Future<void> forgotPassword({required String email}) async {
    final response = await ApiClient.postData(
      ApiUrls.forgetPassword,
      {'email': email},
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(response.statusText ?? 'Forgot password failed');
    }
  }

  @override
  Future<UserModel> getCurrentUser() async {
    final response = await ApiClient.getData(ApiUrls.userMe);

    if (response.statusCode == 200) {
      // Adjust based on actual API response structure
      if (response.body is Map<String, dynamic>) {
        return UserModel.fromJson(response.body);
      } else {
        throw Exception('Invalid user data format');
      }
    } else {
      throw Exception(response.statusText ?? 'Failed to get user data');
    }
  }

  @override
  Future<UserModel> updateProfile({
    String? name,
    String? phone,
    String? bio,
    String? profilePicture,
  }) async {
    final body = <String, dynamic>{};
    if (name != null) body['name'] = name;
    if (phone != null) body['phone'] = phone;
    if (bio != null) body['bio'] = bio;
    if (profilePicture != null) body['profilePicture'] = profilePicture;

    final response = await ApiClient.postData(
      ApiUrls.updateProfile,
      body,
    );

    if (response.statusCode == 200 || response.statusCode == 201){
      return UserModel.fromJson(response.body);
    } else {
      throw Exception(response.statusText ?? 'Profile update failed');
    }
  }
}
