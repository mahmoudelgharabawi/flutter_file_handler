import 'package:flutter/material.dart';
import 'package:flutter_file_handler/flutter_file_handler.dart';
import 'package:flutter_file_handler/utilits/mime_types_ex.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
                onPressed: () {
                  UploadData data = UploadData(
                      url:
                          'https://ik.imagekit.io/wa00oveva//o/reels%2F202462921144434150-hd_1080_1920_30fps.mp4?alt=media&token=f2870ba2-9211-46e1-b115-4fa87df2405f',
                      name: 'test');
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => FileViewWidget(
                              mimeType: MimeTypeEx.avi,
                              isVideo: true,
                              data: data,
                              btnColor: Colors.red)));

                  // FileViewUtils.viewFile(data, context, Colors.red);
                },
                child: const Text('Download Image'))
          ],
        ),
      ),
    );
  }
}
