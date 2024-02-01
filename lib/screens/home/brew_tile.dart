import 'package:brew_crew/models/brew.dart';
import 'package:flutter/material.dart';

import 'settings_form.dart';

class BrewTile extends StatelessWidget {
  final Brew brew;
  const BrewTile({
    super.key,
    required this.brew,
  });

  @override
  Widget build(BuildContext context) {
    void showSettingsPanel() {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 20.0,
                horizontal: 60.0,
              ),
              child: const SettingsForm(),
            ),
          );
        },
      );
    }

    return Container(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        onPressed: showSettingsPanel,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(8.0),
        ),
        child: ListTile(
          leading: CircleAvatar(
            radius: 25.0,
            backgroundColor: Colors.brown[brew.strength],
            backgroundImage: const AssetImage(
              'assets/coffee_icon.png',
            ),
          ),
          title: Text(brew.name),
          subtitle: Text('Takes ${brew.sugars} sugar(s)'),
        ),
      ),
    );
  }
}
