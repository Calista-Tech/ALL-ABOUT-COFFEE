import 'package:flutter/material.dart';
import '../screens/xendit_webview_screen.dart';
import 'payment_service.dart';

/// create invoice -> Xendit WebView (GCash/Maya) -> verify PAID in Supabase.
/// Returns true only when the payment was verified.
Future<bool> startCheckout(
  BuildContext context, {
  required String productName,
  required double amount,
  String? customerName,
  String? phone,
  String? address,
  String? orderType,
  List<Map<String, dynamic>>? items,
}) async {
  if (amount <= 0) return false;
  final messenger = ScaffoldMessenger.of(context);
  final navigator = Navigator.of(context);

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => const Center(child: CircularProgressIndicator()),
  );

  InvoiceResult invoice;
  try {
    invoice = await PaymentService.createInvoice(
      productName: productName,
      amount: amount,
      customerName: customerName,
      phone: phone,
      address: address,
      orderType: orderType,
      items: items,
    );
  } catch (e) {
    navigator.pop(); // close loading
    messenger.showSnackBar(SnackBar(
      duration: const Duration(seconds: 6),
      content: Text('Checkout failed: $e'),
    ));
    return false;
  }
  navigator.pop(); // close loading

  await navigator.push(MaterialPageRoute(
    builder: (_) => XenditWebViewScreen(invoiceUrl: invoice.invoiceUrl),
  ));

  final status = await PaymentService.waitForStatus(invoice.externalId);
  if (status == 'PAID') {
    messenger.showSnackBar(const SnackBar(
      backgroundColor: Colors.green,
      content: Text('Payment Verified! Your order is PAID.'),
    ));
    return true;
  }
  messenger.showSnackBar(
      SnackBar(content: Text('Payment not completed (status: $status).')));
  return false;
}
