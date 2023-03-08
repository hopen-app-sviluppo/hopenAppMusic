import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import '../../helpers.dart';

class HtmlPage extends StatelessWidget {
  final String? htmlData;

  const HtmlPage({
    Key? key,
    required this.htmlData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Html(
        data: htmlData,
        onLinkTap: ((url, _, attributes, element) async {
          if (url != null) {
            try {
              await goToUrl(url);
            } catch (error) {
              showSnackBar(context, error.toString());
            }
          }
        }),
      );
}
