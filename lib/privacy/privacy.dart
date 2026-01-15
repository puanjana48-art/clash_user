import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class Privacy extends StatefulWidget {
  final String mdFilename;
  const Privacy({super.key, required this.mdFilename});

  @override
  State<Privacy> createState() => _PrivacyState();
}

class _PrivacyState extends State<Privacy> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Expanded(
              child: FutureBuilder(
                future: Future.delayed(const Duration(microseconds: 150))
                    .then((value) => rootBundle.loadString('lib/privacy/privacypolicy.md')),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Markdown(
                        styleSheet: MarkdownStyleSheet.fromTheme(ThemeData(
                            textTheme: const TextTheme(
                                bodyMedium: TextStyle(
                                    fontSize: 15.0, color: Colors.black)))),
                        data: snapshot.data.toString());
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              )),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  )),
              alignment: Alignment.center,
              height: 50,
              width: double.infinity,
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.black),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class Terms1 extends StatelessWidget {
  Terms1({super.key, this.radius = 8, required this.mdFilename})
      : assert(
  mdFilename.contains('.md'), 'The file must contain .md extension');
  final double radius;
  final String mdFilename;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Column(
        children: [
          Expanded(
              child: FutureBuilder(
                future: Future.delayed(const Duration(microseconds: 150))
                    .then((value) => rootBundle.loadString('lib/terms/terms_conditions.md')),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Markdown(
                        styleSheet: MarkdownStyleSheet.fromTheme(ThemeData(
                            textTheme: const TextTheme(
                                bodyMedium: TextStyle(
                                    fontSize: 15.0, color: Colors.black)))),
                        data: snapshot.data.toString());
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              )),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  )),
              alignment: Alignment.center,
              height: 50,
              width: double.infinity,
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.black),
              ),
            ),
          )
        ],
      ),
    );
  }
}