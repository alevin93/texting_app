import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:provider/provider.dart';
import '../providers/chat_provider.dart';
import './conversation_detail_screen.dart';

class ConversationsListScreen extends StatefulWidget {
  @override
  _ConversationsListScreenState createState() =>
      _ConversationsListScreenState();
}

class _ConversationsListScreenState extends State<ConversationsListScreen> {
  final FlutterBlue _flutterBlue = FlutterBlue.instance;

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Conversations'),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: (value) async {
              switch (value) {
                case 'General':
                  // Handle general settings
                  break;
                case 'Connect to a Device':
                  List<ScanResult> scanResults = [];

                  // Start scanning
                  _flutterBlue.startScan(timeout: Duration(seconds: 4));

                  // Listen to scan results
                  _flutterBlue.scanResults.listen((results) {
                    for (ScanResult r in results) {
                      setState(() {
                        scanResults.add(r);
                      });
                    }
                  });

                  // Show dialog with list of devices
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text('Select a device to connect'),
                      content: Container(
                        width: double.maxFinite,
                        child: ListView.builder(
                          itemCount: scanResults.length,
                          itemBuilder: (ctx, index) {
                            ScanResult result = scanResults[index];
                            return ListTile(
                              title: Text(result.device.name),
                              onTap: () async {
                                await result.device.connect();
                                Navigator.of(ctx).pop();
                                // Perform additional operations on the connected device
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  );

                  // Stop scanning
                  _flutterBlue.stopScan();
                  break;
                case 'Chat':
                  // Handle chat settings
                  break;
              }
            },
            itemBuilder: (BuildContext context) {
              return {'General', 'Connect to a Device', 'Chat'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: chatProvider.chats.length,
        itemBuilder: (ctx, index) {
          final conversationId = chatProvider.chats.keys.elementAt(index);
          final conversation = chatProvider.chats[conversationId];

          return ListTile(
            title: Text(conversationId),
            subtitle: Text(conversation!.last.content),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => ConversationDetailScreen(conversationId),
                ),
              );
            },
          );
        },
      ),
    );
  }
}