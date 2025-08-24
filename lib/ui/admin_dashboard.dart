import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:marworx_flutter_task/Services/firebase_auth_services.dart';
import 'package:marworx_flutter_task/providers/job_provider.dart';
import 'package:marworx_flutter_task/ui/job_detail_screen.dart';
import 'package:provider/provider.dart';

import 'login_screen.dart';
import 'edit_job_screen.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    final jobProvider = Provider.of<JobProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: "Logout",
            onPressed: () async {
              await _authService.logout();
              if (!mounted) return;
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
          ),
        ],
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
              return Slidable(
                key: ValueKey(job.id),

                endActionPane: ActionPane(
                  motion: const DrawerMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (context) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EditJobScreen(job: job),
                          ),
                        );
                      },
                      
                      foregroundColor: Colors.blue,
                      icon: Icons.edit,
                      label: 'Edit',
                    ),
                  SlidableAction(
  onPressed: (context) async {
    await showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text("Confirm Delete"),
        content: const Text(
            "Are you sure you want to delete this job?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext), 
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              await jobProvider.deleteJob(job.id);

              Navigator.pop(dialogContext);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Job deleted successfully"),
                ),
              );
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  },
  foregroundColor: Colors.red,
  icon: Icons.delete,
  label: 'Delete',
)

                  ],
                ),

                child: Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              JobDetailScreen(job: job, isAdmin: true),
                        ),
                      );
                    },
                    title: Text(job.title),
                    subtitle: Text(job.location),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const EditJobScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
