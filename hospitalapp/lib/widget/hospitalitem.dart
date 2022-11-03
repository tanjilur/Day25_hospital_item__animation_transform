import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hospitalapp/models/hospital_model.dart';

class HospitalItem extends StatefulWidget {
  final Hospital hospital;
  final double pageNumber;
  final double index;

  HospitalItem(this.hospital, this.index, this.pageNumber);

  @override
  State<HospitalItem> createState() => _HospitalItemState();
}

class _HospitalItemState extends State<HospitalItem>
    with SingleTickerProviderStateMixin {
  Animation<double>? heightAnim;
  Animation<double>? elevAnim;
  Animation<double>? yOffsetAnim;
  Animation<double>? scaleAnim;
  late AnimationController controller;
  @override
  void initState() {
    controller =
        AnimationController(duration: Duration(seconds: 1), vsync: this);
    controller.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    heightAnim = Tween<double>(begin: 0.0, end: 150).animate(CurvedAnimation(
        parent: controller,
        curve: Interval(0.5, 1.0, curve: Curves.easeInOut)));

    scaleAnim = Tween<double>(begin: 0.95, end: 1.0).animate(CurvedAnimation(
        parent: controller,
        curve: Interval(0.0, 0.3, curve: Curves.easeInOut)));

    yOffsetAnim = Tween<double>(begin: 1.0, end: 10.0).animate(CurvedAnimation(
        parent: controller,
        curve: Interval(0.0, 0.3, curve: Curves.easeInOut)));

    elevAnim = Tween<double>(begin: 2.0, end: 10.0).animate(CurvedAnimation(
        parent: controller,
        curve: Interval(0.0, 0.3, curve: Curves.easeInOut)));
    super.didChangeDependencies();
  }

  final textWhiteStyle = TextStyle(fontSize: 18, color: Colors.white);
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    double diff = widget.index - widget.pageNumber;
    return Transform(
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.002)
          ..rotateY(-pi / 4 * diff),
        alignment: diff > 0
            ? FractionalOffset.centerLeft
            : FractionalOffset.centerRight,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              floating: true,
              expandedHeight: 200,
              flexibleSpace: FlexibleSpaceBar(
                title: Text('${widget.hospital.name}'),
                background: Image.asset(
                  '${widget.hospital.image}',
                  height: 200,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),
            SliverList(
                delegate: SliverChildListDelegate([
              Stack(
                children: [
                  Card(
                    color: Colors.deepPurple.withOpacity(0.9),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, top: 150, bottom: 10),
                      child: Text(
                        '${widget.hospital.description}',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                  Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black,
                          blurRadius: elevAnim!.value,
                          spreadRadius: 2,
                          offset: Offset(0, yOffsetAnim!.value),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          onTap: () {
                            if (isExpanded) {
                              controller.reverse();
                            } else {
                              controller.forward();
                            }
                            setState(() {
                              isExpanded = !isExpanded;
                            });
                          },
                          title: Text(
                            '${widget.hospital.name}',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                          subtitle: Text(
                            '${widget.hospital.category}',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.star,
                                color: Colors.white,
                              ),
                              Text(
                                '${widget.hospital.rating}',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white),
                              )
                            ],
                          ),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(15),
                              bottomRight: Radius.circular(15)),
                          child: Transform.scale(
                            scale: scaleAnim!.value,
                            child: Container(
                              height: heightAnim!.value,
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      colors: [
                                    Color.fromARGB(255, 44, 6, 94),
                                    Colors.purple
                                  ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter)),
                              alignment: Alignment.center,
                              child: ListView(
                                children: [
                                  Text(
                                    'Directed by : ${widget.hospital.director}',
                                    style: textWhiteStyle,
                                  ),
                                  Text(
                                    'Produced by : ${widget.hospital.producer}',
                                    style: textWhiteStyle,
                                  ),
                                  Text(
                                    'Production : ${widget.hospital.production}',
                                    style: textWhiteStyle,
                                  ),
                                  Text(
                                    'Laguage : ${widget.hospital.language}',
                                    style: textWhiteStyle,
                                  ),
                                  Text(
                                    'Running Time : ${widget.hospital.runningTime}',
                                    style: textWhiteStyle,
                                  ),
                                  Text(
                                    'Country: ${widget.hospital.country}',
                                    style: textWhiteStyle,
                                  ),
                                  Text(
                                    'Budget: ${widget.hospital.budget}',
                                    style: textWhiteStyle,
                                  ),
                                  Text(
                                    'Box Office: ${widget.hospital.boxOffice}',
                                    style: textWhiteStyle,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              )
            ]))
          ],
        ));
  }
}
