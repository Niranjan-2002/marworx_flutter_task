import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:marworx_flutter_task/data_models/job.dart';

class JobProvider with ChangeNotifier {
  final CollectionReference jobsRef = FirebaseFirestore.instance.collection('jobs');

  List<Job> _jobs = [];
  List<Job> get jobs => _jobs;

  Future<void> fetchJobs() async {
    final snapshot = await jobsRef.get();
    _jobs = snapshot.docs.map((doc) => Job.fromMap(doc.id, doc.data() as Map<String, dynamic>)).toList();
    notifyListeners();
  }

  Future<void> addJob(Job job) async {
    await jobsRef.add(job.toMap());
    await fetchJobs();
  }

  Future<void> updateJob(Job job) async {
    await jobsRef.doc(job.id).update(job.toMap());
    await fetchJobs();
  }

  Future<void> deleteJob(String jobId) async {
    await jobsRef.doc(jobId).delete();
    await fetchJobs();
  }

  Future<void> applyForJob(String jobId, String userId) async {
    User? user = FirebaseAuth.instance.currentUser;
    await jobsRef.doc(jobId).update({
      'applicants': FieldValue.arrayUnion([
        {"resume": userId, "userEmail": user?.email ?? "", "uid": user?.uid}
      ])
    });
    await fetchJobs();
  }
}
