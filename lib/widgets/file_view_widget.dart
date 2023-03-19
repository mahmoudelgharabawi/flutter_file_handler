part of flutter_file_handler;

class FileViewWidget extends StatefulWidget {
  final UploadData data;
  final bool isImage;
  final Color? btnColor;
  final String accessToken;

  const FileViewWidget(
      {Key? key,
      this.isImage = false,
      required this.data,
      this.btnColor = Colors.blue,
      this.accessToken = ''})
      : super(key: key);

  @override
  State<FileViewWidget> createState() => _FileViewWidgetState();
}

class _FileViewWidgetState extends State<FileViewWidget> {
  Future<String?> getDownloadPath() async {
    Directory? directory;
    try {
      if (!Platform.isAndroid) {
        directory = await getApplicationDocumentsDirectory();
      } else {
        directory = Directory('/storage/emulated/0/Download');
        // Put file in global download folder, if for an unknown reason it didn't exist, we fallback
        // ignore: avoid_slow_async_io
        if (!await directory.exists())
          directory = await getExternalStorageDirectory();
      }
    } catch (err, stack) {
      print("Cannot get download folder path");
    }
    return directory?.path;
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
                              primary: widget.btnColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                            )),
                      ),
                      Expanded(child: SizedBox()),
                      SizedBox(
                        height: 40,
                        child: ElevatedButton(
                            onPressed: () => Share.share(
                              widget.data.url!,
                            ),
                            child: Icon(Icons.share),
                            style: ElevatedButton.styleFrom(
                              primary: widget.btnColor,
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
                              debugPrint('download button pressed');
                              WidgetsFlutterBinding.ensureInitialized();
                              try {
                        String? appDocDirectory = await getDownloadPath();

                        final downloaderUtils = DownloaderUtils(
                          progressCallback: (current, total) {
                            final progress = (current / total) * 100;
                            debugPrint('Downloading: $progress');
                          },
                          file: File('$appDocDirectory/${widget.data.name}'),
                          progress: ProgressImplementation(),
                          onDone: () {
                            debugPrint('Download done');
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text('Download '
                                  'Completed'),
                              backgroundColor: Colors.green,
                            ));
                          },
                          deleteOnCancel: true,
                          accessToken: 'Bearer ${widget.accessToken}',
                        );
                        debugPrint('$appDocDirectory/${widget.data.name}');
                        final core = await Flowder.download(
                            widget.data.url!, downloaderUtils);
                      } catch (e, st) {
                                debugPrint("$e");
                                debugPrint("$st");
                              }
                              // var result = await Utilities.confirmMessage(
                              //     context, 'Download File ?');
                              // if (result) {
                              //   if (widget.data.url!.startsWith('https')) {
                              //     if (await canLaunchUrl(Uri.parse(widget.data.url!))) {
                              //       await launchUrl(Uri.parse(widget.data.url!));
                              //     }
                              //   }
                              // }
                            },
                            style: ElevatedButton.styleFrom(
                              primary: widget.btnColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                            ),
                            child: const Icon(Icons.download)),
                      ),
                    ],
                  ),
                ),
                widget.isImage
                    ? Expanded(
                  child: CachedNetworkImage(
                    imageUrl: widget.data.url ?? '',
                    imageBuilder: (context, imageProvider) => PhotoView(
                      imageProvider: imageProvider,
                    ),
                    placeholder: (context, url) =>
                    const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                  ),
                )
                    : Expanded(child: SfPdfViewer.network(widget.data.url ?? '')),
              ],
            )));
  }
}
