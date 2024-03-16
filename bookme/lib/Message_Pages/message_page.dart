// message_page.dart
// ignore_for_file: library_private_types_in_public_api

import 'package:bookme/Message_Pages/appointment_page.dart';
import 'package:flutter/material.dart';

class MessagePage extends StatefulWidget {
  final int buttonNumber;
  final String contactName;

  const MessagePage(
      {super.key, required this.buttonNumber, required this.contactName});

  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  List<String> messages = []; // List to store messages
  TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.contactName}\'s Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Messages with ${widget.contactName}'),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8.0),
              ),
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  return Text(messages[index]);
                },
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration:
                        const InputDecoration(labelText: 'Type a message'),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    // Add the typed message to the list
                    setState(() {
                      messages.add(messageController.text);
                      messageController.clear(); // Clear the input field
                    });
                  },
                  child: const Text('Send'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    // Upload file logic
                    // You can implement the logic for file upload here
                  },
                  child: const Text('Upload File'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to the appointment creation page and pass the callback function
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AppointmentPage(onSave: addAppointmentDetails),
                      ),
                    );
                  },
                  child: const Text('Create Appointment'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void addAppointmentDetails(String details) {
    setState(() {
      messages.add(details);
    });
  }
}