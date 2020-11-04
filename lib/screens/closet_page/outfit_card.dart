import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:synthetics/components/eco_bar.dart';
import 'package:synthetics/screens/item_dashboard/clothing_item.dart';
import 'package:synthetics/screens/closet_page/clothing_card.dart';
import 'package:synthetics/theme/custom_colours.dart';
import 'package:synthetics/responseObjects/clothingItemObject.dart';
import 'package:synthetics/services/image_taker/image_manager.dart';

class OutfitCard extends ClothingCard {
  const OutfitCard({Key key, this.outfitClothingList}) : super(key: key);

  final List<ClothingItemObject> outfitClothingList;

  @override
  _OutfitCardState createState() => _OutfitCardState();
}

class _OutfitCardState extends ClothingCardState<OutfitCard> {
  bool clear = false;
  int index = 0;
  ClothingItemObject currentClothingItem;
  Future<File> currClothingItemImage;

  @override
  void initState() {
    this.index = 0;
    this.currentClothingItem = widget.outfitClothingList[this.index];
    currClothingItemImage = this.getImage();
  }

  Widget getIcon() {
    return GestureDetector(
        onTap: () {
          setState(() {
            this.clear = true;
          });
        },
        child: Container(
            width: 20.0,
            height: 20.0,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: CustomColours.accentCopper()),
            child: () {
              var icon = null;
              icon = Icons.remove;
              return Icon(icon, color: CustomColours.offWhite(), size: 10.0);
            }()));
  }

  List<Widget> getLeftRightControls() {
    return <Widget>[
      Positioned(
          top: 75.0,
          left: 15.0,
          child: GestureDetector(
              onTap: () {
                if (index > 0) {
                  setState(() {
                    this.currentClothingItem =
                        widget.outfitClothingList[this.index - 1];
                    this.currClothingItemImage = getImage();
                    this.index = this.index - 1;
                  });
                }
              },
              child: this.index == 0
                  ? Container()
                  : Icon(Icons.arrow_back_ios,
                      color: CustomColours.offWhite(), size: 20.0))),
      Positioned(
          top: 75.0,
          right: 10.0,
          child: GestureDetector(
              onTap: () {
                if (index < widget.outfitClothingList.length - 1) {
                  setState(() {
                    this.currentClothingItem =
                        widget.outfitClothingList[this.index + 1];
                    this.currClothingItemImage = getImage();
                    this.index = this.index + 1;
                  });
                }
              },
              child: this.index == widget.outfitClothingList.length - 1
                  ? Container()
                  : Icon(Icons.arrow_forward_ios,
                      color: CustomColours.offWhite(), size: 20.0)))
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
        children: (() {
      var base = <Widget>[
        Card(
            color: CustomColours.offWhite(),
            margin: EdgeInsets.all(5.0),
            child: InkWell(
                onTap: () => {
                      print(
                          'TODO: open up closet and allow users to select from the appropriate category')
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => ClothingItem(
                      //             clothingItem: this.currentClothingItem)))
                    },
                child: Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Stack(
                        children: (() {
                      var cardChildren = <Widget>[
                        FutureBuilder<File>(
                            future: this.currClothingItemImage,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Image.file(snapshot.data);
                              } else if (snapshot.data == null) {
                                return Text("No image from file");
                              }
                              return LinearProgressIndicator();
                            }),
                        Align(
                            alignment: Alignment.bottomCenter,
                            child: EcoBar(current: 20, max: 20)),
                      ];
                      return cardChildren;
                    }())))))
      ];
      base.add(Positioned(top: 0.0, right: 0.0, child: getIcon()));
      base.addAll(getLeftRightControls());
      return base;
    }()));
  }
}