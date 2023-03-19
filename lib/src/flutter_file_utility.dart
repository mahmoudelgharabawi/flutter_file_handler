part of flutter_file_handler;

class FileViewUtils {
  static Future<void> viewFile(
      UploadData data, BuildContext context, Color btnColor) async {
    if (data.url != null) {
      if (data.url!.contains('jpg') ||
          data.url!.contains('png') ||
          data.url!.contains('jpeg')) {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => FileViewWidget(
                data: data,
                isImage: true,
                btnColor: btnColor,
              ),
            ));
      } else if (data.url!.contains('pdf')) {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => FileViewWidget(
                data: data,
                btnColor: btnColor,
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
