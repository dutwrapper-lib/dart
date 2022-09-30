library dutapi;

import 'dart:convert';

import 'package:dutapi/model/global/request_code.dart';
import 'package:dutapi/model/global/request_status.dart';
import 'package:dutapi/model/global/variables.dart';
import 'package:http/http.dart' as http;

class Account {
  static Future<RequestStatus> generateSessionID() async {
    RequestStatus ars = RequestStatus();

    try {
      final response = await http.get(Uri.parse('http://sv.dut.udn.vn/'));

      // Get session id
      var cookieHeader = response.headers['set-cookie'];
      if (cookieHeader != null) {
        String splitChar;
        if (cookieHeader.contains('; ')) {
          splitChar = '; ';
        } else {
          splitChar = ';';
        }

        List<String> cookieHeaderSplit = cookieHeader.split(splitChar);
        for (String item in cookieHeaderSplit) {
          if (item.contains('ASP.NET_SessionId')) {
            List<String> sessionIdSplit = item.split('=');
            ars.sessionId = sessionIdSplit[1];
          }
        }
      }

      ars.statusCode = response.statusCode;
      ars.requestCode = [200, 204].contains(ars.statusCode)
          ? RequestCode.successful
          : RequestCode.failed;
    } catch (ex) {
      print(ex);
      ars.requestCode = RequestCode.nointernet;
    }
    return ars;
  }

  static Future<RequestStatus> isLoggedIn({required String sessionId}) async {
    RequestStatus ars = RequestStatus();
    ars.sessionId = sessionId;

    Map<String, String> header = <String, String>{
      'cookie': 'ASP.NET_SessionId=$sessionId;'
    };

    try {
      final response = await http.get(
          Uri.parse(
              'http://sv.dut.udn.vn/WebAjax/evLopHP_Load.aspx?E=TTKBLoad&Code=2210'),
          headers: header);
      ars.statusCode = response.statusCode;
      ars.requestCode = [200, 204].contains(ars.statusCode)
          ? RequestCode.successful
          : RequestCode.failed;
    } catch (ex) {
      print(ex);
      ars.requestCode = RequestCode.nointernet;
    }
    return ars;
  }

  static Future<RequestStatus> login(
      {required String sessionId,
      required String userId,
      required String password}) async {
    // Header data
    Map<String, String> header = <String, String>{
      'cookie': 'ASP.NET_SessionId=$sessionId;',
      'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
    };

    // Post data
    var postData = <String, String>{
      Variables.loginViewStateHeader: Variables.loginViewStateValue,
      Variables.loginViewStateGeneratorHeader:
          Variables.loginViewStateGeneratorValue,
      Variables.loginUserHeader: userId,
      Variables.loginPassHeader: password,
      Variables.loginBtnHeader: Variables.loginBtnValue
    };
    try {
      final response = await http.post(
          Uri.parse('http://sv.dut.udn.vn/PageDangNhap.aspx'),
          headers: header,
          encoding: Encoding.getByName('utf-8'),
          body: postData);
      return await isLoggedIn(sessionId: sessionId);
    } catch (ex) {
      print(ex);
      RequestStatus ars = RequestStatus();
      ars.sessionId = sessionId;

      ars.requestCode = RequestCode.nointernet;
      return ars;
    }
  }

  static Future<RequestStatus> logout({required String sessionId}) async {
    RequestStatus ars = RequestStatus();
    ars.sessionId = sessionId;

    // Header data
    Map<String, String> header = <String, String>{
      'cookie': 'ASP.NET_SessionId=$sessionId;',
    };

    try {
      final response = await http.get(
          Uri.parse('http://sv.dut.udn.vn/PageLogout.aspx'),
          headers: header);
      RequestStatus loginStatus = await isLoggedIn(sessionId: sessionId);
      ars.statusCode = loginStatus.statusCode == 200 ? 404 : 200;
      ars.requestCode = loginStatus.requestCode == RequestCode.successful
          ? RequestCode.failed
          : loginStatus.requestCode == RequestCode.failed
              ? RequestCode.successful
              : loginStatus.requestCode;
    } catch (ex) {
      ars.requestCode = RequestCode.nointernet;
    }

    return ars;
  }
}
