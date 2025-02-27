import 'package:carpooling_app/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:carpooling_app/constants/navigationBar.dart';
import 'package:carpooling_app/constants/sizes.dart';

import 'faq_detail.dart';

List<Map<String,dynamic>> faq_inhalt = [
  {
    "question": "Wie kann ich eine Fahrt anbieten?",
    "answer": "Gehe auf die HomePage und gebe dort Start und Ziel deiner Fahrt in das jeweilige Kästchen. Gebe auch an, wann du losfahren möchtest, indem Kästchen mit dem Zeitpunkt. Wähle bei der Option Anbieten oder Suchen, Anbieten aus und betätige auf den Start Button."
  },
  {
    "question": "Wie suche ich Fahrten?",
    "answer": "Gehe auf die HomePage und gebe dort Start und Ziel deiner Fahrt in das jeweilige Kästchen. Gebe auch an, wann du mitgenommen werden möchtest, indem Kästchen mit dem Zeitpunkt. Wähle bei der Option Anbieten oder Suchen, Suchen aus und betätige auf den Start Button."
  },
  {
    "question": "Wie kann ich Feedback vergeben?",
    "answer": "Nach der Fahrt erscheint die Option. Momentan ist es nicht möglich im Nachhinein Feedback zu geben."
  },
  {
    "question": "Wo sehe ich meine Fahrten?",
    "answer": "Wenn du Fahrten ausählst, kannst du alle deine Fahrten sehen. Die bei denen du selber fährst, und die bei denen du Mitfahrer*in bist, werden dir dort angezeigt. Du kannst dort auch filtern, und dir nur die anzeigen lassen, bei denen du mitfährst, oder die, bei denen du der Fahrer bist. Sie sind außerdem nach Datum sortiert."
  },
  {
    "question": "Wo sehe ich meine Fahrten?",
    "answer": "Wenn du Fahrten ausählst, kannst du alle deine Fahrten sehen. Gehe auf die Fahrt die du löschen willst. Damit du diese leichter findest, kannst du die Fahrten filtern, in dem du auf Fahrer*in / Mitfahrer*in gehst. Die Fahrten sind außerdem nach Datum sortiert. Wähle nun die Fahrt aus, die du nichtmehr antreten willst. Oben rechts findest du den Löschbutton."
  },

];

class FaqsPage extends StatefulWidget {
  const FaqsPage({super.key});

  @override
  _FaqsPageState createState() => _FaqsPageState();
}

class _FaqsPageState extends State<FaqsPage> {
  // Navigation bar index
  int _currentIndex = 2;

  void _onTabTapped(int index) {

    setState(() {
      _currentIndex = index;
    });

    // Navigation zu den entsprechenden Seiten basierend auf dem Index
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
    return SafeArea(
      bottom: false,
      top: false,
      child: Scaffold(
        bottomNavigationBar: CustomBottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onTabTapped,
        ),


        appBar: AppBar( //header
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context); // Zurück-Navigation
            },
          ),
          title: Text(
            'FAQ',
            style: TextStyle(color: dark_blue, fontSize: Sizes.textHeading, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),


        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: Sizes.paddingRegular),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                child: Center(
                  child: SvgPicture.asset(
                    'assets/images/undraw_faq.svg',
                    width: Sizes.deviceWidth,
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              SizedBox(height: Sizes.paddingRegular),
              ...faq_inhalt.map((entry) {
                return Padding(
                  padding: EdgeInsets.only(bottom: Sizes.paddingSmall),
                  child: Container(
                    decoration: BoxDecoration(
                      color: background_box_white,
                      borderRadius: BorderRadius.circular(Sizes.borderRadius),
                    ),
                    child: ListTile(
                      title: Text(entry["question"],style: TextStyle(fontSize: Sizes.textNormal),),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FaqDetailPage(
                              question: entry["question"],
                              answer: entry["answer"],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              }),
            ],
          ),
        ),

      ),
    );
  }
}
/*
              child: Align(
                alignment: Alignment.topCenter, // Oben bündig, horizontal zentriert
                child: Container(
                  decoration: BoxDecoration(
                    color: background_box_white,
                    borderRadius: BorderRadius.circular(Sizes.borderRadius),
                  ),
                  padding: EdgeInsets.symmetric(vertical: Sizes.paddingRegular), // Innenabstand für die Liste
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: faq_inhalt.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(faq_inhalt[index]["question"]),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FaqDetailPage(
                                question: faq_inhalt[index]["question"],
                                answer: faq_inhalt[index]["answer"],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    separatorBuilder: (context, index) => Divider(),
                  ),
                ),
                ),
              ),

          ],
        ),
      ),
    );
  }
}

class FaqsTile extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const FaqsTile({
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(title, style: TextStyle(fontSize: Sizes.textSubheading)),
          trailing: Icon(Icons.arrow_forward_ios, size: Sizes.textSubheading,),
          onTap: onTap,
        ),
      ],
    );
  }
}
*/
/*
void main() => runApp(MaterialApp(
  debugShowCheckedModeBanner: false,
  home: FaqsPage(),
  routes: {
    '/home': (context) => HomeScreen(), // Definiere deine Seiten hier
    '/fahrten': (context) => FahrtenScreen(),
    '/profil': (context) => ProfilScreen(),
    '/personal': (context) => PersonalScreen(),
    '/car_details': (context) => CarDetailsScreen(),
    '/account': (context) => AccountScreen(),
    '/search_faqs': (context) => SearchFaqsScreen(),
  },
)); */
