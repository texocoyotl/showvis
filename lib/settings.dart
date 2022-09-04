import 'package:flutter/material.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(children: [
        Card(
          child: ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About'),
            onTap: () => showAboutDialog(
                context: context,
                applicationName: 'ShowVis',
                applicationVersion: '1.0.0',
                applicationIcon: Image.asset(
                  'assets/logo.png',
                  height: 80,
                ),
                children: [
                  const Center(
                    child: Text('by Benjamin Molina'),
                  )
                ]),
          ),
        ),
      ]),
    );
  }
}
