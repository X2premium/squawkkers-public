import 'dart:async';

import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:squawker/constants.dart';
import 'package:squawker/generated/l10n.dart';
import 'package:squawker/settings/_about.dart';
import 'package:squawker/settings/_account.dart';
import 'package:squawker/settings/_data.dart';
import 'package:squawker/settings/_general.dart';
import 'package:squawker/settings/_home.dart';
import 'package:squawker/settings/_theme.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pref/pref.dart';

class SettingsScreen extends StatefulWidget {
  final String? initialPage;

  const SettingsScreen({Key? key, this.initialPage}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  PackageInfo _packageInfo = PackageInfo(appName: '', packageName: '', version: '', buildNumber: '');
  String _legacyExportPath = '';

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      var packageInfo = await PackageInfo.fromPlatform();

      setState(() {
        _packageInfo = packageInfo;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var appVersion = 'v${_packageInfo.version}+${_packageInfo.buildNumber}';
    bool navigationAnimationsEnabled = PrefService.of(context).get(optionNavigationAnimations);
    Widget settingsTile({required String title, required IconData icon, required VoidCallback onTap}) {
      return Card(
        child: ListTile(
          title: Text(title),
          leading: Icon(icon),
          trailing: const Icon(Symbols.chevron_right_rounded),
          onTap: onTap,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(L10n.of(context).settings)),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          settingsTile(
            title: L10n.of(context).general,
            icon: Symbols.settings,
            onTap: () => Navigator.push(
              context,
              navigationAnimationsEnabled
                ? MaterialPageRoute(builder: (context) => const SettingsGeneralFragment())
                : PageRouteBuilder(pageBuilder: (context, anim1, anim2) => const SettingsGeneralFragment()),
            ),
          ),
          settingsTile(
            title: L10n.of(context).account,
            icon: Symbols.account_circle_rounded,
            onTap: () => Navigator.push(
              context,
              navigationAnimationsEnabled
                ? MaterialPageRoute(builder: (context) => const SettingsAccountFragment())
                : PageRouteBuilder(pageBuilder: (context, anim1, anim2) => const SettingsAccountFragment()),
            ),
          ),
          settingsTile(
            title: L10n.of(context).home,
            icon: Symbols.home,
            onTap: () => Navigator.push(
              context,
              navigationAnimationsEnabled
                ? MaterialPageRoute(builder: (context) => const SettingsHomeFragment())
                : PageRouteBuilder(pageBuilder: (context, anim1, anim2) => const SettingsHomeFragment()),
            ),
          ),
          settingsTile(
            title: L10n.of(context).theme,
            icon: Symbols.palette,
            onTap: () => Navigator.push(
              context,
              navigationAnimationsEnabled
                ? MaterialPageRoute(builder: (context) => const SettingsThemeFragment())
                : PageRouteBuilder(pageBuilder: (context, anim1, anim2) => const SettingsThemeFragment()),
            ),
          ),
          settingsTile(
            title: L10n.of(context).data,
            icon: Symbols.storage,
            onTap: () => Navigator.push(
              context,
              navigationAnimationsEnabled
                ? MaterialPageRoute(builder: (context) => SettingsDataFragment(legacyExportPath: _legacyExportPath))
                : PageRouteBuilder(pageBuilder: (context, anim1, anim2) => SettingsDataFragment(legacyExportPath: _legacyExportPath)),
            ),
          ),
          settingsTile(
            title: L10n.of(context).about,
            icon: Symbols.info,
            onTap: () => Navigator.push(
              context,
              navigationAnimationsEnabled
                ? MaterialPageRoute(builder: (context) => SettingsAboutFragment(appVersion: appVersion))
                : PageRouteBuilder(pageBuilder: (context, anim1, anim2) => SettingsAboutFragment(appVersion: appVersion)),
            ),
          ),
        ],
      ),
    );
  }
}
