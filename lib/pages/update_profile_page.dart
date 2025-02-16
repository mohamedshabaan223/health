import 'package:flutter/material.dart';
import 'package:health_app/app_theme.dart';
import 'package:health_app/widgets/container_icon.dart';
import 'package:health_app/widgets/update_text_field.dart';

class UpdateProfile extends StatelessWidget {
  static const String id = "/update_profile";
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          size: 25,
                          color: AppTheme.green,
                        )),
                    const Text(
                      'My Profile',
                      style: TextStyle(
                          color: AppTheme.green,
                          fontSize: 24,
                          fontWeight: FontWeight.w600),
                    ),
                    ContainerIcon(
                        onTap: () {
                          Navigator.of(context).pushNamed(UpdateProfile.id);
                        },
                        iconName: Icons.settings,
                        containerColor: AppTheme.green,
                        iconColor: AppTheme.white)
                  ],
                ),
              ),
              Center(
                child: Stack(
                  children: [
                    const CircleAvatar(
                      radius: 52,
                      backgroundImage:
                          AssetImage('assets/images/doctor_image.png'),
                    ),
                    Positioned(
                        bottom: 0,
                        right: 0,
                        child: InkWell(
                          onTap: () {},
                          child: Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                              color: AppTheme.green,
                              border:
                                  Border.all(width: 2, color: AppTheme.white),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.edit,
                              size: 20,
                              color: AppTheme.white,
                            ),
                          ),
                        ))
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Text(
                'Full Name ',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(
                height: 12,
              ),
              UpdateTextField(
                hintText: 'John Doe',
                controller: nameController,
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                'Phone number ',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(
                height: 12,
              ),
              UpdateTextField(
                hintText: '+123 567 89000',
                controller: nameController,
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                'email ',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(
                height: 12,
              ),
              UpdateTextField(
                hintText: 'Johndoe@example.com',
                controller: nameController,
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                'Date of birth ',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(
                height: 12,
              ),
              UpdateTextField(
                hintText: 'dd / mm / yy',
                controller: nameController,
              ),
              SizedBox(
                height: height * 0.06,
              ),
              Center(
                child: InkWell(
                  onTap: () {},
                  child: Container(
                    alignment: Alignment.center,
                    height: 45,
                    width: 207,
                    decoration: BoxDecoration(
                        color: AppTheme.green,
                        borderRadius: BorderRadius.circular(30)),
                    child: const Text(
                      'Update Profile',
                      style: TextStyle(
                          color: AppTheme.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w500),
                    ),
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
