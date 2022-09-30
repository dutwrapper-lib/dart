import 'dart:io';

import 'package:dutwrapper/account.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:dutwrapper/news.dart';

void main() {
  test('Get news global - Page 1', () async {
    final response = await News.getNewsGlobal(page: 1);

    if (response.isNotEmpty) {
      response.forEach((element) {
        print('========================================');
        print('Date: ${element.date}');
        print('Title: ${element.title}');
        print('Content String: ${element.contentString}');
        print('Links:');
        element.links.forEach((element) {
          print('========= Link ========');
          print('Text: ${element.text}');
          print('Position: ${element.position}');
          print('Url: ${element.url}');
        });
      });
    } else
      print('Nothing in list!');
  });

  test('Get news subject - Page 2', () async {
    final response = await News.getNewsSubject(page: 1);

    if (response.isNotEmpty) {
      response.forEach((element) {
        print('========================================');
        print('Date: ${element.date}');
        print('Title: ${element.title}');
        print('Content: ${element.contentString}');
        print('Lecturer Gender: ${element.lecturerGender.toString()}');
        print('Lecturer Name: ${element.lecturerName}');
        print('Lesson Status: ${element.lessonStatus.toString()}');
        print('Affected Date: ${element.affectedDate}');
        print('Affected Lesson: ${element.affectedLessons.toString()}');
        print('Affected Room: ${element.affectedRoom}');
        print('Affected Class:');
        element.affectedClasses.forEach((element) {
          print(element.subjectName);
          element.codeList.forEach((element) {
            print(element.toStringTwoLastDigit());
          });
        });
      });
    } else
      print('Nothing in list!');
  });

  test('Account', () async {
    String sessionId = '';
    var env1 = Platform.environment['dut_account'];
    if (env1 == null) {
      print('No dut_account environment found! Exiting...');
      return;
    }
    String username = env1.split('|')[0];
    String password = env1.split('|')[1];

    // Get session id
    await Account.generateSessionID().then((value) => {
          print('GenerateSessionID'),
          sessionId = value.sessionId,
          print('Session ID: ${value.sessionId}'),
          print('Status Code: ${value.statusCode}')
        });

    if (sessionId == '') {
      print('No session id found! Exiting...');
      return;
    }
    print('');

    // Check is logged in
    await Account.isLoggedIn(sessionId: sessionId).then((value) => {
          print('IsLoggedIn (Not logged in code)'),
          print('Status: ${value.requestCode.toString()}'),
          print('Status Code: ${value.statusCode}')
        });
    print('');

    // Login
    await Account.login(
        userId: username, password: password, sessionId: sessionId);

    // Check again
    await Account.isLoggedIn(sessionId: sessionId).then((value) => {
          print('IsLoggedIn (Logged in code)'),
          print('Status: ${value.requestCode.toString()}'),
          print('Status Code: ${value.statusCode}')
        });
    print('');

    // Subject Schedule
    await Account.getSubjectSchedule(
            sessionId: sessionId, year: 21, semester: 2)
        .then((value) => {
              print('Subject Schedule'),
              print('Status: ${value.requestCode.toString()}'),
              print('Status Code: ${value.statusCode}'),
              value.data?.forEach((element) {
                print('=================');
                print('Id: ${element.id.toString()}');
                print('Name: ${element.name}');
                print('Credit: ${element.credit}');
                print('IsHighQuality: ${element.isHighQuality}');
                print('Lecturer: ${element.lecturerName}');
                print('Subject Study:');
                element.subjectStudy.subjectStudyList.forEach((element) {
                  print('-========= Item ==========-');
                  print('- Day of week: ${element.dayOfWeek}');
                  print('- Lesson: ${element.lesson.toString()}');
                  print('- Room: ${element.room}');
                });
                print('Subject Exam:');
                print('- Date: ${element.subjectExam.date}');
                print('- Group: ${element.subjectExam.group}');
                print('- IsGlobal: ${element.subjectExam.isGlobal}');
                print('- Room: ${element.subjectExam.room}');
                print('Point formula: ${element.pointFormula}');
              }),
            });
    print('');

    // Logout
    await Account.logout(sessionId: sessionId).then((value) => {
          print('Logout'),
          print('Status: ${value.requestCode.toString()}'),
          print('Status Code: ${value.statusCode}')
        });
    print('');

    // Check again
    await Account.isLoggedIn(sessionId: sessionId).then((value) => {
          print('IsLoggedIn (Logged in code)'),
          print('Status: ${value.requestCode.toString()}'),
          print('Status Code: ${value.statusCode}')
        });
    print('');
  });
}
