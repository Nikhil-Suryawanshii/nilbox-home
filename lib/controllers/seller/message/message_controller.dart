import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ready_ecommerce/controllers/seller/message/message_service.dart';
import 'package:ready_ecommerce/models/eCommerce/message_model/message_model.dart';
import 'package:ready_ecommerce/models/eCommerce/message_model/messages.dart' show Messages;
import 'package:ready_ecommerce/models/eCommerce/shop_message_model/shop_message_model.dart';
import 'package:ready_ecommerce/models/seller/common/common_model.dart';

import '../../../models/seller/dashboard/my_message.dart';



final storeMessageControllerProvider =
    StateNotifierProvider<StoreMessageController, bool>(
      (slref) => StoreMessageController(slref),
    );
final sendMessageControllerProvider =
    StateNotifierProvider<SendMessageController, bool>(
      (slref) => SendMessageController(slref),
    );

final getMessageControllerProvider = StateNotifierProvider.autoDispose<
  GetMessageController,
  AsyncValue<List<Messages>>
>((slref) => GetMessageController(slref));

final getCustomerControllerProvider = StateNotifierProvider.autoDispose<
  GetCustomerController,
  AsyncValue<ShopMessageModel?>
>((slref) => GetCustomerController(slref));

final getTotalUnreadMessagesControllerProvider =
    StateNotifierProvider.autoDispose<
      GetTotalUnreadMessagesController,
      AsyncValue<int?>
    >((slref) => GetTotalUnreadMessagesController(slref));

final sellerPostControllerProvider =
StateNotifierProvider<SellerPostController, AsyncValue<List<SellerPost>>>(
      (ref) => SellerPostController(ref),
);

class StoreMessageController extends StateNotifier<bool> {
  final Ref slref;
  StoreMessageController(this.slref) : super(false);

  Future<CommonResponseModel> storeMessage({
    required int shopId,
    required int userId,
    int? productId,
    String? type,
  }) async {
    try {
      state = true;
      final response = await slref
          .read(messageServiceProvider)
          .storeMessage(
            shopId: shopId,
            userId: userId,
            productId: productId,
            type: "user",
          );
      state = false;
      return CommonResponseModel(
        status: true,
        message: response.data['message'],
      );
    } catch (error) {
      debugPrint(error.toString());
      if (mounted) {
        state = false;
      }

      return CommonResponseModel(status: false, message: error.toString());
    }
  }
}

class SendMessageController extends StateNotifier<bool> {
  final Ref slref;
  SendMessageController(this.slref) : super(false);

  Future<CommonResponseModel> sendMessage({
    required int shopId,
    String? type,
    required String message,
  }) async {
    try {
      state = true;
      final response = await slref
          .read(messageServiceProvider)
          .sendMessage(userId: shopId, message: message, type: "shop");
      state = false;
      return CommonResponseModel(
        status: true,
        message: response.data['message'],
      );
    } catch (error) {
      debugPrint(error.toString());
      if (mounted) {
        state = false;
      }
      return CommonResponseModel(status: false, message: error.toString());
    }
  }

  Future<CommonResponseModel> getCustomer() async {
    try {
      state = true;
      final response = await slref.read(messageServiceProvider).getCustomer();
      state = false;
      return CommonResponseModel(
        status: true,
        message: response.data['message'],
      );
    } catch (error) {
      debugPrint(error.toString());
      state = false;
      return CommonResponseModel(status: false, message: error.toString());
    }
  }
}

class GetMessageController extends StateNotifier<AsyncValue<List<Messages>>> {
  final Ref slref;
  GetMessageController(this.slref) : super(const AsyncValue.data([]));

  int _currentpage = 1;
  final int _perPage = 20;
  bool _hasMore = true;
  bool _isFetching = false;

