import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';
import 'package:implicitly_animated_reorderable_list/transitions.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:provider/provider.dart';

import '../provider/newsModel.dart';
import '../widget/news_web_view.dart';

class NewsSearchScreen extends StatefulWidget {
  @override
  _NewsSearchScreenState createState() => _NewsSearchScreenState();
}

class _NewsSearchScreenState extends State<NewsSearchScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NewsModel(),
      child: Scaffold(
          backgroundColor: Colors.black,
          body: Consumer<NewsModel>(
            builder: (ctx, model, _) => FloatingSearchBar(
              hint: 'Search News',
              hintStyle: GoogleFonts.poppins(),
              scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
              transitionDuration: const Duration(milliseconds: 800),
              transitionCurve: Curves.easeInOut,
              physics: const BouncingScrollPhysics(),
              axisAlignment: 0.0,
              openAxisAlignment: 0.0,
              width: 600,
              borderRadius: BorderRadius.circular(20),
              debounceDelay: const Duration(milliseconds: 500),
              onQueryChanged: (query) {
                model.onQueryChanged(query);
              },
              transition: CircularFloatingSearchBarTransition(),
              actions: [
                FloatingSearchBarAction(
                  showIfOpened: false,
                  child: const ImageIcon(
                    AssetImage('lib/assets/news.png'),
                    size: 20,
                    color: Colors.black,
                  ),
                ),
                FloatingSearchBarAction.searchToClear(
                  showIfClosed: false,
                ),
              ],
              builder: (context, _) => buildExpandableBody(model),
            ),
          )),
    );
  }
}

Widget buildExpandableBody(NewsModel model) {
  return Padding(
    padding: const EdgeInsets.only(top: 16.0),
    child: Material(
      color: Colors.black,
      elevation: 4.0,
      borderRadius: BorderRadius.circular(8),
      child: ImplicitlyAnimatedList<NewsStructureModel>(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        items: model.suggestions.take(6).toList(),
        areItemsTheSame: (a, b) => a == b,
        itemBuilder: (context, animation, place, i) {
          return SizeFadeTransition(
            animation: animation,
            child: buildItem(context, place),
          );
        },
        updateItemBuilder: (context, animation, place) {
          return FadeTransition(
            opacity: animation,
            child: buildItem(context, place),
          );
        },
      ),
    ),
  );
}

Widget buildItem(BuildContext context, NewsStructureModel place) {
  var width = MediaQuery.of(context).size.width;
  var height = MediaQuery.of(context).size.height;

  return InkWell(
    onTap: () {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => NewsWebView(place.newsUrl)));
    },
    child: Card(
      elevation: 2,
      color: Colors.black,
      child: Column(
        children: [
          Container(
            child: Image.network(
                "https://www.tbstat.com/cdn-cgi/image/q=80/wp/uploads/2019/05/london-streets-filter-1200x675.jpg"),
          ),
          Row(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    height: height * 0.04,
                    width: width * 0.1,
                    child: Image(
                        fit: BoxFit.contain,
                        image: NetworkImage(
                            'https://icons.iconarchive.com/icons/cjdowner/cryptocurrency-flat/1024/Bitcoin-BTC-icon.png')),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        left: width * 0.027, top: width * 0.015),
                    width: width * 0.1,
                    height: height * 0.025,
                    child: AutoSizeText(
                      'BTC',
                      style: GoogleFonts.rubik(
                          fontSize: 14, color: HexColor("#6a6a6a")),
                    ),
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.only(top: height * 0.02),
                      width: width * 0.72,
                      height: height * 0.055,
                      child: AutoSizeText(
                        place.newsHeadline,
                        maxLines: 2,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                  Container(
                      width: width * 0.5,
                      height: height * 0.03,
                      child: AutoSizeText(
                        "- 3 hours ago",
                        minFontSize: 12,
                        maxLines: 1,
                        style: GoogleFonts.poppins(
                          color: HexColor("#6a6a6a"),
                          fontSize: 15,
                        ),
                      )),
                ],
              )
            ],
          ),
        ],
      ),
    ),
  );
}
