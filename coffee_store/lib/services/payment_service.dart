import 'package:supabase_flutter/supabase_flutter.dart';

class InvoiceResult {
  final String invoiceUrl;
  final String externalId;
  InvoiceResult(this.invoiceUrl, this.externalId);
}

class PaymentService {
  static final SupabaseClient _db = Supabase.instance.client;

  /// Calls the `create-invoice` Edge Function (Xendit secret stays on the server).
  static Future<InvoiceResult> createInvoice({
    required String productName,
    required double amount,
    String? customerName,
    String? phone,
    String? address,
    String? orderType,
    List<Map<String, dynamic>>? items,
  }) async {
    final res = await _db.functions.invoke(
      'create-invoice',
      body: {
        'product_name': productName,
        'amount': amount,
        'customer_name': customerName,
        'phone': phone,
        'address': address,
        'order_type': orderType,
        'items': items,
      },
    );
    final data = res.data as Map<String, dynamic>;
    if (data['invoice_url'] == null) {
      throw Exception(data['error'] ?? 'Failed to create invoice');
    }
    return InvoiceResult(data['invoice_url'], data['external_id']);
  }

  static Future<String> getOrderStatus(String externalId) async {
    final row = await _db
        .from('orders')
        .select('status')
        .eq('external_id', externalId)
        .maybeSingle();
    return (row?['status'] as String?) ?? 'PENDING';
  }

  /// The webhook may arrive a second or two late, so we poll a few times.
  static Future<String> waitForStatus(String externalId,
      {int tries = 6}) async {
    String status = 'PENDING';
    for (var i = 0; i < tries; i++) {
      status = await getOrderStatus(externalId);
      if (status != 'PENDING') return status;
      await Future.delayed(const Duration(seconds: 1));
    }
    return status;
  }

  static Future<List<Map<String, dynamic>>> fetchOrders() async {
    final rows = await _db
        .from('orders')
        .select()
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(rows);
  }
}
