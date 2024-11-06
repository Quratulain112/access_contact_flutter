import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Contact> contactlist = [];
  Future<void> fetchContacts() async {
    var result = await FlutterContacts.getContacts();
    setState(() {
      contactlist = result;
    });
  }

  Future<void> requestContact() async {
    var status = await Permission.contacts.status;
    if (status.isDenied) {
      PermissionStatus perstatus = await Permission.contacts.request();
      if (perstatus.isGranted) {
        fetchContacts();
      } else if (perstatus.isPermanentlyDenied) {
        print("Not allowed");
      }
    } else if (status.isGranted) {
      fetchContacts();
    }
  }

  @override
  void initState() {
    requestContact();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: Text("Access contacts"),
          ),
          body: Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(15),
                  child: SearchBar(),
                ),
                Expanded(
                    child: ListView.builder(
                        itemCount: contactlist.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(contactlist[index].displayName),
                          );
                        }))
              ],
            ),
          )),
    );
  }
}
