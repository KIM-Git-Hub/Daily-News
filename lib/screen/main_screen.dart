import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
      body: Column(),
    );
  }

  Future getNewsInfo() async{
  //뉴스 정보를 가지고 오는 api 활용
    const apiKey = '2eb20a2fe5d0469e91adf30622eeb9a8' ;
    const apiUrl = 'https://newsapi.org/v2/top-headlines?country=kr&apiKey=$apiKey';

    try{
      //네트워크 통신을 요청하고 response 변수에 결과 값이 저장됨
      final response = await http.get(Uri.parse(apiUrl));
      if(response.statusCode == 200){ // 200 -> result ok
        final Map<String, dynamic> responseData = json.decode(response.body);
        listNewsInfo = responseData["articles"];
      }else{
        throw Exception('failed to load news');
      }
    }catch(e){
      print(e); //try 에서 에러가 발생했을때 catch에서 에러이유 출력
    }
  }
}
