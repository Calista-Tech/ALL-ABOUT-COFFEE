import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../core/app_colors.dart';

class XenditWebViewScreen extends StatefulWidget {
  final String invoiceUrl;
  const XenditWebViewScreen({super.key, required this.invoiceUrl});

  @override
  State<XenditWebViewScreen> createState() => _XenditWebViewScreenState();
}

class _XenditWebViewScreenState extends State<XenditWebViewScreen> {
  WebViewController? _controller;
  bool _loading = true;

  // webview_flutter only works on Android and iOS
  bool get _supported =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  @override
  void initState() {
    super.initState();
    if (_supported) {
      _controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(NavigationDelegate(
          onPageFinished: (_) {
            if (mounted) setState(() => _loading = false);
          },
        ))
        ..loadRequest(Uri.parse(widget.invoiceUrl));
    }
  }

  Future<void> _openExternal() async {
    await launchUrl(
      Uri.parse(widget.invoiceUrl),
      mode: LaunchMode.externalApplication,
      webOnlyWindowName: '_blank',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.header,
        title: const Text('Secure Payment'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Done',
                style: TextStyle(
                    color: AppColors.darkBrown,
                    fontWeight: FontWeight.w800,
                    fontSize: 16)),
          ),
        ],
      ),
      body: _supported
          ? Stack(
              children: [
                WebViewWidget(controller: _controller!),
                if (_loading) const Center(child: CircularProgressIndicator()),
              ],
            )
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.open_in_new,
                        size: 60, color: AppColors.brown),
                    const SizedBox(height: 14),
                    const Text(
                      'Buksan ang payment page, mag-GCash/Maya test, '
                      'tapos bumalik dito at pindutin ang "Done".',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _openExternal,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.orange,
                          foregroundColor: Colors.white),
                      child: const Text('Open payment page'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}