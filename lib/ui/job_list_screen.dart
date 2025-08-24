import 'package:flutter/material.dart';
import 'package:marworx_flutter_task/providers/job_provider.dart';
import 'package:provider/provider.dart';
import 'job_detail_screen.dart';

class JobListScreen extends StatelessWidget {
  final bool isAdmin;

  const JobListScreen({super.key, required this.isAdmin});

  @override
  Widget build(BuildContext context) {
    final jobProvider = Provider.of<JobProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(isAdmin ? "Manage Jobs" : "Available Jobs"),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: jobProvider.fetchJobs(),
        builder: (context, snapshot) {
          final jobs = jobProvider.jobs;

          if (jobs.isEmpty) {
            return const Center(child: Text("No jobs available"));
          }

          return ListView.builder(
            itemCount: jobs.length,
            itemBuilder: (context, index) {
              final job = jobs[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  title: Text(job.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(job.location),
                  trailing: isAdmin
                      ? IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            jobProvider.deleteJob(job.id);
                          },
                        )
                      : const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => JobDetailScreen(job: job, isAdmin: isAdmin),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
