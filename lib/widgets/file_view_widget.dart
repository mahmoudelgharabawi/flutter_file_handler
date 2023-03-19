part of flutter_file_handler;

class FileViewWidget extends StatefulWidget {
  final UploadData data;
  final bool isImage;
  final Color? btnColor;
  const FileViewWidget(
      {Key? key,
      this.isImage = false,
      required this.data,
      this.btnColor = Colors.blue})
      : super(key: key);

  @override
  State<FileViewWidget> createState() => _FileViewWidgetState();
}

class _FileViewWidgetState extends State<FileViewWidget> {
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
                      var result = await Utilities.confirmMessage(
                          context, 'Download File ?');
                      if (result) {
                        if (widget.data.url!.startsWith('https')) {
                          if (await canLaunchUrl(Uri.parse(widget.data.url!))) {
                            await launchUrl(Uri.parse(widget.data.url!));
                          }
                        }
                      }
                    },
                    child: const Icon(Icons.download),
                    style: ElevatedButton.styleFrom(
                      primary: widget.btnColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    )),
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
