import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_management/core/common/snackbar/my_snackbar.dart';
import 'package:student_management/features/course/presentation/view_model/course_event.dart';
import 'package:student_management/features/course/presentation/view_model/course_state.dart';
import 'package:student_management/features/course/presentation/view_model/course_view_model.dart';

class CourseView extends StatelessWidget {
  CourseView({super.key});
  final courseNameController = TextEditingController();
  final _courseViewFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _courseViewFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: courseNameController,
                decoration: const InputDecoration(labelText: 'Course Name'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter course name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  if (_courseViewFormKey.currentState!.validate()) {
                    context.read<CourseViewModel>().add(
                          AddCourse(courseNameController.text),
                        );
                  }
                },
                child: Text('Add Course'),
              ),
              SizedBox(height: 10),
              BlocBuilder<CourseViewModel, CourseState>(
                builder: (context, state) {
                  if (state.courses.isEmpty) {
                    return Center(child: Text("No courses Added yet"));
                  } else if (state.isLoading) {
                    return CircularProgressIndicator();
                  } else if (state.error != null) {
                    return showMySnackBar(
                      context: context,
                      message: state.error!,
                      color: Colors.red,
                    );
                  } else {
                    return Expanded(
                      child: ListView.builder(
                        itemCount: state.courses.length,
                        itemBuilder: (BuildContext context, index) {
                          return ListTile(
                            title: Text(state.courses[index].courseName),
                            subtitle: Text(state.courses[index].courseId!),
                            trailing: IconButton(
                              onPressed: () {
                                context.read<CourseViewModel>().add(
                                      DeleteCourse(state.courses[index].courseId!),
                                    );
                              },
                              icon: Icon(Icons.delete),
                            ),
                          );
                        },
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
