import 'package:flutter/material.dart';
import 'package:marworx_flutter_task/Services/firebase_auth_services.dart';
import 'package:marworx_flutter_task/providers/job_provider.dart';
import 'package:provider/provider.dart';

import 'job_detail_screen.dart';
import 'login_screen.dart';

class EmployDashboard extends StatefulWidget {
  const EmployDashboard({super.key});

  @override
  State<EmployDashboard> createState() => _EmployDashboardState();
}

class _EmployDashboardState extends State<EmployDashboard> {
  String _search = "";

  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    final jobProvider = Provider.of<JobProvider>(context);

 
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth > 600;
    final bool isDesktop = screenWidth > 1000;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Employee Dashboard",
          style: TextStyle(
            fontSize: isDesktop ? 26 : isTablet ? 22 : 18,
            fontWeight: FontWeight.bold,
          ),
        ),
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
      body: Column(
        children: [
          
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? 100 : isTablet ? 40 : 16,
              vertical: 16,
            ),
            child: TextFormField(
              decoration: InputDecoration(
                hintText: "Search jobs...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (val) => setState(() => _search = val.toLowerCase()),
            ),
          ),

        
          Expanded(
            child: FutureBuilder(
              future: jobProvider.fetchJobs(),
              builder: (context, snapshot) {
                final jobs = jobProvider.jobs
                    .where((j) => j.title.toLowerCase().contains(_search))
                    .toList();

                if (jobs.isEmpty) {
                  return const Center(
                      child: Text("No jobs found", style: TextStyle(fontSize: 16)));
                }

                return ListView.builder(
                  padding: EdgeInsets.symmetric(
                    horizontal: isDesktop ? 100 : isTablet ? 40 : 12,
                    vertical: 8,
                  ),
                  itemCount: jobs.length,
                  itemBuilder: (context, index) {
                    final job = jobs[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 3,
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: isDesktop ? 32 : isTablet ? 24 : 16,
                          vertical: isTablet ? 16 : 8,
                        ),
                        title: Text(
                          job.title,
                          style: TextStyle(
                            fontSize: isDesktop ? 22 : isTablet ? 18 : 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          job.location,
                          style: TextStyle(
                            fontSize: isDesktop ? 18 : isTablet ? 16 : 14,
                            color: Colors.grey[700],
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  JobDetailScreen(job: job, isAdmin: false),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
