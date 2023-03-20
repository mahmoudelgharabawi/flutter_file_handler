part of flutter_file_handler;

class UploadData {
  String? url;
  String? name;

  UploadData({this.url, this.name});

  UploadData.fromJson(
    Map<String, dynamic> data,
  ) {
    url = data['url'];
    name = data['name'];
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'name': name,
    };
  }
}
