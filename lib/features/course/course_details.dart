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

  @override
  void initState() {
    _courseData = widget.courseDetails;
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
                  if (_courseData['photo_url'] != null)
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                      ),
                      child: Image.network(
                        _courseData['photo_url'],
                        height: 400,
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
                          formatValue(_courseData['course_name']),
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
                          formatValue(_courseData['course_description']),
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
          ],
        ),
      ),
    );
  }
}
