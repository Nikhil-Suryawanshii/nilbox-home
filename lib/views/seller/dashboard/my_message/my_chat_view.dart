import 'package:flutter/material.dart';
import 'package:ready_ecommerce/models/eCommerce/shop_message_model/user.dart';
import 'package:ready_ecommerce/views/seller/dashboard/my_message/layout/my_chat_layout.dart';

class SellerMyChatView extends StatelessWidget {
  final User user;
  const SellerMyChatView({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return SellerMyChatLayout(user: user);
  }
}
