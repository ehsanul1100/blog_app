import 'dart:io';

import 'package:blog_app/core/error/exceptions.dart';
import 'package:blog_app/features/blog/data/models/blog_models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract interface class BlogRemoteDataSource {
  Future<BlogModel> uploadBlog(BlogModel blog);
  Future<String> uploadBlogImage({
    required File image,
    required BlogModel blog,
  });
  Future<List<BlogModel>> getAllBlogs();
}

class BlogRemoteDataSourceImpl implements BlogRemoteDataSource {
  final FirebaseFirestore firebaseFirestore;

  BlogRemoteDataSourceImpl({required this.firebaseFirestore});

  @override
  Future<BlogModel> uploadBlog(BlogModel blog) async {
    try {
      await firebaseFirestore
          .collection('blogs')
          .doc(blog.id)
          .set(blog.toJson());
      return blog;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<String> uploadBlogImage({
    required File image,
    required BlogModel blog,
  }) async {
    try {
      return 'images/blog_image.jpg';
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<BlogModel>> getAllBlogs() async {
    try {
      final blogs = await firebaseFirestore.collection('blogs').get();
      final List<QueryDocumentSnapshot<Map<String, dynamic>>> blogsData =
          blogs.docs;
      return blogsData
          .map(
            (blog) =>
                BlogModel.fromJson(blog.data()).copyWith(posterName: 'Shihab'),
          )
          .toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
