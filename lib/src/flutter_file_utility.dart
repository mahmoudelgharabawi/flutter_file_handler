part of flutter_file_handler;

class FileViewUtilis {
  static Future<void> viewFile(
      UploadData data, BuildContext context, Color btnColor) async {
    if (data.name != null) {
      if (data.name!.contains('jpg') ||
          data.name!.contains('png') ||
          data.name!.contains('jpeg')) {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => FileViewWidget(
                data: data,
                isImage: true,
              ),
            ));
      } else if (data.name!.contains('pdf')) {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => FileViewWidget(
                data: data,
              ),
            ));
      } else {
        if (data.url != null) {
          if (data.url!.startsWith('https')) {
            if (await canLaunchUrl(Uri.parse(data.url!))) {
              await launchUrl(Uri.parse(data.url!));
            }
          }
        }
      }
    } else {
      if (data.url != null) {
        if (data.url!.startsWith('https')) {
          if (await canLaunchUrl(Uri.parse(data.url!))) {
            await launchUrl(Uri.parse(data.url!));
          }
        }
      }
    }
  }
}
