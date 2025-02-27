import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../auth/auth_service.dart';
import '../constants/button2.dart';
import '../constants/colors.dart';
import '../constants/navigationBar.dart';
import '../constants/sizes.dart';

class ZugangsdatenPage extends StatefulWidget {
  const ZugangsdatenPage({super.key});

  @override
  State<ZugangsdatenPage> createState() => _ZugangsdatenPageState();
}

class _ZugangsdatenPageState extends State<ZugangsdatenPage> {
  TextEditingController neuEmailinputcontroller = TextEditingController();
  TextEditingController altEmailinputcontroller = TextEditingController();
  TextEditingController neuPasswortinputcontroller = TextEditingController();
  TextEditingController altPasswortinputcontroller = TextEditingController();
  bool _showPasswordHint = false;
  bool _isPassword = false;
  String? currentUserEmail;
  String? currentUserPendingEmail;

  Future<void> _updateCredentials() async {
    final authService = AuthService();
    final String oldEmail = altEmailinputcontroller.text.trim();
    final String newEmail = neuEmailinputcontroller.text.trim();
    final String oldPassword = altPasswortinputcontroller.text.trim();
    final String newPassword = neuPasswortinputcontroller.text.trim();

    final bool changeEmail = newEmail.isNotEmpty && oldEmail.isNotEmpty;
    final bool changePassword = newPassword.isNotEmpty && oldPassword.isNotEmpty;

    if (!changeEmail && !changePassword) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Bitte neue Zugangsdaten eingeben!")));
      return;
    }

    try {
      if (changeEmail) {
        await authService.changeEmail(newEmail);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("E-Mail erfolgreich geändert!")));
      }

      if (changePassword) {
        await authService.changePassword(oldPassword, newPassword);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Passwort erfolgreich geändert!")));
      }

      if (changePassword) {
        authService.signOut();
        Navigator.pushReplacementNamed(context, '/');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Fehler: ${e.toString()}")));
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchUserEmails();
  }

  Future<void> _fetchUserEmails() async {
    final authService = AuthService();
    final email = await authService.getCurrentUserEmail();
    final pendingEmail = await authService.getCurrentUserPendingEmail();
    setState(() {
      currentUserEmail = email;
      currentUserPendingEmail = pendingEmail;
    });
  }

  @override
  Widget build(BuildContext context) {
    Sizes.initialize(context);
    bool emailChangeDisabled = currentUserPendingEmail != null && currentUserPendingEmail!.isNotEmpty;

    return Scaffold(
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 2,
        onTap: (index) => Navigator.pushNamed(context, ['/home', '/fahrten', '/profil'][index]),
      ),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Zugangsdaten ändern', style: TextStyle(fontSize: Sizes.textHeading)),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.only(top: Sizes.paddingBig, left: Sizes.paddingSmall, right: Sizes.paddingSmall),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: background_box_white,
              borderRadius: BorderRadius.circular(Sizes.borderRadius),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.all(Sizes.paddingSmall),
                  child: Text("E-Mail Adresse:", style: TextStyle(color: dark_blue, fontSize: Sizes.textSubheading)),
                ),
                if (emailChangeDisabled) ...[
                  Padding(
                    padding: EdgeInsets.all(Sizes.paddingSmall),
                    child: Text(
                      "Ihre neue E-Mail wartet auf Bestätigung: $currentUserPendingEmail",
                      style: TextStyle(color: Colors.grey, fontSize: Sizes.textSubText),
                    ),
                  ),
                ] else ...[
                  Padding(
                    padding: EdgeInsets.all(Sizes.paddingSmall),
                    child: TextField(
                      controller: altEmailinputcontroller,
                      decoration: InputDecoration(
                        labelText: "alte E-Mail Adresse",
                        prefixIcon: Icon(FontAwesomeIcons.envelope),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(Sizes.paddingSmall),
                    child: TextField(
                      controller: neuEmailinputcontroller,
                      decoration: InputDecoration(
                        labelText: "neue E-Mail Adresse",
                        prefixIcon: Icon(FontAwesomeIcons.envelope),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
                Padding(
                  padding: EdgeInsets.all(Sizes.paddingSmall),
                  child: Text("Passwort:", style: TextStyle(color: dark_blue, fontSize: Sizes.textSubheading)),
                ),
                Padding(
                  padding: EdgeInsets.all(Sizes.paddingSmall),
                  child: TextField(
                    controller: altPasswortinputcontroller,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "altes Passwort",
                      labelStyle: TextStyle(color: dark_blue),
                      prefixIcon: Icon(FontAwesomeIcons.lock),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(Sizes.paddingSmall),
                  child: TextField(
                    controller: neuPasswortinputcontroller,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "neues Passwort",
                      labelStyle: TextStyle(color: dark_blue),
                      prefixIcon: Icon(FontAwesomeIcons.key),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (text) {
                      setState(() {
                        _showPasswordHint = text.isNotEmpty && text.length < 8;
                      });
                    },
                  ),
                ),
                if (_showPasswordHint)
                  Padding(
                    padding: EdgeInsets.all(Sizes.paddingSmall),
                    child: Text("Das Passwort muss mindestens 8 Zeichen lang sein!", style: TextStyle(color: text_error, fontSize: Sizes.textSubText)),
                  ),
                Padding(
                  padding: EdgeInsets.all(Sizes.paddingSmall),
                  child: CustomButton2(
                    label: 'Speichern',
                    onPressed: _updateCredentials,
                    color: button_blue,
                    textColor: Colors.white,
                    width: MediaQuery.of(context).size.width * 0.925,
                    height: MediaQuery.of(context).size.width * 0.12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
