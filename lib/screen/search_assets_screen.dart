import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../model/crypto_and_fiat_model.dart';
import '../provider/crypto_and_fiat_provider.dart';

class SearchAssetsScreen extends StatefulWidget {
  final int index;

  const SearchAssetsScreen({required this.index});

  @override
  _SearchAssetsScreenState createState() => _SearchAssetsScreenState();
}

class _SearchAssetsScreenState extends State<SearchAssetsScreen> {
  late FloatingSearchBarController controller;

  static const historyLength = 5;

  late  int page = 0;

  final List<String> _searchHistory = [];

  late List<String> filteredSearchHistory;

  String selectedTerm = "Search Assets";

  final _scrollController = ScrollController();

  List<String> filterSearchTerms({
    required String filter,
  }) {
    if (filter.isNotEmpty) {
      return _searchHistory.reversed
          .where((term) => term.startsWith(filter))
          .toList();
    } else {
      return _searchHistory.reversed.toList();
    }
  }

  void addSearchTerm(String term) {
    if (_searchHistory.contains(term)) {
      putSearchTermFirst(term);
      return;
    }
    if (term.isNotEmpty) {
      _searchHistory.add(term);
    }
    if (_searchHistory.length > historyLength) {
      _searchHistory.removeRange(0, _searchHistory.length - historyLength);
    }
    filteredSearchHistory = filterSearchTerms(filter: "");
  }

  void deleteSearchTerm(String term) {
    _searchHistory.removeWhere((t) => t == term);
    filteredSearchHistory = filterSearchTerms(filter: "");
  }

  void putSearchTermFirst(String term) {
    deleteSearchTerm(term);
    addSearchTerm(term);
  }

  void pagination() {
    if (_scrollController.offset >=
        _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        page++;
        Provider.of<CryptoAndFiatProvider>(context, listen: false)
            .fiatAndCryptoList(page);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    controller = FloatingSearchBarController();
    _scrollController.addListener(pagination);
    filteredSearchHistory = filterSearchTerms(filter: "");
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.black,
      body: Consumer<CryptoAndFiatProvider>(
        builder: (ctx, model, _) => FloatingSearchBar(
            controller: controller,
            hint: 'Search Assets',
            title: Text(
              selectedTerm,
              style: GoogleFonts.poppins(),
            ),
            hintStyle: GoogleFonts.poppins(),
            scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
            transitionDuration: const Duration(milliseconds: 800),
            transitionCurve: Curves.easeInOut,
            physics: const BouncingScrollPhysics(),
            openAxisAlignment: 0.0,
            width: 600,
            borderRadius: BorderRadius.circular(20),
            debounceDelay: const Duration(milliseconds: 500),
            onQueryChanged: (query) {
              model.queryValue = query;
              model.changeValue();
              model.getCryptoAndFiatBySearch(query);
              filteredSearchHistory = filterSearchTerms(filter: query);
            },
            onSubmitted: (query) {
              setState(() {
                addSearchTerm(query);
                selectedTerm = query;
                model.queryValue = query;
                model.changeValue();
                model.getCryptoAndFiatBySearch(query);
              });
              controller.close();
            },
            transition: CircularFloatingSearchBarTransition(),
            actions: [
              const FloatingSearchBarAction(
                child: ImageIcon(
                  AssetImage('lib/assets/news.png'),
                  size: 20,
                  color: Colors.black,
                ),
              ),
              FloatingSearchBarAction.searchToClear(
                showIfClosed: false,
              ),
            ],
            builder: (context, _) => ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Material(
                    color: Colors.white,
                    elevation: 4,
                    child: Builder(
                      builder: (context) {
                        if (filteredSearchHistory.isEmpty &&
                            controller.query.isEmpty) {
                          return Container(
                            height: 56,
                            width: double.infinity,
                            alignment: Alignment.center,
                            child: Text(
                              'Start searching',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.caption,
                            ),
                          );
                        } else if (filteredSearchHistory.isEmpty) {
                          return ListTile(
                            title: Text(controller.query),
                            leading: const Icon(Icons.search),
                            onTap: () {
                              setState(() {
                                addSearchTerm(controller.query);
                                selectedTerm = controller.query;
                              });
                              controller.close();
                            },
                          );
                        } else {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: filteredSearchHistory
                                .map(
                                  (term) => ListTile(
                                    title: Text(
                                      term,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.poppins(),
                                    ),
                                    leading: const Icon(Icons.history),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.clear),
                                      onPressed: () {
                                        setState(() {
                                          deleteSearchTerm(term);
                                        });
                                      },
                                    ),
                                    onTap: () {
                                      setState(() {
                                        putSearchTermFirst(term);
                                        selectedTerm = term;
                                        model.queryValue = term;
                                        model.changeValue();
                                        model.onQueryChanged();
                                      });
                                      controller.close();
                                    },
                                  ),
                                )
                                .toList(),
                          );
                        }
                      },
                    ),
                  ),
                ),
            body: FloatingSearchBarScrollNotifier(
              child: Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.08,
                    left: 10,
                    right: 10),
                child: ListView.separated(
                    separatorBuilder: (context, index) {
                      return const Divider(
                        color: Color(0xFF6a6a6a),
                      );
                    },
                    itemCount: model.updatedList.isEmpty
                        ? model.listModel.length
                        : model.updatedList.length,
                    controller:_scrollController ,
                    itemBuilder: (ctx, index) {
                      return buildItem(
                          context,
                          model.updatedList.isEmpty
                              ? model.listModel[index]
                              : model.updatedList[index]);
                    }),
              ),
            )),
      ),
    );
  }

  // Widget buildExpandableBody(CryptoAndFiatModel model) {
  //   return Padding(
  //     padding: const EdgeInsets.only(top: 16.0),
  //     child: Material(
  //       color: Colors.black,
  //       elevation: 4.0,
  //       borderRadius: BorderRadius.circular(8),
  //       child: ImplicitlyAnimatedList<CryptoAndFiatStructureModel>(
  //         shrinkWrap: true,
  //         physics: const NeverScrollableScrollPhysics(),
  //         items: model.listModel.take(model.listModel.length).toList(),
  //         areItemsTheSame: (a, b) => a == b,
  //         itemBuilder: (context, animation, place, i) {
  //           return SizeFadeTransition(
  //             animation: animation,
  //             child: buildItem(context, place),
  //           );
  //         },
  //         updateItemBuilder: (context, animation, place) {
  //           return FadeTransition(
  //             opacity: animation,
  //             child: buildItem(context, place),
  //           );
  //         },
  //       ),
  //     ),
  //   );
  // }

  Widget buildItem(BuildContext context, CryptoAndFiatModel place) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {
        Provider.of<CryptoAndFiatProvider>(context, listen: false)
            .changeCardValue(widget.index, place);
        //  list[widget.index] = place;
        Get.back();
      },
      child: Card(
          margin: const EdgeInsets.all(10),
          elevation: 4,
          color: Colors.black,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SizedBox(
                    height: height * 0.1,
                    width: width * 0.1,
                    child: place.image.startsWith("https")
                        ? CachedNetworkImage( imageUrl: place.image,)
                        : Container(
                            margin: const EdgeInsets.only(top: 28),
                            child: Text(
                              place.image,
                              style: const TextStyle(fontSize: 25),
                            ))),
                Text(
                  place.name,
                  style: GoogleFonts.rubik(color: Colors.white, fontSize: 17),
                ),
                Text(
                  place.price.toStringAsFixed(3).toString(),
                  style: GoogleFonts.rubik(color: Colors.white, fontSize: 17),
                )
              ],
            ),
          )),
    );
  }
}
