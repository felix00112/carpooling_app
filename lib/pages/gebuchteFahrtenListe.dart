import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../constants/colors.dart';
import 'package:carpooling_app/constants/sizes.dart';
import '../constants/navigationBar.dart'; // Import der NavigationBar

class GebuchteFahrtenListe extends StatefulWidget {
  const GebuchteFahrtenListe({super.key});

  @override
  _GebuchteFahrtenListeState createState() => _GebuchteFahrtenListeState();
}

class _GebuchteFahrtenListeState extends State<GebuchteFahrtenListe> with SingleTickerProviderStateMixin {
  ////////////////////Navigation bar/////////////////////
  int _currentIndex = 1; // Index für die aktuell ausgewählte Seite

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    // Navigation zu den entsprechenden Seiten basierend auf dem Index ist nicht mehr notwendig
  }
  /////////////////////////////////////////////////////////

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  //hier sind fahrten: die titel bzw dann auch datum und die fahrten in den tagen
  Map<String, List<String>> fahrten = {
    'Heute': ['Fahrt 1', 'Fahrt 2', 'Fahrt 3', 'Fahrt 4', 'Fahrt 5'],
    'Morgen': ['Fahrt 1', 'Fahrt 2', 'Fahrt 3'],
    'Übermorgen': ['Fahrt 1', 'Fahrt 2'],
    'Nächste Woche': ['Fahrt 1', 'Fahrt 2', 'Fahrt 3', 'Fahrt 4'],
  };

  void addFahrt(String tag, String fahrt) {
    setState(() {
      if (fahrten.containsKey(tag)) {
        fahrten[tag]?.add(fahrt);
      } else {
        fahrten[tag] = [fahrt];
      }
    });
  }

  void removeFahrt(String tag, String fahrt) {
    setState(() {
      if (fahrten.containsKey(tag)) {
        fahrten[tag]?.remove(fahrt);
        if (fahrten[tag]?.isEmpty ?? false) {
          fahrten.remove(tag);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Sizes.initialize(context);
    return Scaffold(
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),


      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: Sizes.paddingRegular), //allgemeiner Rand zwischen Inhalt und handyrand),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Header
            SizedBox( //bild
              //height: Sizes.topBarHeight,
              child: Center(
                child: SvgPicture.asset(
                  'assets/images/undraw_order_ride.svg',
                  width: Sizes.deviceWidth,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(height: Sizes.paddingRegular), // platz über überschrift
            Text( //Überschrift
              "Gebuchte Fahrten",
              style: TextStyle(
                fontSize: Sizes.textHeading,
                fontWeight: FontWeight.bold,
                color: dark_blue,
              ),
            ),
            SizedBox(height: Sizes.paddingBig), // platz unter überschrift
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Sizes.borderRadius), // Abgerundete Ecken
              ),
              elevation: 4, // Schatten für optische Tiefe
              child: Container(
                decoration: BoxDecoration( //Box aussehen
                  color: background_box_white,
                  borderRadius: BorderRadius.circular(Sizes.borderRadius),
                ),
                child: TabBar(
                  controller: _tabController,
                  tabs: [
                    Tab(text: 'Alle'),
                    Tab(text: 'Mitfahrer*in'),
                    Tab(text: 'Fahrer*in'),
                  ],
                  indicatorColor: button_blue,
                  labelStyle: TextStyle(fontSize: Sizes.textSubheading),
                  labelColor: button_blue, // Farbe des ausgewählten Tabs
                  unselectedLabelColor: text_sekundr, // Farbe der nicht ausgewählten Tabs
                ),
              ),
            ),
            SizedBox(height: Sizes.paddingRegular), // platz über den einzelnen Fahrten

            //Body
            Expanded(
              child: ListView.builder(
                physics: BouncingScrollPhysics(), // Optional für ein sanftes Scrollen
                itemCount: fahrten.entries.length,
                itemBuilder: (context, index) {
                  var entry = fahrten.entries.elementAt(index);
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Überschrift für den Tag (Heute, Morgen, ...)
                      Padding(
                        padding: EdgeInsets.only(bottom: Sizes.paddingRegular),
                        child: Text(
                          entry.key,
                          style: TextStyle(fontSize: Sizes.textNormal, fontWeight: FontWeight.bold),
                        ),
                      ),

                      // Liste der Fahrten für diesen Tag
                      ...entry.value.asMap().entries.map((fahrt) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: Sizes.paddingSmall),
                          child: Container(
                            decoration: BoxDecoration(
                              color: background_box_white,
                              borderRadius: BorderRadius.circular(Sizes.borderRadius),
                            ),
                            child: ListTile(
                              leading: Icon(Icons.directions_car, color: button_blue),
                              title: Text(
                                fahrt.value,
                                style: TextStyle(color: dark_blue, fontSize: Sizes.textNormal),
                              ),
                              subtitle: Text(
                                'Details zur ${fahrt.value}',
                                style: TextStyle(color: dark_blue, fontSize: Sizes.textSubText),
                              ),
                              trailing: Icon(Icons.arrow_forward_ios),
                              onTap: () {
                                // Aktion bei Klick auf eine Fahrt
                              },
                            ),
                          ),
                        );
                      }),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
/*
      body: Padding(
        padding: EdgeInsets.all(Sizes.paddingRegular), //allgemeiner Rand zwischen Inhalt und handyrand
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: Sizes.topBarHeight,
              child: Center(
                child: SvgPicture.asset(
                  'assets/images/undraw_order_ride.svg',
                  width: Sizes.deviceWidth,
                  //height: 700,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(height: Sizes.paddingRegular), // platz über überschrift
            Text(
              "Gebuchte Fahrten",
              style: TextStyle(
                fontSize: Sizes.textHeading,
                fontWeight: FontWeight.w900,
                color: dark_blue,
              ),
            ),

            SizedBox(height: Sizes.paddingBig), // platz unter überschrift
            Container(//Box: Alle, Mitfahrer*in, Fahrer*in
              decoration: BoxDecoration(
                color: background_box_white, // Hintergrundfarbe des Containers
                borderRadius: BorderRadius.circular(Sizes.borderRadius), // Abrundung der Ecken
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4.0,
                    spreadRadius: 1.0,
                    offset: Offset(0.0, 2.0),
                  ),
                ],
              ),

              child: TabBar(
                controller: _tabController,
                tabs: [
                  Tab(text: 'Alle'),
                  Tab(text: 'Mitfahrer*in'),
                  Tab(text: 'Fahrer*in'),
                ],
                indicatorColor: button_blue,
                labelStyle: TextStyle(fontSize: Sizes.textSubheading), // Text fett formatieren
                labelColor: button_blue, // Farbe des ausgewählten Tabs
                unselectedLabelColor: text_sekundr, // Farbe der nicht ausgewählten Tabs
              ),
            ),

            SizedBox(height: Sizes.paddingRegular), // platz über den einzelnen Fahrten
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Inhalt für den Tab 'Alle'
                  ListView(
                    children: fahrten.entries.map((entry) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            title: Text(entry.key, style: TextStyle(fontSize: Sizes.textNormal ,fontWeight: FontWeight.bold)),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: entry.value.length,
                            itemBuilder: (context, index) {
                              return Card(
                                margin: EdgeInsets.symmetric(vertical: Sizes.paddingSmall),
                                color: background_box_white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(Sizes.borderRadius), // Auch die ListTile abrunden
                                ),
                                //tileColor: background_box_white, // Hier wird die Hintergrundfarbe auf Rot gesetzt
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: Sizes.paddingSmall),
                                  child: ListTile(
                                      leading: Icon(Icons.directions_car, color: button_blue),
                                  title: Text(entry.value[index], style: TextStyle(color: dark_blue,fontSize: Sizes.textNormal),),
                                  subtitle: Text('Details zur ${entry.value[index]}', style: TextStyle(color: dark_blue,fontSize: Sizes.textSubText),),
                                  trailing: Icon(Icons.arrow_forward_ios),
                                  onTap: () {
                                    // Aktion bei Klick auf eine Fahrt
                                  },
                                  ),
                              ),
                              );
                            },
                          ),
                        ],
                      );
                    }).toList(),
                  ),


                  // Inhalt für den Tab 'Mitfahrer'
                  Center(
                    child: ElevatedButton(
                      onPressed: () {  },
                      child: Text('filtern die fahrten wo man gefahren wird.', style: TextStyle(color: dark_blue, fontSize: Sizes.textNormal),),
                    ),
                  ),



                  // Inhalt für den Tab 'Fahrer'
                  Center(
                    child: ElevatedButton(
                      onPressed: () {  },
                      child: Text('filtern die fahrten wo man fährt.', style: TextStyle(color: dark_blue, fontSize: Sizes.textNormal),),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
*/