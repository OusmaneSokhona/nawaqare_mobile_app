import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import '../controllers/document_view_controller.dart';
import '../utils/app_colors.dart';
import '../utils/app_strings.dart';
import '../utils/app_fonts.dart';

class DocumentViewerScreen extends StatelessWidget {
  const DocumentViewerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final DocumentViewerController controller = Get.put(DocumentViewerController());

    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(
          controller.fileName,
          style: TextStyle(
            fontSize: 18.sp,
            fontFamily: AppFonts.jakartaMedium,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        )),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, size: 24.sp),
          onPressed: () => Get.back(),
        ),
        actions: [
          Obx(() => IconButton(
            icon: Icon(
              Icons.refresh,
              size: 24.sp,
              color: controller.canGoBack.value || controller.canGoForward.value
                  ? AppColors.primaryColor
                  : Colors.grey,
            ),
            onPressed: controller.reload,
            tooltip: 'Reload',
          )),
          IconButton(
            icon: Icon(Icons.open_in_new, size: 24.sp),
            onPressed: controller.launchExternalViewer,
            tooltip: 'Open in browser',
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.fileExtension == 'pdf') {
          return _buildLoadingState(controller);
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return _buildErrorState(controller);
        }

        return _buildDocumentViewer(controller);
      }),
      bottomNavigationBar: Obx(() {
        if (controller.fileExtension != 'pdf') return const SizedBox();

        return BottomAppBar(
          height: 60.h,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: controller.canGoBack.value
                      ? AppColors.primaryColor
                      : Colors.grey,
                ),
                onPressed: controller.canGoBack.value ? controller.goBack : null,
              ),
              Expanded(
                child: LinearProgressIndicator(
                  value: controller.progress.value / 100,
                  backgroundColor: Colors.grey.shade200,
                  color: AppColors.primaryColor,
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.arrow_forward,
                  color: controller.canGoForward.value
                      ? AppColors.primaryColor
                      : Colors.grey,
                ),
                onPressed: controller.canGoForward.value ? controller.goForward : null,
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildLoadingState(DocumentViewerController controller) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: AppColors.primaryColor,
          ),
          16.verticalSpace,
          Text(
            'Loading document...',
            style: TextStyle(
              fontSize: 16.sp,
              fontFamily: AppFonts.jakartaMedium,
              color: AppColors.darkGrey,
            ),
          ),
          if (controller.progress.value > 0) ...[
            8.verticalSpace,
            Text(
              '${controller.progress.value.toInt()}%',
              style: TextStyle(
                fontSize: 14.sp,
                fontFamily: AppFonts.jakartaRegular,
                color: AppColors.darkGrey,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildErrorState(DocumentViewerController controller) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64.sp,
              color: Colors.red,
            ),
            16.verticalSpace,
            Text(
              'Error Loading Document',
              style: TextStyle(
                fontSize: 20.sp,
                fontFamily: AppFonts.jakartaBold,
                color: Colors.red,
              ),
            ),
            12.verticalSpace,
            Text(
              controller.errorMessage.value,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.sp,
                fontFamily: AppFonts.jakartaRegular,
                color: AppColors.darkGrey,
              ),
            ),
            24.verticalSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: controller.reload,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 12.h,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Text(
                    'Retry',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontFamily: AppFonts.jakartaMedium,
                      color: Colors.white,
                    ),
                  ),
                ),
                16.horizontalSpace,
                OutlinedButton(
                  onPressed: controller.launchExternalViewer,
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 12.h,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    side: BorderSide(color: AppColors.primaryColor),
                  ),
                  child: Text(
                    'Open in Browser',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontFamily: AppFonts.jakartaMedium,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentViewer(DocumentViewerController controller) {
    if (controller.fileExtension == 'pdf') {
      return _buildPdfViewer(controller);
    } else if (['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp']
        .contains(controller.fileExtension)) {
      return _buildImageViewer(controller);
    } else {
      return _buildUnsupportedViewer(controller);
    }
  }

  Widget _buildPdfViewer(DocumentViewerController controller) {
    return InAppWebView(
      initialUrlRequest: URLRequest(url: WebUri(controller.documentUrl)),
      initialSettings: InAppWebViewSettings(
        javaScriptEnabled: true,
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
        allowsInlineMediaPlayback: true,
        preferredContentMode: UserPreferredContentMode.MOBILE,
      ),
      onWebViewCreated: (InAppWebViewController webViewController) {
        controller.setWebViewController(webViewController);
      },
      onLoadStart: (controller, url) {
        Get.find<DocumentViewerController>().isLoading.value = true;
      },
      onLoadStop: (controller, url) {
        Get.find<DocumentViewerController>().markAsLoaded();
      },
      onLoadError: (controller, url, code, message) {
        Get.find<DocumentViewerController>()
            .setError('Failed to load PDF: $message');
      },
      onProgressChanged: (controller, progress) {
        Get.find<DocumentViewerController>().progress.value = progress.toDouble();
        if (progress == 100) {
          Get.find<DocumentViewerController>().markAsLoaded();
        }
      },
      onUpdateVisitedHistory: (controller, url, androidIsReload) {
        // Enable/disable navigation buttons
        Get.find<DocumentViewerController>().update();
      },
    );
  }

  Widget _buildImageViewer(DocumentViewerController controller) {
    return InteractiveViewer(
      panEnabled: true,
      minScale: 0.5,
      maxScale: 4.0,
      child: Center(
        child: Image.network(
          controller.documentUrl,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes!
                    : null,
                color: AppColors.primaryColor,
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return _buildImageErrorState(controller);
          },
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildImageErrorState(DocumentViewerController controller) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.broken_image,
            size: 64.sp,
            color: Colors.grey,
          ),
          16.verticalSpace,
          Text(
            'Failed to load image',
            style: TextStyle(
              fontSize: 18.sp,
              fontFamily: AppFonts.jakartaMedium,
              color: AppColors.darkGrey,
            ),
          ),
          24.verticalSpace,
          ElevatedButton(
            onPressed: controller.launchExternalViewer,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: Text(
              'Open in Browser',
              style: TextStyle(
                fontSize: 16.sp,
                fontFamily: AppFonts.jakartaMedium,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUnsupportedViewer(DocumentViewerController controller) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.insert_drive_file,
              size: 80.sp,
              color: AppColors.primaryColor,
            ),
            20.verticalSpace,
            Text(
              controller.fileName,
              style: TextStyle(
                fontSize: 18.sp,
                fontFamily: AppFonts.jakartaMedium,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            8.verticalSpace,
            Text(
              'File type: .${controller.fileExtension}',
              style: TextStyle(
                fontSize: 16.sp,
                fontFamily: AppFonts.jakartaRegular,
                color: AppColors.darkGrey,
              ),
            ),
            16.verticalSpace,
            Text(
              'This file type cannot be viewed directly in the app.',
              style: TextStyle(
                fontSize: 16.sp,
                fontFamily: AppFonts.jakartaRegular,
                color: AppColors.darkGrey,
              ),
              textAlign: TextAlign.center,
            ),
            24.verticalSpace,
            ElevatedButton(
              onPressed: controller.launchExternalViewer,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Text(
                'Open in Browser',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontFamily: AppFonts.jakartaMedium,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}