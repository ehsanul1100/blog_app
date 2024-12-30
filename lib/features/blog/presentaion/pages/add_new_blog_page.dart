import 'dart:io';

import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:blog_app/core/utils/pick_image.dart';
import 'package:blog_app/features/blog/presentaion/widgets/blog_editor.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class AddNewBlogPage extends StatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => const AddNewBlogPage());
  const AddNewBlogPage({super.key});

  @override
  State<AddNewBlogPage> createState() => _AddNewBlogPageState();
}

class _AddNewBlogPageState extends State<AddNewBlogPage> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  List<String> selectedTopics = [];
  File? image;
  void selectImage() async {
    final pickedImage = await pickImage();
    if (pickedImage != null) {
      setState(() {
        image = pickedImage;
      });
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.done_rounded),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              image != null
                  ? GestureDetector(
                      onTap: () => selectImage(),
                      child: SizedBox(
                        width: double.infinity,
                        height: 150,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(
                            image!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    )
                  : GestureDetector(
                      onTap: () => selectImage(),
                      child: DottedBorder(
                        color: AppPallete.borderColor,
                        dashPattern: const [
                          10,
                          4,
                        ],
                        radius: const Radius.circular(10),
                        borderType: BorderType.RRect,
                        strokeCap: StrokeCap.round,
                        child: SizedBox(
                          height: 150,
                          width: double.infinity,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.add_a_photo,
                                size: 40,
                              ),
                              Gap(20),
                              Text(
                                'Select a Image',
                                style: TextStyle(fontSize: 15),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
              Gap(20),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    "Technology",
                    "Science",
                    "Buisness",
                    "Programming",
                    "Entertainment",
                  ].map((e) {
                    return Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: GestureDetector(
                        onTap: () {
                          if (selectedTopics.contains(e)) {
                            selectedTopics.remove(e);
                          } else {
                            selectedTopics.add(e);
                          }
                          setState(() {});
                        },
                        child: Chip(
                          label: Text(e),
                          color: selectedTopics.contains(e)
                              ? WidgetStatePropertyAll(
                                  AppPallete.gradient1,
                                )
                              : WidgetStatePropertyAll(
                                  AppPallete.backgroundColor),
                          side: selectedTopics.contains(e)
                              ? null
                              : BorderSide(
                                  color: AppPallete.borderColor,
                                ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              Gap(20),
              BlogEditor(controller: titleController, hintText: 'Blog title'),
              Gap(10),
              BlogEditor(
                  controller: contentController, hintText: 'Blog content'),
            ],
          ),
        ),
      ),
    );
  }
}
