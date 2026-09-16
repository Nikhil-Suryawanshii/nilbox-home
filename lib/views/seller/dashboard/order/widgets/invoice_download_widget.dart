import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ready_ecommerce/config/app_color.dart';
import 'package:ready_ecommerce/config/app_text_style.dart';
import 'package:ready_ecommerce/generated/l10n.dart';
import 'package:ready_ecommerce/utils/global_function.dart';

class InvoiceDownload extends ConsumerStatefulWidget {
  final String orderCode;
  final String invoiceUrl;
  const InvoiceDownload(this.orderCode, this.invoiceUrl, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _InvoiceDownloadState();
}

class _InvoiceDownloadState extends ConsumerState<InvoiceDownload> {
  static final isFileExists = StateProvider<bool>((slref) => false);
  static final isloading = StateProvider<bool>((slref) => false);
  final ReceivePort _port = ReceivePort();

  @override
  void initState() {
    super.initState();
    _init();
    _portListener();
    FlutterDownloader.registerCallback(downloadCallback);
  }

  Future<void> _init() async {
    final file = await _checkFileExists();
    ref.read(isFileExists.notifier).state = file != null;
  }

  _portListener() {
    IsolateNameServer.registerPortWithName(
      _port.sendPort,
      'downloader_send_port',
    );
    _port.listen((dynamic data) {
      int status = data[1];
      int process = data[2];
      if (status == DownloadTaskStatus.complete.index) {
        ref.read(isFileExists.notifier).state = true;
      } else if (status == DownloadTaskStatus.failed.index) {
        GlobalFunction.showCustomSnackbar(
          message: 'Something went wrong!',
          isSuccess: false,
        );
      }
      if (process == 100) {
        ref.read(isloading.notifier).state = false;
      }
    });
  }

  Future<String?> _checkFileExists() async {
    final saveDir = await _getDownloadDirectory();
    final fileName = 'invoice-${widget.orderCode}.pdf';
    final filePath = '$saveDir/$fileName';
    final file = File(filePath);

    return await file.exists() ? filePath : null;
  }

  Future<String?> _getDownloadDirectory() async {
    Directory? appDocDir;

    if (Platform.isAndroid) {
      appDocDir = Directory('/storage/emulated/0/Download');
      if (!await appDocDir.exists()) {
        appDocDir = await getExternalStorageDirectory();
      }
    } else if (Platform.isIOS) {
      appDocDir = await getApplicationDocumentsDirectory();
    } else {
      throw UnsupportedError('Unsupported platform');
    }
    return appDocDir?.path;
  }

  Future<void> _requestPermission() async {
    if (Platform.isAndroid) {
      await Permission.storage.request();
    }
  }

  Future<void> _downloadFile() async {
    await _requestPermission();
    final url = widget.invoiceUrl;
    final saveDir = await _getDownloadDirectory();
    final fileName = 'invoice-${widget.orderCode}.pdf';
    final filePath = await _checkFileExists();

    if (filePath == null) {
      ref.read(isloading.notifier).state = true;
      FlutterDownloader.enqueue(
        url: url,
        savedDir: saveDir!,
        fileName: fileName,
        showNotification: true,
        openFileFromNotification: true,
      );
    } else {
      OpenFile.open(filePath);
    }
  }

  @override
  void dispose() {
    super.dispose();
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(isloading)
        ? const CircularProgressIndicator()
        : GestureDetector(
          onTap: () => _downloadFile(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                  Icons.cloud_download_outlined, // Standard Flutter Icon
                  color: EcommerceAppColor.primary,
                  size: 20.sp,
                ),
                Gap(8.w),
                Text(
                  ref.watch(isFileExists)
                      ? 'Open Invoice'
                      : S.of(context).downloadInvoice,
                  // Using bodyText from your AppTextStyle class
                  style: AppTextStyle(context).bodyText, 
                ),
            ],
          ),
        );
  }

  @pragma("vm:entry-point")
  static void downloadCallback(String id, int status, int progress) {
    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port')!;
    send.send([id, status, progress]);
  }
}
