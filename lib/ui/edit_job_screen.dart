import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:marworx_flutter_task/data_models/job.dart';
import 'package:marworx_flutter_task/providers/job_provider.dart';
import 'package:marworx_flutter_task/ui/admin_dashboard.dart';
import 'package:provider/provider.dart';


class EditJobScreen extends StatefulWidget {
  final Job? job;
  const EditJobScreen({super.key, this.job});

  @override
  State<EditJobScreen> createState() => _EditJobScreenState();
}

class _EditJobScreenState extends State<EditJobScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _locationController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.job?.title ?? "");
    _locationController = TextEditingController(text: widget.job?.location ?? "");
    _descriptionController = TextEditingController(text: widget.job?.description ?? "");
  }

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final jobProvider = Provider.of<JobProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.job == null ? "Add Job" : "Edit Job"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
             Card(
  margin: const EdgeInsets.all(16),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(16),
  ),
  elevation: 6,
  child: Padding(
    padding: const EdgeInsets.all(16),
    child: SingleChildScrollView(
      child: Column(
        children: [
          TextFormField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: "Job Title",
              prefixIcon: const Icon(Icons.work_outline, color: Colors.blueAccent),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
              ),
            ),
            validator: (val) =>
                val == null || val.isEmpty ? "Enter job title" : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _locationController,
            decoration: InputDecoration(
              labelText: "Location",
              prefixIcon: const Icon(Icons.location_on, color: Colors.green),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.green, width: 2),
              ),
            ),
            validator: (val) =>
                val == null || val.isEmpty ? "Enter location" : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _descriptionController,
            decoration: InputDecoration(
              labelText: "Description",
              prefixIcon: const Icon(Icons.description, color: Colors.orange),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.orange, width: 2),
              ),
            ),
            maxLines: 3,
            validator: (val) =>
                val == null || val.isEmpty ? "Enter description" : null,
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity, 
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                foregroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final job = Job(
                    id: widget.job?.id ??
                        DateTime.now().millisecondsSinceEpoch.toString(),
                    title: _titleController.text,
                    location: _locationController.text,
                    description: _descriptionController.text,
                    applicants: widget.job?.applicants ?? [],
                    createdBy: widget.job?.createdBy ??
                        FieldValue.serverTimestamp().toString(),
                  );

                  if (widget.job == null) {
                    await jobProvider.addJob(job);

                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>AdminDashboard()));
                  } else {
                    await jobProvider.updateJob(job);

                                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>AdminDashboard()));

                  }

                  if (!mounted) return;
                  Navigator.pop(context);
                }
              },
              child: Text(
                widget.job == null ? "Add Job" : "Update Job",
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
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
