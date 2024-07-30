import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_box/video_box.dart';

class VideoBoxWidget extends StatefulWidget {
  final String url;
  const VideoBoxWidget({required this.url, super.key});

  @override
  State<VideoBoxWidget> createState() => _VideoBoxWidgetState();
}

class _VideoBoxWidgetState extends State<VideoBoxWidget> {
  VideoController? vc;

  @override
  void initState() {
    init();
    super.initState();
  }

  void init() async {
    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      var path =
          '${(await getTemporaryDirectory()).path}/${widget.url.split('files').last.replaceAll('/', '-')}.mp4';
      var file = File(path);
      if (!(await file.exists())) {
        var bytes =
            (await NetworkAssetBundle(Uri.parse(widget.url)).load(widget.url))
                .buffer
                .asUint8List();
        await file.writeAsBytes(bytes);
      }

      vc = VideoController(source: VideoPlayerController.file(file))
        ..addInitializeErrorListenner((e) {
          print('[video box init] error: ' + e.message);
        })
        ..initialize().then((e) {
          if (e != null) {
            print('[video box init] error: ' + e.message);
          } else {
            print('[video box init] success');
          }
        });
    } else {
      vc = VideoController(
          source: VideoPlayerController.networkUrl(Uri.parse(widget.url)))
        ..addInitializeErrorListenner((e) {
          print('[video box init] error: ' + e.message);
        })
        ..initialize().then((e) {
          if (e != null) {
            print('[video box init] error: ' + e.message);
          } else {
            print('[video box init] success');
          }
        });
    }
    setState(() {});
  }

  @override
  void dispose() {
    vc?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return vc == null
        ? Container(
            color: Colors.black,
            child: const Center(child: CircularProgressIndicator()),
          )
        : AspectRatio(
            aspectRatio: 16 / 9,
            child: VideoBox(controller: vc!),
          );
  }
}
