import 'package:dio/dio.dart';

abstract class MessageProviderBase {
  Future<Response> storeMessage({
    required int shopId,
    required int userId,
    required int productId,
    required String type,
  });
  Future<Response> getMessages({
    required int userId,
    required int page,
    required int perPage,
  });
  Future<Response> sendMessage({
    required int userId,
    required String type,
    required String message,
  });
  Future<Response> getCustomer({required String search});
  Future<Response> getTotalUnreadMessages();
}
