part of flutter_file_handler;

class FileViewWidget extends StatefulWidget {
  final UploadData data;
  final bool isImage;
  final bool isVideo;
  final Color? btnColor;
  final String accessToken;
  final bool shareFiles;
  final MimeTypeEx mimeType;

  const FileViewWidget(
      {Key? key,
      this.isImage = false,
      this.shareFiles = false,
      this.isVideo = false,
      required this.data,
      required this.mimeType,
      this.btnColor = Colors.blue,
      this.accessToken = ''})
      : super(key: key);

  @override
  State<FileViewWidget> createState() => _FileViewWidgetState();
}

class _FileViewWidgetState extends State<FileViewWidget> {
  // Future<String?> getDownloadPath() async {
  //   Directory? directory;
  //   try {
  //     if (!Platform.isAndroid) {
  //       directory = await getApplicationDocumentsDirectory();
  //     } else {
  //       directory = Directory('/storage/emulated/0/Download');
  //       // Put file in global download folder, if for an unknown reason it didn't exist, we fallback
  //       // ignore: avoid_slow_async_io
  //       if (!await directory.exists()) {
  //         directory = await getExternalStorageDirectory();
  //       }
  //     }
  //   } catch (err) {
  //     print("Cannot get download folder path");
  //   }
  //   return directory?.path;
  // }

  void getStoragePermission() async {
    try {
      PermissionStatus status = await Permission.storage.request();
      //PermissionStatus status1 = await Permission.accessMediaLocation.request();
      PermissionStatus status2 =
          await Permission.manageExternalStorage.request();
      print('status $status   -> $status2');
      if (status.isGranted && status2.isGranted) {
        print('Permission granted');
      } else if (status.isPermanentlyDenied || status2.isPermanentlyDenied) {
        await openAppSettings();
      } else if (status.isDenied) {
        print('Permission Denied');
      }
    } catch (e) {
      print('Exceptionnnnnnnnnnnnnnnnnnnnnn from file handler ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(5),
          child: Row(
            children: [
              SizedBox(
                height: 40,
                child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Icon(Icons.close),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.btnColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    )),
              ),
              Expanded(child: SizedBox()),
              SizedBox(
                height: 40,
                child: ElevatedButton(
                    onPressed: () async {
                      if (widget.shareFiles) {
                        await onShareFiles(widget.data.url!);
                      } else {
                        Share.share(
                          widget.data.url!,
                        );
                      }
                    },
                    child: Icon(Icons.share),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: widget.btnColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    )),
              ),
              const SizedBox(
                width: 10,
              ),
              SizedBox(
                height: 40,
                child: ElevatedButton(
                    onPressed: () async {
                      await onDownloadClicked();
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: widget.btnColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    child: const Icon(Icons.download)),
              ),
            ],
          ),
        ),
        widget.isVideo
            ? Expanded(
                child: VideoBoxWidget(
                url: widget.data.url ?? '',
              ))
            : widget.isImage
                ? Expanded(
                    child: CachedNetworkImage(
                      imageUrl: widget.data.url ?? '',
                      imageBuilder: (context, imageProvider) => PhotoView(
                        imageProvider: imageProvider,
                      ),
                      placeholder: (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  )
                : Expanded(child: SfPdfViewer.network(widget.data.url ?? '')),
      ],
    )));
  }

  Future<void> onShareFiles(String url) async {
    WidgetsFlutterBinding.ensureInitialized();
    if (kIsWeb) return;

    try {
      // Get the temporary directory
      final tempDir = await getTemporaryDirectory();
      final fileName = url.split('/').last; // Extract file name from URL
      final filePath = '${tempDir.path}/$fileName';

      // Download the file
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        // Share the file
        await Share.shareXFiles(
          [XFile(filePath)],
          text: 'Check out this file!',
        );
      } else {
        print('Failed to download file: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sharing file: $e');
    }
  }

  Future<void> onDownloadClicked() async {
    WidgetsFlutterBinding.ensureInitialized();

    try {
      if (kIsWeb) {
        await FileSaver.instance.saveFile(
            mimeType: MimeType.values
                .firstWhere((element) => element.name == widget.mimeType.name),
            link: LinkDetails(link: widget.data.url!),
            name:
                widget.data.name ?? '${DateTime.now().millisecondsSinceEpoch}');
      } else {
        await FileSaver.instance.saveAs(
          name: widget.data.name ?? '${DateTime.now().millisecondsSinceEpoch}',
          ext: widget.mimeType.name,
          mimeType: MimeType.values
              .firstWhere((element) => element.name == widget.mimeType.name),
          link: LinkDetails(link: widget.data.url!),
        );
      }
    } catch (e) {
      print('Exceptionnnnnnnnnnnnnnnnn${e}');
    }

    // try {
    //   String? appDocDirectory = await getDownloadPath();

    //   final downloaderUtils = DownloaderUtils(
    //     progressCallback: (current, total) {
    //       final progress = (current / total) * 100;
    //       debugPrint('Downloading: $progress');
    //     },
    //     file: File('$appDocDirectory/${widget.data.name}'),
    //     progress: ProgressImplementation(),
    //     onDone: () {
    //       debugPrint('Download done');
    //       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
    //         content: Text('Download '
    //             'Completed'),
    //         backgroundColor: Colors.green,
    //       ));
    //     },
    //     deleteOnCancel: true,
    //     accessToken: 'Bearer ${widget.accessToken}',
    //   );
    //   debugPrint('$appDocDirectory/${widget.data.name}');
    //   final core = await Flowder.download(widget.data.url!, downloaderUtils);
    // } catch (e, st) {
    //   debugPrint("$e");
    //   debugPrint("$st");
    // }
    // var result = await Utilities.confirmMessage(
    //     context, 'Download File ?');
    // if (result) {
    //   if (widget.data.url!.startsWith('https')) {
    //     if (await canLaunchUrl(Uri.parse(widget.data.url!))) {
    //       await launchUrl(Uri.parse(widget.data.url!));
    //     }
    //   }
    // }
  }
}
