import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'package:ready_ecommerce/controllers/seller/message/message_controller.dart';
import 'package:ready_ecommerce/models/eCommerce/message_model/messages.dart';
import 'package:ready_ecommerce/providers/seller/common_provider.dart';
import 'package:ready_ecommerce/services/eCommerce/pusher/pusher_service.dart';

final pusherControllerProvider = StateNotifierProvider<PusherController, void>((
  slref,
) {
  return PusherController(slref);
});

class PusherController extends StateNotifier<void> {
  final Ref slref;
  final PusherService _pusherService = PusherService();

  PusherController(this.slref) : super(null);

  /// Initialize Pusher and connect
  Future<void> init() async {
    await _pusherService.init(
      onEvent: _handleEvent,
      onConnectionChange: _handleConnectionChange,
      onError: _handleError,
    );

    // Subscribe to authenticated user's channel
    final loginShopUser = await slref.read(sellerHiveServiceProvider).getUserInfo();
    if (loginShopUser?.shop?.id != null) {
      subscribeToUser(loginShopUser?.shop?.id ?? 0);
    }
  }

  /// Subscribe to user's personal channel
  void subscribeToUser(int userId) {
    final channel = "chat_shop_$userId";
    debugPrint("Subscribing to channel: $channel");
    _pusherService.subscribe(channel);
  }

  /// Handle incoming events
  void _handleEvent(PusherEvent event) {
    debugPrint("Event: ${event.eventName}");
    debugPrint("Data: ${event.data}");

    try {
      if (event.data.isEmpty) {
        debugPrint("No data received");
        return;
      }
      final decoded = jsonDecode(event.data);
      final message = Messages.fromMap(decoded["message"]);
      debugPrint("Parsed message: ${message.toMap()}");

      slref.read(getMessageControllerProvider.notifier).addNewMessage(message);
      slref.read(getCustomerControllerProvider.notifier).getCustomer();
      slref.read(getTotalUnreadMessagesControllerProvider);
    } catch (e, stk) {
      debugPrint("Error parsing message: $e | $stk");
      return;
    }
  }

  /// Connection change
  void _handleConnectionChange(String? current, String? previous) {
    debugPrint("🔌 Pusher state: $previous → $current");
  }

  /// Error
  void _handleError(String? message, int? code, dynamic error) {
    debugPrint("Pusher error: $message | code: $code");
  }
}
