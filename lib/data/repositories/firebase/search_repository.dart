import 'package:cloud_firestore/cloud_firestore.dart';

abstract class SearchRepository {
  Future<String> addSearchHistory(String userId, String query);
  Future<List<String>> getSearchHistory(String userId);
  Future<void> deleteSearchHistory(String userId, String searchHistory);
}

class SearchRepositoryImpl implements SearchRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<String> addSearchHistory(String userId, String query) async {
    final searchHistoryRef = _firestore
        .collection('user')
        .doc(userId)
        .collection('searchHistory')
        .doc(query);

    final snapshot = await searchHistoryRef.get();

    if (snapshot.exists) {
      await searchHistoryRef.update({
        'timestamp': FieldValue.serverTimestamp(),
      });
    } else {
      await searchHistoryRef.set({
        'query': query,
        'timestamp': FieldValue.serverTimestamp(),
      });
    }

    return query;
  }

  @override
  Future<List<String>> getSearchHistory(String userId) async {
    final snapshot = await _firestore
        .collection('user')
        .doc(userId)
        .collection('searchHistory')
        .orderBy('timestamp', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      return doc.data()['query'] as String;
    }).toList();
  }

  @override
  Future<void> deleteSearchHistory(String userId, String searchHistory) async {
    final searchHistoryRef = _firestore
        .collection('user')
        .doc(userId)
        .collection('searchHistory')
        .doc(searchHistory);

    await searchHistoryRef.delete();
  }
}
