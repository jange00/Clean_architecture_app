import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_management/features/course/domain/use_case/create_course_usecase.dart';
import 'package:student_management/features/course/domain/use_case/delete_course_usecase.dart';
import 'package:student_management/features/course/domain/use_case/getall_course_usecase.dart';
import 'package:student_management/features/course/presentation/view_model/course_event.dart';
import 'package:student_management/features/course/presentation/view_model/course_state.dart';

class CourseViewModel extends Bloc<CourseEvent, CourseState> {
  final CreateCourseUsecase _createCourseUsecase;
  final GetallCourseUsecase _getallCourseUsecase;
  final DeleteCourseUsecase _deleteCourseUsecase; 

  CourseViewModel({
    required CreateCourseUsecase createCourseUseCase,
    required GetallCourseUsecase getAllCourseUseCase,
    required DeleteCourseUsecase deleteCourseUseCase,
  }) : _createCourseUsecase = createCourseUseCase,
       _deleteCourseUsecase = deleteCourseUseCase,
       _getallCourseUsecase = getAllCourseUseCase,
       super(CourseState.initial()) {
        on<LoadCourses>(_onLoadCourses);
        on<AddCourse>(_onAddCourse);
        on<DeleteCourse>(_onDeleteCourse);

        // call this event whenever the bloc is created
        add(LoadCourses());
       }

        Future<void> _onLoadCourses(LoadCourses event,Emitter<CourseState> emit,) async {
    emit(state.copyWith(isLoading: true));
    final result = await _getallCourseUsecase.call();
    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, error: failure.message)),
      (courses) => emit(state.copyWith(isLoading: false, courses: courses)),
    );
  }

   Future<void> _onAddCourse(AddCourse event, Emitter<CourseState> emit) async {
    emit(state.copyWith(isLoading: true));
    final result = await _createCourseUsecase.call(
      CreateCourseParams(courseName: event.courseName),
    );
    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, error: failure.message)),
      (batches) {
        emit(state.copyWith(isLoading: false, error: null));
        add(LoadCourses());
      },
    );
  }

  Future<void> _onDeleteCourse(DeleteCourse event,Emitter<CourseState> emit,) async {
    emit(state.copyWith(isLoading: true));
    final result = await _deleteCourseUsecase.call(
      DeleteCourseParams(courseId: event.courseId),
    );
    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, error: failure.message)),
      (batches) {
        emit(state.copyWith(isLoading: false, error: null));
        add(LoadCourses());
      },
    );
  }
}
