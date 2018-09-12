import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tools/Utils/EncryptUtils.dart';
import 'package:flutter_tools/Utils/HttpUtils.dart';
import 'package:flutter_tools/Widgets/MyLazyScaffod.dart';
import 'package:flutter_tools/Widgets/Refresh.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AppState();
// This widget is the root of your application.

}

class _AppState extends State<MyApp> {
var text="";
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text("你好"),
        ),
        body:  RefreshLayout(
            header: (c, s) {
              return _TextedRefresh(s, true);
            },
            footer: (c, s) {
              return _TextedRefresh(s, false);
            },
            child: SingleChildScrollView(child: MyWideget(100),),
            onRefresh: (b) async {
              await Future.delayed(Duration(seconds: 2));
              setState(() {

              });
              return null;
            },
            valueChanged: (v) {}),
        bottomNavigationBar:
        BottomNavigationBar(items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text("你好")),
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text("你好")),
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text("你好")),
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text("你好")),
        ]),
      ),
    );
  }
  Widget _TextedRefresh(RefreshLayoutMode s, bool r) {
    switch (s) {
      case RefreshLayoutMode.refresh:
        text = r ? "正在刷新" : "正在加载";
        break;
      case RefreshLayoutMode.armed:
        text = r ? "释放刷新" : "释放加载";
        break;
      case RefreshLayoutMode.drag:
        text = r ? "下拉刷新" : "上拉加载";
        break;
      case RefreshLayoutMode.done:
        text = r ? "下拉刷新" : "上拉加载";
        break;
    }
    return Text(text);
  }
}

class MyWideget extends StatefulWidget {
  int page;

  MyWideget(this.page);

  @override
  State<StatefulWidget> createState() => S();
}

class S extends State<MyWideget> {
  var text2 = "";

  @override
  void initState() {
    super.initState();
    test();
  }

  test() async {
//    var params = EncryptUtil.WrapSignParams(
//        {"subid": "22A998F5-4341-4801-A47C-09F8D94A48F0"},
//        "0a7b8db5-dc6f-4448-afec-bf2f186ddafb");
//    var result = await http.post<String>("cacheLoadGroup/getCacheLoadGroup",
//        data: params, options: Options(responseType: ResponseType.PLAIN));
//    setState(() {
//      text2 = Utf8Codec().decode(Base64Codec().decode(result.data.toString()));
//    });
    await Future.delayed(Duration(seconds: 1)).whenComplete(() {
      setState(() {
        text2 = text;
      });
    });
  }

  @override
  Widget build(BuildContext context) =>
      Center(child: Text("${widget.page} \n ${text2}"));

