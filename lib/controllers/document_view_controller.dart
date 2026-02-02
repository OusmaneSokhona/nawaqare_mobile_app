import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class DocumentViewerController extends GetxController {
  RxBool isLoading = true.obs;
  RxString errorMessage = ''.obs;
  RxBool isSupportedFormat = true.obs;
  RxDouble progress = 0.0.obs;
  RxBool canGoBack = false.obs;
  RxBool canGoForward = false.obs;
  Rx<InAppWebViewController?> webViewController = Rx<InAppWebViewController?>(null);

  String fileExtension = '';
  String documentUrl;
  RxString fileName;

  DocumentViewerController({
    required this.documentUrl,
    required this.fileName,
  });

  @override
  void onInit() {
    super.onInit();

    if (documentUrl.isNotEmpty) {
      final parts = documentUrl.split('.');
      fileExtension = parts.isNotEmpty ? parts.last.toLowerCase() : '';
    } else {
      fileExtension = '';
      errorMessage.value = 'No document provided';
      isLoading.value = false;
      return;
    }

    checkFileFormat();
  }

  void checkFileFormat() {
    if (fileExtension.isEmpty) {
      isSupportedFormat.value = false;
      isLoading.value = false;
      return;
    }

    final supportedFormats = [
      'pdf',
      'jpg',
      'jpeg',
      'png',
      'gif',
      'bmp',
      'webp',
      'txt',
      'doc',
      'docx',
      'xls',
      'xlsx',
      'ppt',
      'pptx'
    ];
    isSupportedFormat.value = supportedFormats.contains(fileExtension);

    if (!['pdf'].contains(fileExtension)) {
      isLoading.value = false;
    }
  }

  Future<void> launchExternalViewer() async {
    try {
      final uri = Uri.parse(documentUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        errorMessage.value = 'Cannot open this file. Please try another app.';
      }
    } catch (e) {
      errorMessage.value = 'Error opening file: $e';
    }
  }

  void markAsLoaded() {
    isLoading.value = false;
    progress.value = 100.0;
    update();
  }

  void setError(String error) {
    errorMessage.value = error;
    isLoading.value = false;
    update();
  }

  void setWebViewController(InAppWebViewController controller) {
    webViewController.value = controller;
    _updateNavigationButtons();
  }

  Future<void> reload() async {
    if (webViewController.value != null) {
      await webViewController.value!.reload();
      isLoading.value = true;
      errorMessage.value = '';
      update();
    }
  }

  Future<void> goBack() async {
    if (webViewController.value != null) {
      await webViewController.value!.goBack();
      _updateNavigationButtons();
    }
  }

  Future<void> goForward() async {
    if (webViewController.value != null) {
      await webViewController.value!.goForward();
      _updateNavigationButtons();
    }
  }

  Future<void> _updateNavigationButtons() async {
    if (webViewController.value != null) {
      final backResult = await webViewController.value!.canGoBack();
      final forwardResult = await webViewController.value!.canGoForward();

      canGoBack.value = backResult;
      canGoForward.value = forwardResult;
    }
  }

  void onUpdateVisitedHistory() {
    _updateNavigationButtons();
  }
}