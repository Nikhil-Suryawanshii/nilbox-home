class ReturnOrdersResponse {
  final int total;
  final List<ReturnOrder> returnOrders;

  ReturnOrdersResponse({required this.total, required this.returnOrders});

  factory ReturnOrdersResponse.fromJson(Map<String, dynamic> json) {
    return ReturnOrdersResponse(
      total: json['data']['total'],
      returnOrders: (json['data']['returnOrders'] as List)
          .map((e) => ReturnOrder.fromJson(e))
          .toList(),
    );
  }
}

class ReturnOrder {
  final int id;
  final String orderId;
  final String reason;
  final double amount;
  final String status;
  final int quantity;
  final String paymentStatus;
  final String? rejectNote;
  final String returnDate;
  final String returnAddress;

  ReturnOrder({
    required this.id,
    required this.orderId,
    required this.reason,
    required this.amount,
    required this.status,
    required this.quantity,
    required this.paymentStatus,
    this.rejectNote,
    required this.returnDate,
    required this.returnAddress,
  });

  factory ReturnOrder.fromJson(Map<String, dynamic> json) {
    return ReturnOrder(
      id: json['id'],
      orderId: json['order_id'],
      reason: json['reason'],
      amount: (json['amount'] as num).toDouble(),
      status: json['status'],
      quantity: json['quantity'],
      paymentStatus: json['payment_status'],
      rejectNote: json['reject_note'],
      returnDate: json['return_date'],
      returnAddress: json['return_address'],
    );
  }
}