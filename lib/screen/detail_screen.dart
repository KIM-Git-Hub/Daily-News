import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DetailScreen extends StatelessWidget {
  dynamic newsItem;

  DetailScreen({super.key, this.newsItem});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextButton(
          child: const Text(
            '뒤로가기',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 24,
            ),
          ),
          onPressed: () {
            context.pop();
          },
        ),
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xff424242),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(16),
              child: newsItem['urlToImage'] != null
                  ? Column(
                      children: [
                        SizedBox(
                          height: 250,
                          width: double.infinity,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                            child: Image.network(
                              newsItem['urlToImage'],
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset('assets/no_image.png');
                              },
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Container(
                          height: 90,
                          padding: const EdgeInsets.all(8),
                          width: double.infinity,
                          decoration: ShapeDecoration(
                              color: Colors.black.withOpacity(0.7),
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10)))),
                          child: Column(
                            children: [
                              Text(
                                newsItem['title'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 5),
                                alignment: Alignment.bottomRight,
                                child: Text(newsItem['publishedAt'],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    )),
                              )
                            ],
                          ),
                        )
                      ],
                    )
                  : Container(
                      //이미지가 없을때
                ///내일 여기 하기
                      height: 95,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          border: Border.all(width: 1, color: Colors.white),
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        children: [
                          Text(
                            newsItem['title'],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            child: Text(newsItem['publishedAt'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                )),
                          )
                        ],
                      ),
                    ),
            )
          ],
        ),
      ),
    );
  }
}
