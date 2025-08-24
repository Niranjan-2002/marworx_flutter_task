import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:marworx_flutter_task/data_models/job.dart';
import 'package:marworx_flutter_task/providers/job_provider.dart';
import 'package:marworx_flutter_task/ui/employ_dashboard.dart';
import 'package:provider/provider.dart';

class JobDetailScreen extends StatelessWidget {
  const JobDetailScreen({super.key, required this.job, required this.isAdmin});

  final bool isAdmin;
  final Job job;
  

  void _showApplyDialog(BuildContext context) {
    final resumeController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Apply for Job"),
          content: TextField(
            controller: resumeController,
            decoration: const InputDecoration(
              labelText: "Enter resume link or text",
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          actions: [
TextButton(
  style: TextButton.styleFrom(
    foregroundColor: Colors.redAccent,
  ),
  onPressed: () => Navigator.pop(context),
  child: const Text("Cancel"),
),

            ElevatedButton( 
              style: ElevatedButton.styleFrom(
  
    foregroundColor: Colors.greenAccent,),
              onPressed: () {
                Provider.of<JobProvider>(context, listen: false)
                    .applyForJob(job.id, resumeController.text);
                
   Navigator.push(context, MaterialPageRoute(builder: (context)=>EmployDashboard()));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Applied successfully!")),
                );
              },
              child: const Text("Submit"),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth > 600;
    final bool isDesktop = screenWidth > 1000;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          job.title,
          style: TextStyle(
            fontSize: isDesktop ? 26 : isTablet ? 22 : 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: isDesktop ? 200 : isTablet ? 60 : 16,
            vertical: 20,
          ),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 4,
            child: Padding(
              padding: EdgeInsets.all(isDesktop ? 32 : isTablet ? 24 : 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                 
                  Text(
                    job.title,
                    style: TextStyle(
                      fontSize: isDesktop ? 28 : isTablet ? 24 : 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

               
                  Text(
                    job.location,
                    style: TextStyle(
                      fontSize: isDesktop ? 18 : isTablet ? 16 : 14,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 16),

                  
                  Text(
                    job.description,
                    style: TextStyle(
                      fontSize: isDesktop ? 18 : isTablet ? 16 : 15,
                    ),
                  ),
                  const SizedBox(height: 24),

                  
                  if (isAdmin) ...[
                    const Text(
                      "Applicants:",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    job.applicants.isEmpty
                        ? const Text("No applicants yet")
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: job.applicants.length,
                            itemBuilder: (context, index) {
                              final applicant =
                                  job.applicants[index]["userEmail"];
                              return Card(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 6, horizontal: 0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ListTile(
                                  leading: const Icon(Icons.person),
                                  title: Text(applicant),
                                ),
                              );
                            },
                          ),
                  ],

                  
                  if (!isAdmin)
                    Center(
                      child:ElevatedButton.icon(
  style: ElevatedButton.styleFrom(
    foregroundColor: Colors.white, 
    backgroundColor: Colors.lightGreen,
    padding: EdgeInsets.symmetric(
      horizontal: isDesktop ? 40 : 24,
      vertical: isTablet ? 16 : 12,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
  icon: const Icon(Icons.send),
  label: Text(
    "Apply Now",
    style: TextStyle(
      fontSize: isDesktop ? 18 : 16,
      fontWeight: FontWeight.w600,
    ),
  ),
  onPressed: () {
    final String currentUid = FirebaseAuth.instance.currentUser!.uid;

    bool isApplicant = job.applicants
        .any((applicant) => applicant["uid"] == currentUid);

    if (!isApplicant) {
      _showApplyDialog(context);
      
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("You have already applied for this job")),
      );
      Navigator.pop(context);
    }
    
  },
)

                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
