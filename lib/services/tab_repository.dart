import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:tlubook/services/sever_setting.dart';
import 'dart:async';
import '../models/model_book.dart';


class TabRepository {
  final _api = "${ServerSetting.getBaseUrl()}/api";
  Dio dio = Dio();



  Future<List<Book>> fetchBooks() async {
    try {
      Response response = await dio.get('$_api/book');
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((json) => Book.fromJson(json)).toList();
      } else {
        print('Error: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

  // Fetch Account Information
  Future<Map<String, dynamic>> fetchAccountInfo() async {
    try {
      final response = await dio.get('$_api/account-info');
      if (response.statusCode == 200) {
        return response.data; // Returns firstName, lastName, active
      } else {
        throw Exception('Failed to load account info');
      }
    } on DioError catch (e) {
      print('Error: ${e.response?.data}');
      throw Exception('Failed to fetch account info');
    }
  }

  // thay đổi mk
  Future<Map<String, dynamic>> changePassword(
      String email,
      String oldPassword,
      String newPassword,
      ) async {
    try {
      // Gửi yêu cầu POST đến API
      final response = await dio.post(
        '$_api/change-password',
        data: {
          "email": email,
          "oldPassword": oldPassword,
          "newPassword": newPassword,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            // Include other headers like authorization if needed
            // 'Authorization': 'Bearer YOUR_TOKEN',
          },
        ),
      );

      print('Response status code: ${response.statusCode}');
      print('Response data: ${response.data}');

      // Kiểm tra mã trạng thái trả về là 200
      if (response.statusCode == 200) {
        // Đảm bảo dữ liệu trả về đúng định dạng
        if (response.data is Map<String, dynamic>) {
          return response.data;
        } else {
          throw Exception('Response data format is invalid');
        }
      } else {
        throw Exception('Failed to change password');
      }
    } on DioError catch (e) {
      if (e.response != null) {
        print('Error response data: ${e.response?.data}');
        // Nếu response có dữ liệu là Map, lấy thông báo lỗi từ đó
        if (e.response?.data is Map<String, dynamic>) {
          throw Exception('Failed to change password: ${e.response?.data['error']}');
        } else {
          throw Exception('Failed to change password: Unexpected response format');
        }
      } else {
        // Nếu không có response, trả về thông báo lỗi chung
        throw Exception('Failed to change password: ${e.message}');
      }
    }
  }

  Future<Map<String, int>> fetchActiveUsersCount() async {
    try {
      final response = await dio.get('$_api/active-users-count');
      if (response.statusCode == 200) {
        if (response.data is Map<String, dynamic>) {
          // Trả về cả totalUsersCount và activeUsersCount
          return {
            'totalUsersCount': response.data['totalUsersCount'] ?? 0,
            'activeUsersCount': response.data['activeUsersCount'] ?? 0,
          };
        } else {
          throw Exception('Response data format is invalid');
        }
      } else {
        throw Exception('Failed to fetch active users count');
      }
    } on DioError catch (e) {
      if (e.response != null) {
        print('Error response data: ${e.response?.data}');
        if (e.response?.data is Map<String, dynamic>) {
          throw Exception('Failed to fetch active users count: ${e.response?.data['error']}');
        } else {
          throw Exception('Failed to fetch active users count: Unexpected response format');
        }
      } else {
        throw Exception('Failed to fetch active users count: ${e.message}');
      }
    }
  }
// Phương thức lấy danh sách giao dịch
  Future<List<Map<String, dynamic>>> fetchTransactionHistory() async {
    try {
      final response = await dio.get('$_api/transaction-history');

      if (response.statusCode == 200 && response.data is List) {
        List<dynamic> data = response.data;

        // Sắp xếp danh sách giao dịch theo thời gian từ mới nhất đến cũ nhất
        data.sort((a, b) {
          DateTime timeA = DateTime.parse(a['transaction_time']);
          DateTime timeB = DateTime.parse(b['transaction_time']);
          return timeB.compareTo(timeA); // Sắp xếp giảm dần (mới nhất trước)
        });

        // Lọc ra thông tin cần thiết: thời gian giao dịch và số tiền
        return data.map((transaction) {
          return {
            'transactionTime': transaction['timestamp'], // Ngày thanh toán
            'email': transaction['user_email'],                    // Số tiền
          };
        }).toList();
      } else {
        print('Error: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching transaction history: $e');
      return [];
    }
  }



  Future<void> updateAvatar(XFile image) async {
    try {
      // Use XFile directly (without converting to File)
      final response = await dio.post(
        '$_api/update-avatar',
        data: FormData.fromMap({
          'avatar': await MultipartFile.fromFile(image.path),
        }),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        // Handle success
        print("Avatar updated successfully!");
      } else {
        // Handle failure
        print("Failed to update avatar");
      }
    } catch (e) {
      print('Error updating avatar: $e');
    }
  }
  Future<String?> getAvatar() async {
    try {
      // Sending GET request to fetch avatar
      final response = await dio.get('$_api/avatar');

      if (response.statusCode == 200) {
        // Assuming the response contains the avatar URL in the 'avatarUrl' field
        return response.data['avatarUrl'];  // Replace 'avatarUrl' with the actual field name from your API response
      } else {
        print('Failed to fetch avatar: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching avatar: $e');
      return null;
    }
  }



  // Update Account Information
  Future<Map<String, dynamic>> updateAccountInfo(
      String firstName, String lastName, bool activeStatus) async {
    try {
      final response = await dio.put(
        '$_api/account-info',
        data: {
          "firstName": firstName,
          "lastName": lastName,
          "activeStatus": activeStatus,
        },
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        return response.data; // Returns the updated account info
      } else {
        throw Exception('Failed to update account info');
      }
    } on DioError catch (e) {
      print('Error: ${e.response?.data}');
      throw Exception('Failed to update account info');
    }
  }

  Future<Map<String, dynamic>> addBook(Book book) async {
    try {
      final response = await dio.post(
        '$_api/book',
        data: book.toJson(),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        return response.data; // Returns the added book data or confirmation
      } else {
        throw Exception('Failed to add book');
      }
    } on DioError catch (e) {
      if (e.response != null) {
        print('Error response data: ${e.response?.data}');
        if (e.response?.data is Map<String, dynamic>) {
          throw Exception('Failed to add book: ${e.response?.data['error']}');
        } else {
          throw Exception('Failed to add book: Unexpected response format');
        }
      } else {
        throw Exception('Failed to add book: ${e.message}');
      }
    }
  }


  Future<Map<String, dynamic>> signUp(String email, String password, String firstName, String lastName) async {
    try {
      final response = await dio.post(
        '$_api/signup',
        data: {
          "email": email,
          "password": password,
          "firstName": firstName,
          "lastName": lastName,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );
      print('Response status code: ${response.statusCode}');
      print('Response data: ${response.data}');
      if (response.statusCode == 200) {
        if (response.data is Map<String, dynamic>) {
          return response.data;
        } else {
          throw Exception('Response data format is invalid');
        }
      } else {
        throw Exception('Failed to sign up');
      }
    } on DioError catch (e) {
      if (e.response != null) {
        print('Error response data: ${e.response?.data}');
        if (e.response?.data is Map<String, dynamic>) {
          throw Exception('Failed to sign up: ${e.response?.data['error']}');
        } else {
          throw Exception('Failed to sign up: Unexpected response format');
        }
      } else {
        throw Exception('Failed to sign up: ${e.message}');
      }
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      final response = await dio.post(
        '$_api/reset-password',
        data: {
          "email": email,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      print('Response status code: ${response.statusCode}');
      print('Response data: ${response.data}');

      if (response.statusCode == 200) {
        print('Password reset email sent!');
      } else {
        throw Exception('Failed to send password reset email');
      }
    } on DioError catch (e) {
      if (e.response != null) {
        print('Error response data: ${e.response?.data}');
        if (e.response?.data is Map<String, dynamic>) {
          throw Exception('Failed to send password reset email: ${e.response?.data['error']}');
        } else {
          throw Exception('Failed to send password reset email: Unexpected response format');
        }
      } else {
        throw Exception('Failed to send password reset email: ${e.message}');
      }
    }
  }

  Future<Map<String, dynamic>> login( email,  password) async {
    try {
      final response = await dio.post(
        '$_api/signin',
        data: {
          "email": "$email",
          "password": "$password",
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      print('Response status code: ${response.statusCode}');
      print('Response data: ${response.data}');

      if (response.statusCode == 200) {
        // Ensure response.data is a Map<String, dynamic>
        if (response.data is Map<String, dynamic>) {
          return response.data;
        } else {
          throw Exception('Response data format is invalid');
        }
      } else {
        throw Exception('Failed to login');
      }
    } on DioError catch (e) {
      if (e.response != null) {
        print('Error response data: ${e.response?.data}');
        if (e.response?.data is Map<String, dynamic>) {
          throw Exception('Failed to login: ${e.response?.data['error']}');
        } else {
          throw Exception('Failed to login: Unexpected response format');
        }
      } else {
        throw Exception('Failed to login: ${e.message}');
      }
    }
  }

  Future<Map<String, dynamic>> toggleFavoriteBook(String bookId) async {
    try {
      final response = await dio.post(
        '$_api/favorite',
        data: {
          "bookId": bookId,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      print('Response status code: ${response.statusCode}');
      print('Response data: ${response.data}');

      if (response.statusCode == 200) {
        // Ensure response.data is a Map<String, dynamic>
        if (response.data is Map<String, dynamic>) {
          return response.data;
        } else {
          throw Exception('Response data format is invalid');
        }
      } else {
        throw Exception('Failed to toggle favorite');
      }
    } on DioError catch (e) {
      if (e.response != null) {
        print('Error response data: ${e.response?.data}');
        if (e.response?.data is Map<String, dynamic>) {
          throw Exception('Failed to toggle favorite: ${e.response?.data['error']}');
        } else {
          throw Exception('Failed to toggle favorite: Unexpected response format');
        }
      } else {
        throw Exception('Failed to toggle favorite: ${e.message}');
      }
    }
  }



  // Phương thức kiểm tra trạng thái yêu thích của sách
  Future<bool> checkFavoriteStatus(String bookId) async {
    try {
      final response = await dio.get(
        '$_api/favorite/status/$bookId',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      print('Response status code: ${response.statusCode}');
      print('Response data: ${response.data}');

      if (response.statusCode == 200) {
        if (response.data is Map<String, dynamic>) {
          return response.data['isFavorite'] ?? false;
        } else {
          throw Exception('Response data format is invalid');
        }
      } else {
        throw Exception('Failed to get favorite status');
      }
    } on DioError catch (e) {
      if (e.response != null) {
        print('Error response data: ${e.response?.data}');
        if (e.response?.data is Map<String, dynamic>) {
          throw Exception('Failed to get favorite status: ${e.response?.data['error']}');
        } else {
          throw Exception('Failed to get favorite status: Unexpected response format');
        }
      } else {
        throw Exception('Failed to get favorite status: ${e.message}');
      }
    }
  }

  // Phương thức tìm kiếm sách theo tên
  Future<List<Book>> searchBooksByName(String query) async {
    try {
      // Gửi yêu cầu GET tới API với tham số 'query'
      Response response = await dio.get('$_api/search', queryParameters: {
        'query': query,
      });

      // Kiểm tra mã trạng thái và kiểu dữ liệu trả về
      if (response.statusCode == 200 && response.data is List) {
        List<dynamic> data = response.data;
        // Chuyển đổi dữ liệu thành danh sách các đối tượng Book
        return data.map((json) => Book.fromJson(json)).toList();
      } else {
        print('Error: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

  Future<List<Book>> fetchFavoriteBooks() async {
    try {
      // Gửi yêu cầu GET tới API để lấy danh sách sách yêu thích
      Response response = await dio.get('$_api/favorites');

      // Kiểm tra mã trạng thái và kiểu dữ liệu trả về
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;

        // Chuyển đổi dữ liệu thành danh sách các đối tượng Book
        return data.map((json) => Book.fromJson(json)).toList();
      } else {
        print('Error: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }


}



