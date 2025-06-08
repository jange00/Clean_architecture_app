import 'package:student_management/core/network/hive_service.dart';
import 'package:student_management/features/course/data/data_source/course_data_source.dart';
import 'package:student_management/features/course/data/model/course_hive_model.dart';
import 'package:student_management/features/course/domain/entity/course_entity.dart';

class CourseLocalDataSource implements ICourseDataSource{
  final HiveService hiveService;

  CourseLocalDataSource({required this.hiveService});

  @override
  Future<void> createCourse(CourseEntity course) async {
    try{
      // Convert CourseEntity to CourseHiveModel
      final courseHiveModel = CourseHiveModel.fromEntity(course);
      await hiveService.addCourse(courseHiveModel);
    }catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> deleteCourse(String id) async {
    try{
      await hiveService.deleteCourse(id);
    }catch (e) {
      throw Exception(e);
    }
  }

    @override
  Future<List<CourseEntity>> getCourse() {
    try {
      return hiveService.getAllCourses().then((value) {
        return value.map((e) => e.toEntity()).toList();
      });
    } catch (e) {
      throw Exception(e);
    }
  }
}