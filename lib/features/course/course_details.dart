import 'package:carrier_seeker_app/features/university/get_universites_by_course.dart';
import 'package:flutter/material.dart';
import '../../util/format_function.dart';

class CourseDetailsScreen extends StatefulWidget {
  final String? syllabus;
  final Map courseDetails;
  final Map? feeRange;
  const CourseDetailsScreen(
      {super.key, required this.courseDetails, this.syllabus, this.feeRange});

  @override
  State<CourseDetailsScreen> createState() => _CourseDetailsScreenState();
}

class _CourseDetailsScreenState extends State<CourseDetailsScreen> {
  Map _courseData = {};
  String? photoUrl, courseName, courseDescription;
  int? courseId;

  @override
  void initState() {
    _courseData = widget.courseDetails;
    if (_courseData.containsKey('photo_url')) {
      photoUrl = _courseData['photo_url'];
      courseName = _courseData['course_name'];
      courseDescription = _courseData['course_description'];
      courseId = _courseData['id'];
    } else if (_courseData['courses']?['photo_url'] != null) {
      photoUrl = _courseData['courses']?['photo_url'];
      courseName = _courseData['courses']?['course_name'];
      courseDescription = _courseData['courses']?['course_description'];
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(),
      body: SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            Material(
              borderRadius: BorderRadius.circular(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (photoUrl != null)
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                      ),
                      child: Image.network(
                        photoUrl!,
                        height: 250,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          formatValue(courseName),
                          style:
                              Theme.of(context).textTheme.titleLarge!.copyWith(
                                    color: Colors.black,
                                  ),
                        ),
                        if (widget.feeRange != null) const SizedBox(height: 4),
                        if (widget.feeRange != null)
                          Text(
                            '₹${widget.feeRange!['fee_range_start']} - ₹${widget.feeRange!['fee_range_end']}',
                            style:
                                Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: Colors.green,
                                    ),
                          ),
                        const SizedBox(height: 4),
                        Text(
                          formatValue(courseDescription),
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[700],
                                  ),
                        ),
                        if (widget.syllabus != null)
                          const SizedBox(
                            height: 20,
                          ),
                        if (widget.syllabus != null)
                          Text(
                            "Syllabus",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                  color: Colors.black,
                                ),
                          ),
                        if (widget.syllabus != null)
                          const SizedBox(
                            height: 10,
                          ),
                        if (widget.syllabus != null)
                          Text(
                            widget.syllabus!,
                            style:
                                Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      color: Colors.black,
                                    ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (courseId != null) GetUniversitesByCourse(courseID: courseId!)
          ],
        ),
      ),
    );
  }
}
