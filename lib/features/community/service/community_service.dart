import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../model/post_model.dart';
import '../model/comment_model.dart';

class CommunityService {
  final FirebaseFirestore _firestore;
  final SupabaseClient _supabase;

  CommunityService({
    FirebaseFirestore? firestore,
    SupabaseClient? supabase,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _supabase = supabase ?? Supabase.instance.client;

  /// Live stream of all posts, newest first.
  Stream<List<Post>> streamPosts() {
    return _firestore
        .collection('posts')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Post.fromMap(doc.id, doc.data()))
            .toList());
  }

  /// Uploads an image file to Supabase's forum-images bucket and
  /// returns its public URL.
  Future<String> uploadPostImage(File imageFile, String uid) async {
    final fileName =
        '${uid}_${DateTime.now().millisecondsSinceEpoch}.jpg';

    await _supabase.storage.from('forum-images').upload(fileName, imageFile);

    return _supabase.storage.from('forum-images').getPublicUrl(fileName);
  }

  /// Creates a new post.
  Future<void> createPost({
    required String authorUid,
    required String authorName,
    required String text,
    String? imageUrl,
  }) async {
    final post = Post(
      id: '', // Firestore assigns this
      authorUid: authorUid,
      authorName: authorName,
      text: text,
      imageUrl: imageUrl,
      likesCount: 0,
      commentsCount: 0,
      createdAt: DateTime.now(),
    );

    await _firestore.collection('posts').add(post.toMap());
  }

  /// Deletes a post (only the author can do this, enforced by rules).
  Future<void> deletePost(String postId) async {
    await _firestore.collection('posts').doc(postId).delete();
  }

  /// Checks whether the current user has liked a given post.
  Future<bool> hasLiked({required String postId, required String uid}) async {
    final doc = await _firestore
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(uid)
        .get();
    return doc.exists;
  }

  /// Likes a post: creates the like document and increments the
  /// post's likesCount atomically.
  Future<void> likePost({required String postId, required String uid}) async {
    final postRef = _firestore.collection('posts').doc(postId);
    final likeRef = postRef.collection('likes').doc(uid);

    final batch = _firestore.batch();
    batch.set(likeRef, {'likedAt': DateTime.now()});
    batch.update(postRef, {'likesCount': FieldValue.increment(1)});
    await batch.commit();
  }

  /// Unlikes a post: removes the like document and decrements the
  /// post's likesCount atomically.
  Future<void> unlikePost({required String postId, required String uid}) async {
    final postRef = _firestore.collection('posts').doc(postId);
    final likeRef = postRef.collection('likes').doc(uid);

    final batch = _firestore.batch();
    batch.delete(likeRef);
    batch.update(postRef, {'likesCount': FieldValue.increment(-1)});
    await batch.commit();
  }

  /// Live stream of comments for a given post, oldest first (so
  /// the conversation reads top-to-bottom naturally).
  Stream<List<Comment>> streamComments(String postId) {
    return _firestore
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Comment.fromMap(doc.id, doc.data()))
            .toList());
  }

  /// Adds a comment and increments the post's commentsCount
  /// atomically.
  Future<void> addComment({
    required String postId,
    required String authorUid,
    required String authorName,
    required String text,
  }) async {
    final postRef = _firestore.collection('posts').doc(postId);
    final commentRef = postRef.collection('comments').doc();

    final comment = Comment(
      id: commentRef.id,
      authorUid: authorUid,
      authorName: authorName,
      text: text,
      createdAt: DateTime.now(),
    );

    final batch = _firestore.batch();
    batch.set(commentRef, comment.toMap());
    batch.update(postRef, {'commentsCount': FieldValue.increment(1)});
    await batch.commit();
  }
}