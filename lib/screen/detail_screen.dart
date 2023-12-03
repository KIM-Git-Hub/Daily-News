import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class DetailScreen extends StatefulWidget {
  dynamic newsItem;

  DetailScreen({super.key, this.newsItem});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextButton(
          child: const Text(
            'BACK',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          onPressed: () {
            context.pop();
          },
        ),
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xff424242),
      ),
      body: Column(
        children: [
          Expanded(
              child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(16),
                  child: widget.newsItem['urlToImage'] != null
                      ? Column(
                          children: [
                            SizedBox(
                              height: 200,
                              width: double.infinity,
                              child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                ),
                                child: Image.network(
                                  widget.newsItem['urlToImage'],
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset('assets/no_image.png');
                                  },
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Container(
                              height: 80,
                              padding: const EdgeInsets.all(8),
                              width: double.infinity,
                              decoration: ShapeDecoration(
                                  color: Colors.black.withOpacity(0.7),
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(10),
                                          bottomRight: Radius.circular(10)))),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      widget.newsItem['title'],
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Container(
                                    height: 16,
                                    margin: const EdgeInsets.only(top: 5),
                                    alignment: Alignment.bottomRight,
                                    child: Text(
                                        formatDate(
                                            widget.newsItem['publishedAt']),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        )),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              alignment: Alignment.topLeft,
                              margin: const EdgeInsets.only(top: 20),
                              child: widget.newsItem['description'] != null
                                  ? Text(
                                      widget.newsItem['description'],
                                      style: const TextStyle(fontSize: 15),
                                    )
                                  : const Text(''),
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            Container(
                              ///이미지가 없을때
                              height: 100,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.7),
                                  border:
                                      Border.all(width: 1, color: Colors.white),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                children: [
                                  Text(
                                    widget.newsItem['title'],
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.bottomRight,
                                    margin: const EdgeInsets.only(top: 10),
                                    child: Text(
                                      formatDate(
                                          widget.newsItem['publishedAt']),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              alignment: Alignment.topLeft,
                              margin: const EdgeInsets.only(top: 20),
                              child: widget.newsItem['description'] != null
                                  ? Text(
                                      widget.newsItem['description'],
                                      style: const TextStyle(fontSize: 15),
                                    )
                                  : const Text(''),
                            ),
                          ],
                        ),
                ),
              ],
            ),
          )),
          Container(
            margin: const EdgeInsets.only(bottom: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () {
                      launchURL();
                    },
                    child: const Text('元のページを開く')),
                Container(
                  margin: const EdgeInsets.only(left: 20),
                ),
                ElevatedButton(
                    onPressed: () {
                      shareNews(
                          '${widget.newsItem['title']}\n\n${widget.newsItem['url']}',
                          'share news');
                    },
                    child: const Text('共有')),
              ],
            ),
          )
        ],
      ),
    );
  }

  void shareNews(String shareInfo, String subject) async {
    await Share.share(shareInfo, subject: subject);
  }

  void launchURL() async {
    String url = widget.newsItem['url'];
    if (await canLaunchUrlString(url)) {
      await launchUrl(Uri.parse(url));
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('ページが開けません。'),
          ),
        );
      }
    }
  }

  String formatDate(String dateString) {
    final dateTime = DateTime.parse(dateString);
    final formatter = DateFormat('yyyy.MM.dd HH:mm');
    return formatter.format(dateTime);
  }
}
