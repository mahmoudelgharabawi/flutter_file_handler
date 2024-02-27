part of flutter_file_handler;

class Utilities {
  static Future<bool> confirmMessage(BuildContext context, String title,
      {String? message,
      String? imageAssert,
      Widget? icon,
      bool? isArabic}) async {
    var result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => Column(children: <Widget>[
        const Expanded(child: SizedBox()),
        Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          color: Colors.white,
          child: SizedBox(
              width: !kIsWeb ? 320.0 : 600,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      title,
                      style:
                          const TextStyle(fontSize: 25.0, color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20.0),
                    message != null
                        ? Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 30.0),
                            child: Text(message,
                                style: const TextStyle(
                                    fontSize: 18.0, color: Colors.black45),
                                textAlign: TextAlign.center,
                                softWrap: true,
                                maxLines: 4))
                        : const SizedBox(),
                    const SizedBox(height: 40.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ButtonTheme(
                            minWidth: 100.0,
                            height: 60.0,
                            child: MaterialButton(
                              color: Theme.of(context).primaryColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50.0)),
                              onPressed: () => Navigator.of(_).pop(true),
                              child: const Text('Yes',
                                  style: TextStyle(color: Colors.white)),
                            )),
                        const SizedBox(width: 15.0),
                        ButtonTheme(
                            minWidth: 100.0,
                            height: 60.0,
                            child: MaterialButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50.0)),
                              color: Colors.white,
                              onPressed: () => Navigator.of(_).pop(false),
                              child: const Text('No',
                                  style: TextStyle(color: Colors.red)),
                            ))
                      ],
                    ),
                    const SizedBox(height: 50.0),
                  ],
                ),
              )),
        ),
        const Expanded(child: SizedBox()),
      ]),
    );

    return result ?? false;
  }
}
