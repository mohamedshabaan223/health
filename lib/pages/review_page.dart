import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:health_app/app_theme.dart';
import 'package:health_app/cache/cache_helper.dart';
import 'package:health_app/cubits/review_cubit/review_cubit.dart';

class ReviewPage extends StatefulWidget {
  static const String id = '/review';

  const ReviewPage({super.key});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  final TextEditingController _commentController = TextEditingController();
  double _rating = 0;

  late int doctorId;
  late String doctorName;
  late String specialization;
  late String patientPhoto;
  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map?;
    if (args != null) {
      doctorName = args['doctorName'];
      doctorId = args['doctorId'];
      specialization = args['specializationName'];
      patientPhoto = args['photo'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ReviewCubit, ReviewState>(
      listener: (context, state) {
        if (state is ReviewSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
          Navigator.pop(context);
        } else if (state is ReviewError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(
                            Icons.arrow_back,
                            size: 30,
                            color: AppTheme.green,
                          ),
                        ),
                        const Spacer(),
                        const Text(
                          'Add Review',
                          style: TextStyle(
                              color: AppTheme.green,
                              fontSize: 24,
                              fontWeight: FontWeight.w600),
                        ),
                        const Spacer(flex: 2),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: patientPhoto.isNotEmpty
                          ? Image.file(
                              File(patientPhoto),
                              width: 160,
                              height: 150,
                              fit: BoxFit.contain,
                            )
                          : Image.asset(
                              'assets/images/male.png',
                              fit: BoxFit.contain,
                            ),
                    ),
                    const SizedBox(height: 15),
                    Text('Dr. $doctorName',
                        style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.green)),
                    const SizedBox(height: 3),
                    Text(
                      specialization,
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(fontSize: 14),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      height: 152,
                      width: 300,
                      decoration: BoxDecoration(
                        color: AppTheme.gray,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: TextFormField(
                          controller: _commentController,
                          maxLines: null,
                          minLines: 3,
                          decoration: const InputDecoration(
                            hintText: 'Enter your comment here...',
                            hintStyle: TextStyle(
                                fontSize: 15, color: Color(0xff58CFA4)),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xffECF1FF)),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xffECF1FF)),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    Text(
                      'Rate the doctor:',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 10),
                    RatingBar.builder(
                      initialRating: _rating,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: false,
                      itemCount: 5,
                      itemSize: 40,
                      unratedColor: Colors.grey.shade300,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: AppTheme.green,
                      ),
                      onRatingUpdate: (rating) {
                        setState(() {
                          _rating = rating;
                        });
                      },
                    ),
                    const SizedBox(height: 40),
                    InkWell(
                      onTap: state is ReviewLoading
                          ? null
                          : () {
                              final comment = _commentController.text.trim();
                              if (comment.isEmpty ||
                                  _rating < 1 ||
                                  _rating > 5) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Please enter valid comment and rating.')),
                                );
                                return;
                              }
                              final patientId =
                                  CacheHelper().getData(key: "id");
                              context.read<ReviewCubit>().addReview(
                                    comment: comment,
                                    rating: _rating.toInt(),
                                    patientId: patientId,
                                    doctorId: doctorId,
                                  );
                            },
                      child: Container(
                        alignment: Alignment.center,
                        height: 48,
                        width: 256,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          color: AppTheme.green,
                        ),
                        child: state is ReviewLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                'Add Review',
                                style: TextStyle(
                                    color: AppTheme.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w400),
                              ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