  Future<void> getMessage({required int userId, bool isInitial = false}) async {
    if (_isFetching || (!_hasMore && !isInitial)) return;

    try {
      if (isInitial) {
        state = const AsyncValue.loading();
        _currentpage = 1;
        _hasMore = true;
      }
      _isFetching = true;
      // state = const AsyncValue.loading();
      final response = await slref
          .read(messageServiceProvider)
          .getMessages(userId: userId, page: _currentpage, perPage: _perPage);

      final messageModel = MessageModel.fromMap(response.data);
      final newMessages = messageModel.data?.data ?? [];
      if (isInitial) {
        state = AsyncValue.data(newMessages);
      } else {
        state = AsyncValue.data([...state.value ?? [], ...newMessages]);
      }
      if (newMessages.length < _perPage) {
        _hasMore = false;
      } else {
        _currentpage++;
      }
    } catch (error, stk) {
      debugPrint(stk.toString());
      debugPrint(error.toString());
      state = AsyncValue.error(error.toString(), stk);
    } finally {
      _isFetching = false;
    }
  }

  Future<void> addNewMessage(Messages newMessage) async {
    final currentState = state.value ?? [];
    state = AsyncValue.data([newMessage, ...currentState]);
  }
}

class GetCustomerController
    extends StateNotifier<AsyncValue<ShopMessageModel?>> {
  final Ref slref;
  GetCustomerController(this.slref) : super(const AsyncValue.loading()) {
    getCustomer();
  }

  Future<void> getCustomer({String? search}) async {
    final previousData = state.valueOrNull;
    if (previousData != null) {
      state = AsyncValue.data(previousData);
    } else {
      state = const AsyncValue.loading();
    }
    try {
      final response = await slref
          .read(messageServiceProvider)
          .getCustomer(search: search);
      final data = response.data;
      final shopList = ShopMessageModel.fromMap(data);
      state = AsyncValue.data(shopList);
    } catch (error, stk) {
      debugPrint(stk.toString());
      debugPrint(error.toString());
      state = AsyncValue.error(error.toString(), stk);
    }
  }
}

class GetTotalUnreadMessagesController extends StateNotifier<AsyncValue<int?>> {
  final Ref slref;
  GetTotalUnreadMessagesController(this.slref)
    : super(const AsyncValue.loading()) {
    getTotalUnreadMessages();
  }

  Future<void> getTotalUnreadMessages() async {
    try {
      final response =
          await slref.read(messageServiceProvider).getTotalUnreadMessages();
      final data = response.data["data"];
      final totalUnreadMessages = data['unread_messages'] ?? 0;
      state = AsyncValue.data(totalUnreadMessages);
    } catch (error, stk) {
      debugPrint(stk.toString());
      debugPrint(error.toString());
    }
  }
}




class SellerPostController extends StateNotifier<AsyncValue<List<SellerPost>>> {
  final Ref ref;
  SellerPostController(this.ref) : super(const AsyncValue.loading()) {
    getPosts();
  }

  Future<void> getPosts() async {
    try {
      final res = await ref.read(messageServiceProvider).getSellerPosts();
      final posts = (res.data['posts']['data'] as List)
          .map((e) => SellerPost.fromMap(e))
          .toList();
      state = AsyncValue.data(posts);
    } catch (e, stk) {
      state = AsyncValue.error(e, stk);
    }
  }

  Future<void> deletePost(int shopPostId) async {
    try {
      await ref.read(messageServiceProvider).deleteSellerPost(shopPostId);

      final current = state.value ?? [];
      state = AsyncValue.data(
        current.where((e) => e.id != shopPostId).toList(),
      );
    } catch (e, stk) {
      debugPrint('Delete post failed: $e');
      state = AsyncValue.error(e, stk);
    }
  }


  Future<void> addPost({
    required String content,
    required List<String> images,
  }) async {
    try {
      final res = await ref.read(messageServiceProvider).createSellerPost(
        content: content,
        images: images,
      );

      final postData = res.data['post'];
      if (postData == null) return;

      final newPost = SellerPost.fromMap(postData);
      final current = state.value ?? [];

      state = AsyncValue.data([newPost, ...current]);
    } catch (e, stk) {
      debugPrint('Create post failed: $e');
      state = AsyncValue.error(e, stk);
    }
  }
}
