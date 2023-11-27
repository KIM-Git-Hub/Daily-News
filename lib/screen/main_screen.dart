import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<dynamic> listNewsInfo = [];

  @override
  void initState() {
    super.initState();
    getNewsInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '\u{1F4F0} Daily News',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        backgroundColor: const Color(0xff424242),
      ),
      body: ListView.builder(
        itemCount: listNewsInfo.length,
        itemBuilder: (context, index) {
          var newsItem = listNewsInfo[index];
          return GestureDetector(
            onTap: () {
              context.push('/detail', extra: newsItem);
            },
            child: Container(
              margin: const EdgeInsets.all(16),
              child: newsItem['urlToImage'] != null
                  ? Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        /// 이미지, 반투명 검정 ui, 제목 날짜 제목 텍스트
                        SizedBox(
                          height: 170,
                          width: double.infinity,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
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
                          height: 60,
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
                              Container(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  newsItem['title'],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 5),
                                alignment: Alignment.bottomRight,
                                child: Text(formatDate(newsItem['publishedAt'],),
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
                            alignment: Alignment.bottomRight,
                            child: Text(formatDate(newsItem['publishedAt']),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                )),
                          )
                        ],
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }

  String formatDate(String dateString) {
    final dateTime = DateTime.parse(dateString);
    final formatter = DateFormat('yyyy.MM.dd HH:mm');
    return formatter.format(dateTime);
  }

  Future getNewsInfo() async {
    //뉴스 정보를 가지고 오는 api 활용
    const apiKey = '2eb20a2fe5d0469e91adf30622eeb9a8';
    const apiUrl =
        'https://newsapi.org/v2/top-headlines?country=jp&apiKey=$apiKey';

    try {
      //네트워크 통신을 요청하고 response 변수에 결과 값이 저장됨
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        // 200 -> result ok
        final Map<String, dynamic> responseData = json.decode(response.body);
        setState(() {
          listNewsInfo = responseData["articles"];
        });
      } else {
        throw Exception('failed to load news');
      }
    } catch (e) {
      print(e); //try 에서 에러가 발생했을때 catch에서 에러이유 출력
    }
  }
}
