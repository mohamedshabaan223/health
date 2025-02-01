import 'package:flutter/material.dart';
import 'package:health_app/app_theme.dart';
import 'package:health_app/widgets/default_icon.dart';

class Review extends StatefulWidget {
  static const String id = '/review';

  @override
  State<Review> createState() => _ReviewState();
}

class _ReviewState extends State<Review> {
  bool isFavorite = false;
  bool isRating = false;
  bool isRatingTwo = false;
  bool isRatingThree = false;
  bool isRatingFour = false;
  bool isRatingFive = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
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
                      )),
                  const Spacer(
                    flex: 1,
                  ),
                  const Text(
                    'Review',
                    style: TextStyle(
                        color: AppTheme.green,
                        fontSize: 24,
                        fontWeight: FontWeight.w600),
                  ),
                  const Spacer(
                    flex: 2,
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(fontSize: 14),
              ),
              const SizedBox(
                height: 30,
              ),
              const CircleAvatar(
                radius: 80,
                backgroundImage: AssetImage('assets/images/doctor_image.png'),
              ),
              const SizedBox(
                height: 15,
              ),
              const Text('Dr. Olivia Turner, M.D.',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.green)),
              const SizedBox(
                height: 3,
              ),
              Text(
                'Dermato-Endocrinology',
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(fontSize: 14),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  const Spacer(
                    flex: 1,
                  ),
                  Defaulticon(
                    onTap: () {
                      isFavorite = !isFavorite;
                      setState(() {});
                    },
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      size: 17,
                      color: AppTheme.green,
                    ),
                    containerClolor: AppTheme.gray,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Container(
                    height: 23,
                    width: 150,
                    decoration: BoxDecoration(
                      color: AppTheme.gray,
                      borderRadius: BorderRadius.circular(23),
                    ),
                    child: Row(
                      children: [
                        Defaulticon(
                          onTap: () {
                            setState(() {
                              isRating = !isRating;
                            });
                          },
                          icon: Icon(
                            isRating ? Icons.star : Icons.star_border,
                            size: 17,
                            color: AppTheme.green,
                          ),
                          containerClolor: AppTheme.gray,
                        ),
                        Defaulticon(
                          onTap: () {
                            setState(() {
                              isRatingTwo = !isRatingTwo;
                            });
                          },
                          icon: Icon(
                            isRatingTwo ? Icons.star : Icons.star_border,
                            size: 17,
                            color: AppTheme.green,
                          ),
                          containerClolor: AppTheme.gray,
                        ),
                        Defaulticon(
                          onTap: () {
                            setState(() {
                              isRatingThree = !isRatingThree;
                            });
                          },
                          icon: Icon(
                            isRatingThree ? Icons.star : Icons.star_border,
                            size: 17,
                            color: AppTheme.green,
                          ),
                          containerClolor: AppTheme.gray,
                        ),
                        Defaulticon(
                          onTap: () {
                            setState(() {
                              isRatingFour = !isRatingFour;
                            });
                          },
                          icon: Icon(
                            isRatingFour ? Icons.star : Icons.star_border,
                            size: 17,
                            color: AppTheme.green,
                          ),
                          containerClolor: AppTheme.gray,
                        ),
                        Defaulticon(
                          onTap: () {
                            setState(() {
                              isRatingFive = !isRatingFive;
                            });
                          },
                          icon: Icon(
                            isRatingFive ? Icons.star : Icons.star_border,
                            size: 17,
                            color: AppTheme.green,
                          ),
                          containerClolor: AppTheme.gray,
                        ),
                      ],
                    ),
                  ),
                  const Spacer(
                    flex: 1,
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                height: 152,
                width: 300,
                decoration: BoxDecoration(
                    color: AppTheme.gray,
                    borderRadius: BorderRadius.circular(18)),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'enter your comment here...',
                      hintStyle:
                          TextStyle(fontSize: 15, color: Color(0xff58CFA4)),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffECF1FF))),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffECF1FF))),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              InkWell(
                onTap: () {},
                child: Container(
                  alignment: Alignment.center,
                  height: 48,
                  width: 256,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    color: AppTheme.green,
                  ),
                  child: const Text(
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
    );
  }
}