  var text = '''{"Message":"成功","Data":{"groupreals":[{"lgr_name":"陈启林","lgr_lgid":"2C998ED7-C3DA-48ED-8D86-01972B0C3F18","lgr_id":"8273EE18-DE75-4CB1-A0E8-509A79CA3F4D","lgr_uid":"SF002083"},{"lgr_name":"汤亚锋","lgr_lgid":"BA069A70-79FB-4444-9305-0D550EB3B671","lgr_id":"453AEBE8-DA97-4558-8307-35D8AA399B1A","lgr_uid":"SF005684"},{"lgr_name":"犹强","lgr_lgid":"BA069A70-79FB-4444-9305-0D550EB3B671","lgr_id":"F8BD1C7A-705E-4D63-ADE0-CCC69C0288D0","lgr_uid":"SF002107"},{"lgr_name":"李刚","lgr_lgid":"BA069A70-79FB-4444-9305-0D550EB3B671","lgr_id":"D907E7AA-7775-464E-84EC-CE4CC466C36B","lgr_uid":"SF002076"},{"lgr_name":"米传学","lgr_lgid":"4369876E-BC41-4FE6-89EB-1476F98C395E","lgr_id":"3D4FE5F9-8470-44DE-BD35-6BAA0591CC4D","lgr_uid":"SF006450"},{"lgr_name":"耿军强","lgr_lgid":"4369876E-BC41-4FE6-89EB-1476F98C395E","lgr_id":"93A21890-E824-403A-9B0C-CC8EC327C454","lgr_uid":"SF002074"},{"lgr_name":"付三","lgr_lgid":"4369876E-BC41-4FE6-89EB-1476F98C395E","lgr_id":"446721AE-3AEA-443F-9958-D216FCDDB2A0","lgr_uid":"SF002082"},{"lgr_name":"刘国付","lgr_lgid":"D1C7518F-B4DA-492D-8E80-304DD3CF3D98","lgr_id":"47872DCF-034E-4CD7-BE30-B76C4F81C758","lgr_uid":"SF002052"},{"lgr_name":"马恒保","lgr_lgid":"D1C7518F-B4DA-492D-8E80-304DD3CF3D98","lgr_id":"8191E947-06D0-4793-90ED-C963481BD762","lgr_uid":"SF002053"},{"lgr_name":"李世瑶","lgr_lgid":"D1C7518F-B4DA-492D-8E80-304DD3CF3D98","lgr_id":"FF1802D2-09F1-4BFE-871D-F3D70CF574AB","lgr_uid":"SF002077"},{"lgr_name":"刘云华","lgr_lgid":"DEFA5BED-3AD5-43CE-85CB-3B5324DC38CB","lgr_id":"39B367E2-5872-4B26-BF07-4DC99D49DB82","lgr_uid":"SF002095"},{"lgr_name":"张建民","lgr_lgid":"160C8AE4-7CD0-4259-90BA-62730430AB5B","lgr_id":"F16CC001-7992-4DFA-A7BB-630E5C04950F","lgr_uid":"SF002122"},{"lgr_name":"耿要强","lgr_lgid":"160C8AE4-7CD0-4259-90BA-62730430AB5B","lgr_id":"916DC904-2445-4A73-9F34-680C8A58CCDB","lgr_uid":"SF002111"},{"lgr_name":"耿留强","lgr_lgid":"160C8AE4-7CD0-4259-90BA-62730430AB5B","lgr_id":"75D93BBD-2EDE-4025-8A6F-7C01DBD0B050","lgr_uid":"SF002110"},{"lgr_name":"韦新华","lgr_lgid":"067289FE-1CBA-4718-87DE-6D32606DD44F","lgr_id":"409EBB21-3E1F-4D71-8071-3733379CC52E","lgr_uid":"SF002087"},{"lgr_name":"刘日通","lgr_lgid":"067289FE-1CBA-4718-87DE-6D32606DD44F","lgr_id":"22557C46-79E5-418C-90CB-E9C98EA302F3","lgr_uid":"SF002073"},{"lgr_name":"李方来","lgr_lgid":"726FBB53-25B9-416F-8BFC-A358AA3CECFE","lgr_id":"A02CEB49-CDAF-42A9-B624-63E8FF6AF18E","lgr_uid":"SF006448"},{"lgr_name":"吴宗平","lgr_lgid":"6DF3FF4F-F4D4-48FF-A03D-BE1BB30DD183","lgr_id":"C68B9C81-40D3-44F4-BE28-7F2971441E28","lgr_uid":"SF002109"},{"lgr_name":"易清贵","lgr_lgid":"6DF3FF4F-F4D4-48FF-A03D-BE1BB30DD183","lgr_id":"4C78FEB7-32F2-4A03-AB2B-C956EBC4DF51","lgr_uid":"SF002101"},{"lgr_name":"黄浅文","lgr_lgid":"6DF3FF4F-F4D4-48FF-A03D-BE1BB30DD183","lgr_id":"E136D66F-563B-43C7-95EC-C38EF5E34E42","lgr_uid":"SF006446"},{"lgr_name":"马德法","lgr_lgid":"AC9767D2-C255-4CC7-B8F0-D0881623C7CC","lgr_id":"432A0431-5307-4C06-8221-48C21D6100C5","lgr_uid":"SF002054"},{"lgr_name":"兰垂有","lgr_lgid":"AC9767D2-C255-4CC7-B8F0-D0881623C7CC","lgr_id":"7E0398F0-2DD7-4F01-B69D-CF5F74763B37","lgr_uid":"SF002123"},{"lgr_name":"徐卓明","lgr_lgid":"AC9767D2-C255-4CC7-B8F0-D0881623C7CC","lgr_id":"8F575C2B-4D5C-43CB-A614-871349E82BAE","lgr_uid":"SF005681"},{"lgr_name":"饶良春","lgr_lgid":"20C0E969-3D0D-4AA5-8F9F-D36429D0FEDB","lgr_id":"C019F754-28A2-43AE-B1D7-ADF23B63B5EC","lgr_uid":"SF002072"},{"lgr_name":"耿胜利","lgr_lgid":"1DBB6370-31C8-4069-9B47-DB974A1BCD17","lgr_id":"A7ACC2AE-79D3-48D4-AF86-8E9C51F62FC3","lgr_uid":"SF002099"},{"lgr_name":"耿中伟","lgr_lgid":"1DBB6370-31C8-4069-9B47-DB974A1BCD17","lgr_id":"FE970EFE-BFEA-4B37-9311-906324A186E7","lgr_uid":"SF006445"},{"lgr_name":"殷新遂","lgr_lgid":"6B73F3F0-AB44-4DE7-B544-F89A2166319A","lgr_id":"3F361A69-6C5D-471A-ABFD-68D86494E0DA","lgr_uid":"SF002105"},{"lgr_name":"薛永军","lgr_lgid":"6B73F3F0-AB44-4DE7-B544-F89A2166319A","lgr_id":"71BC0260-1872-4956-AE50-0140D37F50FD","lgr_uid":""},{"lgr_name":"潘智强","lgr_lgid":"6B73F3F0-AB44-4DE7-B544-F89A2166319A","lgr_id":"18CED8BB-E843-4077-9ED4-1EC4B445DE76","lgr_uid":"SF006442"}],"groups":[{"lg_id":"2C998ED7-C3DA-48ED-8D86-01972B0C3F18","lg_name":"到达08组","lg_subid":"22A998F5-4341-4801-A47C-09F8D94A48F0"},{"lg_id":"BA069A70-79FB-4444-9305-0D550EB3B671","lg_name":"到达01组","lg_subid":"22A998F5-4341-4801-A47C-09F8D94A48F0"},{"lg_id":"4369876E-BC41-4FE6-89EB-1476F98C395E","lg_name":"到达02组","lg_subid":"22A998F5-4341-4801-A47C-09F8D94A48F0"},{"lg_id":"B1BF6150-2A2C-4FAC-97A7-24C5993C4244","lg_name":"到达14组","lg_subid":"22A998F5-4341-4801-A47C-09F8D94A48F0"},{"lg_id":"DCC70ED1-7CE3-4806-B421-2A3606542D8D","lg_name":"龙记专用","lg_subid":"22A998F5-4341-4801-A47C-09F8D94A48F0"},{"lg_id":"D1C7518F-B4DA-492D-8E80-304DD3CF3D98","lg_name":"到达11组","lg_subid":"22A998F5-4341-4801-A47C-09F8D94A48F0"},{"lg_id":"DEFA5BED-3AD5-43CE-85CB-3B5324DC38CB","lg_name":"到达13组","lg_subid":"22A998F5-4341-4801-A47C-09F8D94A48F0"},{"lg_id":"160C8AE4-7CD0-4259-90BA-62730430AB5B","lg_name":"到达03组","lg_subid":"22A998F5-4341-4801-A47C-09F8D94A48F0"},{"lg_id":"067289FE-1CBA-4718-87DE-6D32606DD44F","lg_name":"到达07组","lg_subid":"22A998F5-4341-4801-A47C-09F8D94A48F0"},{"lg_id":"D7660682-8D2E-4320-96A1-749C56ED1A1E","lg_name":"平台专用","lg_subid":"22A998F5-4341-4801-A47C-09F8D94A48F0"},{"lg_id":"D3A6462A-CDC2-4DA2-94FB-78FF477B4E0E","lg_name":"外部","lg_subid":"22A998F5-4341-4801-A47C-09F8D94A48F0"},{"lg_id":"726FBB53-25B9-416F-8BFC-A358AA3CECFE","lg_name":"到达10组","lg_subid":"22A998F5-4341-4801-A47C-09F8D94A48F0"},{"lg_id":"6DF3FF4F-F4D4-48FF-A03D-BE1BB30DD183","lg_name":"到达06组","lg_subid":"22A998F5-4341-4801-A47C-09F8D94A48F0"},{"lg_id":"AC9767D2-C255-4CC7-B8F0-D0881623C7CC","lg_name":"到达12组","lg_subid":"22A998F5-4341-4801-A47C-09F8D94A48F0"},{"lg_id":"20C0E969-3D0D-4AA5-8F9F-D36429D0FEDB","lg_name":"到达09组","lg_subid":"22A998F5-4341-4801-A47C-09F8D94A48F0"},{"lg_id":"1DBB6370-31C8-4069-9B47-DB974A1BCD17","lg_name":"到达04组","lg_subid":"22A998F5-4341-4801-A47C-09F8D94A48F0"},{"lg_id":"6B73F3F0-AB44-4DE7-B544-F89A2166319A","lg_name":"到达05组","lg_subid":"22A998F5-4341-4801-A47C-09F8D94A48F0"}]},"Code":200}''';
}
