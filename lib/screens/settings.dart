import 'package:flutter/material.dart';
import 'package:flutterotica/env/global.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool historyEnabled = prefsFunctions.getHistoryEnabled();

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              CheckboxListTile(
                title: const Text("History Enabled"),
                secondary: const Icon(Icons.history),
                value: prefsFunctions.getHistoryEnabled(),
                onChanged: (bool? newValue) {
                  setState(() {
                    prefsFunctions.setHistoryEnabled(newValue ?? false);
                  });
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
