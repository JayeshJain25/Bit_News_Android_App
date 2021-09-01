import 'dart:math';

import 'package:animate_icons/animate_icons.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:clippy_flutter/clippy_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:provider/provider.dart';

import '../provider/crypto_and_fiat_provider.dart';
import '../screen/search_assets_screen.dart';

class ConversionToolScreen extends StatefulWidget {
  @override
  _ConversionToolScreenState createState() => _ConversionToolScreenState();
}

class _ConversionToolScreenState extends State<ConversionToolScreen>
    with TickerProviderStateMixin {
  late AnimateIconController exchangeCardBtnAnimation;

  late AnimationController cardController;
  late Animation<double> cardAnimation;

  late AnimationController _controller;
  late Animation<double> _animation;

  late PaletteColor paletteColor;

  Future<Color> getImagePalette(String url) async {
    final PaletteGenerator paletteGenerator =
        await PaletteGenerator.fromImageProvider(NetworkImage(url));
    return paletteGenerator.dominantColor!.color;
  }

  TextEditingController coin1Controller = TextEditingController(text: "1.00");
  TextEditingController coin2Controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<CryptoAndFiatProvider>(context, listen: false)
        .fiatAndCryptoList();
    exchangeCardBtnAnimation = AnimateIconController();
    cardController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));
    cardAnimation =
        CurvedAnimation(parent: cardController, curve: Curves.easeIn);
    cardController.forward();

    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200));
    _animation = Tween(begin: 0.5, end: 0.0).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    cardController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: Colors.white,
          onPressed: () {
            Get.back();
          },
        ),
        title: AutoSizeText('Conversion Tool',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 20,
            )),
      ),
      body: Consumer<CryptoAndFiatProvider>(
        builder: (ctx, model, _) => model.listModel.isEmpty
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: SafeArea(
                  child: Stack(children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        const SizedBox(
                          height: 50,
                        ),
                        Transform(
                          transform: Matrix4.identity()
                            ..setEntry(3, 2, 0.002)
                            ..rotateX(pi * _animation.value),
                          alignment: FractionalOffset.center,
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 15),
                            height: height * 0.25,
                            child: FadeTransition(
                              opacity: cardAnimation,
                              child: Card(
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                margin: const EdgeInsets.all(15),
                                child: FutureBuilder<Color>(
                                  future: getImagePalette(
                                      model.listModel[model.index1].image),
                                  builder: (ctx, AsyncSnapshot<Color> snap) =>
                                      Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(width: 0),
                                        gradient: LinearGradient(
                                            begin: Alignment.bottomCenter,
                                            end: Alignment.topCenter,
                                            colors: [
                                              if (snap.connectionState ==
                                                  ConnectionState.done)
                                                snap.requireData
                                              else
                                                const Color(0xFF491f01),
                                              Colors.black
                                            ])),
                                    child: Stack(children: <Widget>[
                                      Positioned(
                                        right: 15,
                                        top: -30,
                                        child: ColorFiltered(
                                            colorFilter: ColorFilter.mode(
                                                Colors.black.withOpacity(0.15),
                                                BlendMode.dstIn),
                                            child: model.listModel[model.index1]
                                                    .image
                                                    .startsWith("https")
                                                ? Image(
                                                    height: height * 0.25,
                                                    width: width * 0.25,
                                                    fit: BoxFit.contain,
                                                    image: NetworkImage(model
                                                        .listModel[model.index1]
                                                        .image))
                                                : Text(
                                                    model
                                                        .listModel[model.index1]
                                                        .image,
                                                    style: const TextStyle(
                                                        fontSize: 25),
                                                  )),
                                      ),
                                      Positioned(
                                          left: 25,
                                          child: model
                                                  .listModel[model.index1].image
                                                  .startsWith("https")
                                              ? Image(
                                                  height: height * 0.07,
                                                  width: width * 0.07,
                                                  fit: BoxFit.contain,
                                                  image: NetworkImage(model
                                                      .listModel[model.index1]
                                                      .image))
                                              : Container(
                                                  margin: const EdgeInsets.only(
                                                      top: 15),
                                                  child: Text(
                                                    model
                                                        .listModel[model.index1]
                                                        .image,
                                                    style: const TextStyle(
                                                        fontSize: 25),
                                                  ))),
                                      Positioned(
                                        top: 19,
                                        left: 60,
                                        child: InkWell(
                                          onTap: () {
                                            Get.to(() =>
                                                const SearchAssetsScreen(
                                                    index: 0));
                                          },
                                          child: SizedBox(
                                            width: width * 0.2,
                                            height: height * 0.03,
                                            child: AutoSizeText(
                                              model.listModel[model.index1]
                                                  .symbol,
                                              style: GoogleFonts.rubik(
                                                  fontSize: 18,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 4,
                                        left: 70,
                                        child: InkWell(
                                          onTap: () {
                                            Get.to(
                                                () => const SearchAssetsScreen(
                                                      index: 0,
                                                    ));
                                          },
                                          child: SizedBox(
                                              width: width * 0.2,
                                              height: height * 0.06,
                                              child: const Icon(
                                                Icons.arrow_drop_down_rounded,
                                                color: Colors.white,
                                                size: 32,
                                              )),
                                        ),
                                      ),
                                      Positioned(
                                        top: 100,
                                        left: 26,
                                        child: SizedBox(
                                          width: width * 0.5,
                                          height: height * 0.1,
                                          child: TextFormField(
                                            controller: coin1Controller,
                                            onChanged: (value) {
                                              setState(() {
                                                coin2Controller.text = model
                                                    .getConversionRate(
                                                        model
                                                            .listModel[
                                                                model.index1]
                                                            .price,
                                                        model
                                                            .listModel[
                                                                model.index2]
                                                            .price,
                                                        coin1Controller.text)
                                                    .toString();
                                              });
                                            },
                                            style: GoogleFonts.rubik(
                                                color: Colors.white,
                                                fontSize: 25),
                                            decoration: const InputDecoration(
                                              border: InputBorder.none,
                                            ),
                                            keyboardType: TextInputType
                                                .number, // Only numbers can be entered
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        right: 20,
                                        top: 150,
                                        child: Arc(
                                          edge: Edge.TOP,
                                          height: height * 0.1,
                                          clipShadows: [
                                            ClipShadow(color: Colors.black)
                                          ],
                                          child: Container(
                                            height: height * 0.1,
                                            width: width * 0.5,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ]),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        FutureBuilder(
                          future: getImagePalette(
                              model.listModel[model.index2].image),
                          builder: (ctx, AsyncSnapshot<Color> snap) =>
                              Transform(
                            transform: Matrix4.identity()
                              ..setEntry(3, 2, 0.002)
                              ..rotateX(-pi * _animation.value),
                            alignment: FractionalOffset.center,
                            child: Container(
                              margin: const EdgeInsets.only(top: 15),
                              height: height * 0.25,
                              child: FadeTransition(
                                opacity: cardAnimation,
                                child: Card(
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  margin: const EdgeInsets.all(15),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(width: 0),
                                        gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              if (snap.connectionState ==
                                                  ConnectionState.done)
                                                snap.requireData
                                              else
                                                const Color(0xFF491f01),
                                              Colors.black
                                            ])),
                                    child: Stack(children: <Widget>[
                                      Positioned(
                                        right: 15,
                                        bottom: -30,
                                        child: ColorFiltered(
                                          colorFilter: ColorFilter.mode(
                                              Colors.black.withOpacity(0.15),
                                              BlendMode.dstIn),
                                          child: Image(
                                              height: height * 0.25,
                                              width: width * 0.25,
                                              fit: BoxFit.contain,
                                              image: NetworkImage(model
                                                  .listModel[model.index2]
                                                  .image)),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 12,
                                        left: 25,
                                        child: Image(
                                            height: height * 0.07,
                                            width: width * 0.07,
                                            fit: BoxFit.contain,
                                            image: NetworkImage(model
                                                .listModel[model.index2]
                                                .image)),
                                      ),
                                      Positioned(
                                        bottom: 25,
                                        left: 60,
                                        child: InkWell(
                                          onTap: () {
                                            Get.to(
                                                () => const SearchAssetsScreen(
                                                      index: 1,
                                                    ));
                                          },
                                          child: SizedBox(
                                            width: width * 0.2,
                                            height: height * 0.03,
                                            child: AutoSizeText(
                                              model.listModel[model.index2]
                                                  .symbol,
                                              style: GoogleFonts.rubik(
                                                  fontSize: 18,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 15,
                                        left: 70,
                                        child: InkWell(
                                          onTap: () {
                                            Get.to(
                                                () => const SearchAssetsScreen(
                                                      index: 1,
                                                    ));
                                          },
                                          child: SizedBox(
                                              width: width * 0.2,
                                              height: height * 0.06,
                                              child: const Icon(
                                                Icons.arrow_drop_down_rounded,
                                                color: Colors.white,
                                                size: 32,
                                              )),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 70,
                                        left: 26,
                                        child: SizedBox(
                                          width: width * 0.5,
                                          height: height * 0.1,
                                          child: TextFormField(
                                            controller: coin2Controller
                                              ..text = model
                                                  .getConversionRate(
                                                      model
                                                          .listModel[
                                                              model.index1]
                                                          .price,
                                                      model
                                                          .listModel[
                                                              model.index2]
                                                          .price,
                                                      coin1Controller.text)
                                                  .toString(),
                                            style: GoogleFonts.rubik(
                                                color: Colors.white,
                                                fontSize: 25),
                                            decoration: const InputDecoration(
                                              border: InputBorder.none,
                                            ),
                                            keyboardType: TextInputType
                                                .number, // Only numbers can be entered
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        right: 20,
                                        bottom: 150,
                                        child: Arc(
                                          height: height * 0.1,
                                          clipShadows: [
                                            ClipShadow(color: Colors.black)
                                          ],
                                          child: Container(
                                            height: height * 0.1,
                                            width: width * 0.5,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ]),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      right: 75,
                      top: 238,
                      child: Container(
                        height: height * 0.09,
                        width: width * 0.3,
                        decoration: const BoxDecoration(
                            color: Colors.orange, shape: BoxShape.circle),
                        child: AnimateIcons(
                          startIcon: Icons.rotate_right_rounded,
                          endIcon: Icons.rotate_right_rounded,
                          controller: exchangeCardBtnAnimation,
                          size: 45,
                          onStartIconPress: () {
                            cardController.reverse();
                            Future.delayed(const Duration(milliseconds: 900),
                                () {
                              cardController.forward();
                              model.switchValue(oldStatus: true);
                            });
                            return true;
                          },
                          onEndIconPress: () {
                            cardController.reverse();
                            Future.delayed(const Duration(milliseconds: 900),
                                () {
                              cardController.forward();
                              model.switchValue(oldStatus: false);
                            });
                            return true;
                          },
                          duration: const Duration(milliseconds: 500),
                          startIconColor: Colors.white,
                          endIconColor: Colors.white,
                          clockwise: false,
                        ),
                      ),
                    ),
                  ]),
                ),
              ),
      ),
    );
  }
}