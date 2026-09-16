import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:ready_ecommerce/config/app_constants.dart';
import 'package:ready_ecommerce/services/base/eCommerce/message_provider_base.dart';
import 'package:ready_ecommerce/utils/api_client.dart';

import '../../../controllers/eCommerce/message/message_controller.dart';
import '../../../models/eCommerce/message_model/message_model.dart';

final messageServiceProvider = Provider((ref) => MessageService(ref));

final followingShopsControllerProvider =
StateNotifierProvider.autoDispose<
    FollowingShopsController,
    AsyncValue<List<FollowingShop>>>(
      (ref) => FollowingShopsController(ref),
);


class MessageService implements MessageProviderBase {
  final Ref ref;
  MessageService(this.ref);

  @override
  Future<Response> getShops({String? search}) async {
    final response = await ref
        .read(apiClientProvider)
        .get(AppConstants.getShopsList, query: {'search': search});
    return response;
  }
  Future<Response> getFollowingShops({
    required int page,
    required int perPage,
  }) async {
    return await ref.read(apiClientProvider)
        .get(AppConstants.getFollowingShops,
      query: {
        'page': page,
        'per_page': perPage,
      },
    );
  }

  @override
  Future<Response> getMessages(
      {required int shopId, required int page, required int perPage}) {
    final response =
    ref.read(apiClientProvider).get(AppConstants.getMessage, query: {
      'shop_id': shopId,
      'page': page,
      'per_page': perPage,
    });
    return response;
  }


  Future<Response> deleteChat(
      {required int shopId}) {
    final response =
        ref.read(apiClientProvider).post(AppConstants.deleteChat, data: {
      'shop_id': shopId,
    });
    return response;
  }

  Future<Response> blockSeller(
      {required int shopId}) {
    final response =
        ref.read(apiClientProvider).post(AppConstants.blockSeller, data: {
      'shop_id': shopId,
    });
    return response;
  }

  Future<Response> unblockSeller(
      {required int shopId}) {
    final response =
        ref.read(apiClientProvider).post(AppConstants.unblockSeller, data: {
      'shop_id': shopId,
    });
    return response;
  }

  @override
  Future<Response> sendMessage(
      {required int shopId, required String type, required String message}) {
    final response =
        ref.read(apiClientProvider).post(AppConstants.sendMessage, data: {
      'shop_id': shopId,
      'type': type,
      'message': message,
    });

    return response;
  }

  @override
  Future<Response> storeMessage(
      {required int shopId,
      required int userId,
      int? productId,
      required String type}) {
    final response = ref.read(apiClientProvider).post(
      AppConstants.storeMessage,
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
  Future<Response> getTotalUn(
      {required int shopId, required int page, required int perPage}) {
    final response =
        ref.read(apiClientProvider).get(AppConstants.getMessage, query: {
      'shop_id': shopId,
      'page': page,
      'per_page': perPage,
    });
    return response;
  }

  @override
  Future<Response> getTotalUnreadMessages() {
    Map<dynamic, dynamic>? userInfo =
        Hive.box(AppConstants.userBox).get(AppConstants.userData);
    final userId = userInfo?['id'];
    debugPrint("User ID: $userId");

    final response =
        ref.read(apiClientProvider).get(AppConstants.unreadMessage, query: {
      'user_id': userId,
    });
    return response;
  }
}
