import 'package:flutter/material.dart';
import 'package:health_app/app_theme.dart';
import 'package:health_app/widgets/container_schdule.dart';
import 'package:health_app/widgets/default_icon.dart';

class ContainerDoctorInfo extends StatefulWidget {
  const ContainerDoctorInfo({super.key});

  @override
  State<ContainerDoctorInfo> createState() => _ContainerDoctorInfoState();
}

class _ContainerDoctorInfoState extends State<ContainerDoctorInfo> {
  bool isFavorite = false;
  bool isRating = false;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      height: height * 0.45,
      width: width * 0.95,
      decoration: BoxDecoration(
          color: AppTheme.gray, borderRadius: BorderRadius.circular(17.0)),
      child: Padding(
        padding: const EdgeInsets.all(9),
        child: Column(
          children: [
            Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(right: 30),
                  child: CircleAvatar(
                    backgroundImage: AssetImage('assets/images/male.png'),
                    radius: 75,
                  ),
                ),
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(left: 7, top: 3),
                      height: height * 0.05,
                      width: width * 0.36,
                      decoration: BoxDecoration(
                          color: AppTheme.green,
                          borderRadius: BorderRadius.circular(30)),
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/images/professianol1.png',
                          ),
                          const SizedBox(
                            width: 7,
                          ),
                          Text(
                            '15 years\nexperience',
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(color: AppTheme.white),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: width * 0.34,
                      height: height * 0.18,
                      decoration: BoxDecoration(
                          color: AppTheme.green,
                          borderRadius: BorderRadius.circular(18)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Foucs: ',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium
                                      ?.copyWith(color: AppTheme.white),
                                ),
                                Text(
                                  'The impact',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(color: AppTheme.white),
                                ),
                              ],
                            ),
                            Text(
                              ' of hormonical imbalances on skin conditions,specializing in acne, hirsutism, and other skin disorders. ',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(color: AppTheme.white),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              width: width * 0.84,
              height: height * 0.06,
              decoration: BoxDecoration(
                color: AppTheme.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Padding(
                padding: EdgeInsets.only(left: 20.0, top: 2, bottom: 2),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Dr. Alexander Bennett, Ph.D.',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: AppTheme.green,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'Dermato-Genetics',
                      style: TextStyle(
                        color: AppTheme.black,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                _buildInfoContainer(
                  icon: Icons.star,
                  text: '5',
                  width: width * 0.12,
                ),
                SizedBox(width: width * 0.01),
                InkWell(
                  onTap: () {},
                  child: _buildInfoContainer(
                    icon: Icons.chat,
                    text: '40',
                    width: width * 0.14,
                  ),
                ),
                SizedBox(width: width * 0.01),
                _buildInfoContainer(
                  icon: Icons.alarm,
                  text: 'Mon - Sat / 9:00AM - 5:00Pm',
                  width: width * 0.57,
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                ContainerSchdule(),
                SizedBox(
                  width: width * 0.23,
                ),
                Defaulticon(
                  onTap: () {},
                  icon: const Icon(
                    Icons.chat_bubble_outline,
                    size: 17,
                    color: AppTheme.green,
                  ),
                  containerClolor: AppTheme.white,
                ),
                const SizedBox(
                  width: 4,
                ),
                Defaulticon(
                  onTap: () {},
                  icon: const Icon(
                    Icons.question_mark,
                    size: 17,
                    color: AppTheme.green,
                  ),
                  containerClolor: AppTheme.white,
                ),
                const SizedBox(
                  width: 4,
                ),
                Defaulticon(
                  onTap: () {
                    isRating = !isRating;
                    setState(() {});
                  },
                  icon: Icon(
                    isRating ? Icons.star : Icons.star_border,
                    size: 17,
                    color: AppTheme.green,
                  ),
                  containerClolor: AppTheme.white,
                ),
                const SizedBox(
                  width: 4,
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
                  containerClolor: AppTheme.white,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

Widget _buildInfoContainer({
  required IconData icon,
  required String text,
  required double width,
}) {
  return Container(
    width: width,
    height: 30,
    decoration: BoxDecoration(
      color: AppTheme.white,
      borderRadius: BorderRadius.circular(15),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: AppTheme.green, size: 20),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(
            color: AppTheme.green,
            fontSize: 14,
          ),
        ),
      ],
    ),
  );
}
