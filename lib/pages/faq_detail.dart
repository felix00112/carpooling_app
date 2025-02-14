import 'package:carpooling_app/constants/colors.dart';
import 'package:carpooling_app/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../constants/navigationBar.dart'; // Custom Bottom Navigation Bar importieren

class FaqDetailPage extends StatefulWidget {
  final String question;
  final String answer;

  const FaqDetailPage({
    required this.question,
    required this.answer,
    super.key,
  });

  @override
  _FaqDetailPageState createState() => _FaqDetailPageState();
}

class _FaqDetailPageState extends State<FaqDetailPage> {
  int _currentIndex = 1;

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/home');
        break;
      case 1:
        Navigator.pushNamed(context, '/fahrten');
        break;
      case 2:
        Navigator.pushNamed(context, '/profil');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    Sizes.initialize(context);
    return Scaffold(
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
      appBar: AppBar(
        backgroundColor: background_grey,
        elevation: 0,
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/icons/arrowLeft.svg',
            height: 24,
            colorFilter: ColorFilter.mode(dark_blue, BlendMode.srcIn),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          widget.question,
          style: TextStyle(color: dark_blue),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Sizes.borderRadius10),
            ),
            child: Center(
              child: SvgPicture.asset(
                'assets/images/undraw_faq.svg',
                width: 150,
                height: 150,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text( //Überschrift
                    widget.question,
                    style: TextStyle(
                      color: dark_blue,
                      fontSize: Sizes.textSizeMedium,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: Sizes.paddingSmall), // Abstand zur Antwort-Box
                  Container( //Antwort
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Sizes.borderRadius10),
                      color: background_box_white,
                    ),
                    padding: const EdgeInsets.all(Sizes.paddingMediumLarge), // Innenabstand für bessere Lesbarkeit
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        FaqDetailTile(
                          answ: widget.answer,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }
}

class FaqDetailTile extends StatelessWidget {
  //final String quest;
  final String answ;

  const FaqDetailTile({
    //required this.quest,
    required this.answ,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          //title: Text(quest, style: TextStyle(fontSize: Sizes.textSizeMedium)),
          title: Text(answ, style: TextStyle(color: dark_blue,fontSize: Sizes.textSizeRegular)),
        ),
      ],
    );
  }
}
