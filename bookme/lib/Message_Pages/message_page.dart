import 'package:flutter/material.dart';
import 'package:bookme/crud.dart'; // Ensure this import points to your actual CRUD class
import 'appointment_page.dart'; // Make sure this import points to your actual AppointmentPage class
import 'package:cloud_firestore/cloud_firestore.dart';

class MessagePage extends StatefulWidget {
  final String chatRoomId;
  final String contactName;

  const MessagePage({
    Key? key,
    required this.chatRoomId,
    required this.contactName,
  }) : super(key: key);

  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  List<Map<String, dynamic>> messages = []; // List to store messages
  TextEditingController messageController = TextEditingController();
  final CRUD _crud = CRUD();
  bool showAppointmentButtons =
      false; // To control the visibility of appointment buttons

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  void _loadMessages() async {
    var fetchedMessages = await _crud.getMessageList(widget.chatRoomId);
    setState(() {
      messages = fetchedMessages;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.contactName}\'s Chat Room'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(messages[index]['text']),
                  subtitle: Text(
                      'Sent at: ${messages[index]['timestamp'].toDate().toString()}'),
                );
              },
            ),
          ),
          if (showAppointmentButtons) // Show buttons conditionally
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        messages.add({
                          "text": "Appointment Approved",
                          "timestamp": Timestamp.now()
                        });
                        showAppointmentButtons =
                            false; // Hide the buttons after action
                      });
                    },
                    child: const Text('Approve'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        messages.add({
                          "text": "Appointment Rejected",
                          "timestamp": Timestamp.now()
                        });
                        showAppointmentButtons =
                            false; // Hide the buttons after action
                      });
                    },
                    child: const Text('Reject'),
                  ),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 20),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: const InputDecoration(
                      labelText: 'Type a message',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => _sendMessage(),
                  child: const Text('Send'),
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
          ),
        ],
      ),
    );
  }

  void _sendMessage() async {
    if (messageController.text.isNotEmpty) {
      await _crud.sendMessage(widget.chatRoomId, messageController.text);
      messageController.clear();
      _loadMessages(); // Reload the message list to include the new message
    }
  }

  void addAppointmentDetails(String details) {
    setState(() {
      messages.add({"text": details, "timestamp": Timestamp.now()});
      showAppointmentButtons = true; // Show the buttons after appointment added
    });
  }
}
