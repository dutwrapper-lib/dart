import 'package:dutwrapper/model/global/lecturer_gender.dart';
import 'package:dutwrapper/model/global/lesson_range.dart';
import 'package:dutwrapper/model/global/subject_group_item.dart';
import 'package:dutwrapper/model/news/news_global.dart';
import 'package:dutwrapper/model/global/lesson_status.dart';

class NewsSubject extends NewsGlobal {
  List<SubjectGroupItem> affectedClasses = [];
  int affectedDate = 0;
  LessonStatus lessonStatus = LessonStatus.unknown;
  LessonRange affectedLessons = LessonRange();
  String affectedRoom = '';
  String lecturerName = '';
  LecturerGender lecturerGender = LecturerGender.other;
}
