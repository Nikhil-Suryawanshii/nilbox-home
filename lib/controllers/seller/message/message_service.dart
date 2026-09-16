import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ready_ecommerce/config/app_constants.dart';
import 'package:ready_ecommerce/controllers/seller/message/message_provider_base.dart';
import 'package:ready_ecommerce/providers/seller/common_provider.dart';
import 'package:ready_ecommerce/utils/api_client.dart';

final messageServiceProvider = Provider((slref) => MessageService(slref));

class MessageService implements MessageProviderBase {
  final Ref slref;
  MessageService(this.slref);

  @override
  Future<Response> getCustomer({String? search}) async {
    final response = await slref
        .read(apiClientProvider)
        .get(AppConstants.sellerGetUserList, query: {'search': search});
    return response;
  }

  @override
  Future<Response> getMessages({
    required int userId,
    required int page,
    required int perPage,
  }) {
    final response = slref
        .read(apiClientProvider)
        .get(
          AppConstants.sellerGetMessage,
          query: {'user_id': userId, 'page': page, 'per_page': perPage},
        );
    return response;
  }

  @override
  Future<Response> sendMessage({
    required int userId,
    required String type,
    required String message,
  }) {
    final response = slref
        .read(apiClientProvider)
        .post(
          AppConstants.sellerSendMessage,
          data: {'user_id': userId, 'type': type, 'message': message},
        );
    return response;
  }

  @override
  Future<Response> storeMessage({
    required int shopId,
    required int userId,
    int? productId,
    required String type,
  }) {
    final response = slref
        .read(apiClientProvider)
        .post(
          AppConstants.sellerStoreMessage,
          data: {
            'shop_id': shopId,
            'user_id': userId,
            'product_id': productId,
            'type': type,
          },
        );
    return response;
  }

  @override
  Future<Response> getTotalUn({
    required int shopId,
    required int page,
    required int perPage,
  }) {
    final response = slref
        .read(apiClientProvider)
        .get(
          AppConstants.sellerGetMessage,
          query: {'shop_id': shopId, 'page': page, 'per_page': perPage},
        );
    return response;
  }

  @override
  Future<Response> getTotalUnreadMessages() async {
    // Map<dynamic, dynamic>? userInfo = Hive.box(
    //   AppConstants.sellerUserBox,
    // ).get(AppConstants.sellerData);
    // final userId = userInfo?['id'];

    final saveUser = await slref.read(sellerHiveServiceProvider).getUserInfo();
    debugPrint("User ID: ${saveUser?.shop?.id}");

    final response = slref
        .read(apiClientProvider)
        .get(
          AppConstants.sellerUnreadMessage,
          query: {'shop_id': saveUser?.shop?.id},
        );
    return response;
  }

  Future<Response> getSellerPosts({int perPage = 10}) {
    return slref.read(apiClientProvider)
        .get(AppConstants.sellerPosts,
      query: {'per_page': perPage},
    );
  }
  Future<Response> deleteSellerPost(int shopPostId) {
    return slref.read(apiClientProvider).delete(
      '${AppConstants.sellerPosts}/$shopPostId',
    );
  }


  Future<Response> createSellerPost({
    required String content,
    required List<String> images,
  }) async {
    final formData = FormData();

    /// CONTENT
    formData.fields.add(MapEntry('content', content));

    /// IMAGES ARRAY ✅
    for (final path in images) {
      formData.files.add(
        MapEntry(
          'images[]',
          await MultipartFile.fromFile(
            path,
            filename: path.split('/').last,
          ),
        ),
      );
    }
    // final formData = FormData.fromMap({
    //   'content': content,
    //   'images': images.map(
    //         (path) => MultipartFile.fromFileSync(path),
    //   ).toList(),
    // });

    return slref.read(apiClientProvider).post(
      AppConstants.sellerPosts,
      data: formData,
    );


  }





}
