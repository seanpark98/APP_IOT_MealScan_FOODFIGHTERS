//참가 중 및 진행 중 챌린지 화면에 보이는 챌린지 카드
//챌린지 관련 기본 정보를 담고 있음

import 'package:flutter/material.dart';
import 'package:osam2021/models/challenge.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:osam2021/screens/challenge_screens/added_challenge_info.dart';
import 'package:osam2021/screens/challenge_screens/challenge_info.dart';
import 'package:intl/intl.dart';
import 'package:slide_countdown/slide_countdown.dart';


class ChallengeCard extends StatefulWidget {
  ///유저가 챌린지에 참가하거나 삭제했을 때 챌린지 화면이 최신화 될수 있도록함
  final Function() notifyParent; 
  final Challenge challenge; 
  /// 참가중인 챌린지인지 여부
  final bool added; 
  const ChallengeCard({required this.notifyParent, required this.challenge, required this.added});

  @override
  _ChallengeCardState createState() => _ChallengeCardState();
}

class _ChallengeCardState extends State<ChallengeCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _selectCard(),
      ],
    );
  }

  Widget _selectCard() {
    return widget.added ? _addedCard() : _openCard();
  }

  Widget _addedCard() {
    DateFormat format = DateFormat("hh:mm:ss");
    int estimateTs = DateTime.parse(widget.challenge.date).millisecondsSinceEpoch;
    int now = DateTime.now().millisecondsSinceEpoch;
    Duration remaining = Duration(milliseconds: estimateTs - now);
    String formattedRemaining = '${remaining.inDays}:${format.format(DateTime.fromMillisecondsSinceEpoch(remaining.inMilliseconds))}';
    var date = formattedRemaining.split(":");
    Duration defaultDuration = Duration(days: remaining.inDays, hours: int.parse(date[1]), minutes: int.parse(date[2]));
    const defaultPadding = EdgeInsets.symmetric(horizontal: 10, vertical: 3);
    String name = widget.challenge.name;

    return Container(
      child: InkWell(
        onTap: () {
          _navigateToAddedInfoScreen(context);
        },
        child: Column(
          children: [
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SlideCountdown(
                      duration: defaultDuration,
                      padding: defaultPadding,
                      slideDirection: SlideDirection.up,
                      fade: true,
                      decoration: BoxDecoration(
                        color: widget.challenge.bgColor.withOpacity(0.8),
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      icon: Padding(
                        padding: EdgeInsets.only(right: 5),
                        child: Icon(
                                  Icons.alarm,
                                  color: Colors.white,
                                  size: 15,
                                ),
                      ),
                    ),
                  ],
                ),
            SizedBox(height: 3),
            Container(
                padding: const EdgeInsets.only(left: 20, top: 25, right: 20),
                decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              widget.challenge.bgColor.withOpacity(0.8),
                              widget.challenge.bgColor2.withOpacity(0.9),
                            ], begin: Alignment.bottomLeft, end: Alignment.centerRight),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                              topRight: Radius.circular(55),
                            ),
                            boxShadow: [
                              BoxShadow(offset: Offset(0, 3), blurRadius: 4, spreadRadius: 4, color: widget.challenge.bgColor2.withOpacity(0.5))
                            ]),
              width: MediaQuery.of(context).size.width,
              height: 90,
              child: 
                Column(
                  children: [
                    Row(children:
                    [Text("$name", style: TextStyle(fontSize: 25, color: Colors.black, fontWeight: FontWeight.bold)),
                      Icon(FontAwesomeIcons.chevronRight, color: Color(0xff999999), size: 30),
                    ],
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    ),
                  ],
                ),
            ),
          ],
        ),
      ),
    );   
  }

  Widget _openCard() {
    String name = widget.challenge.name;
    String attendant = widget.challenge.attendants + "명 참가 중";
    var dest = DateTime.parse(widget.challenge.date);
    var today = DateTime.now();
    var from = DateTime(dest.year, dest.month, dest.day);
    var to = DateTime(today.year, today.month, today.day);
    int days = (from.difference(to).inHours / 24).round();
    String date = '$days' + "일 후 마감";
    return Container(
      child: InkWell(
        onTap: () {
          if (widget.added) {
              _navigateToAddedInfoScreen(context);
          } else {
              _navigateToChallengeInfo(context);
          }
        },
        child: Container(
                    padding: const EdgeInsets.only(left: 20, top: 25, right: 20),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          widget.challenge.bgColor.withOpacity(0.8),
                          widget.challenge.bgColor2.withOpacity(0.9),
                        ], begin: Alignment.bottomLeft, end: Alignment.centerRight),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                          topRight: Radius.circular(80),
                        ),
                        boxShadow: [
                          BoxShadow(offset: Offset(0, 3), blurRadius: 4, spreadRadius: 4, color: widget.challenge.bgColor2.withOpacity(0.5))
                        ]),
          width: MediaQuery.of(context).size.width,
          height: 130,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [Text("$name", style: TextStyle(fontSize: 25, color: Colors.black, fontWeight: FontWeight.bold)),]),
              SizedBox(height: 3),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      SizedBox(width: 4),
                      Icon(Icons.hourglass_bottom, size: 16, color: Colors.black),
                      SizedBox(
                         width: 10,
                      ),
                      Text("$date",
                          style: TextStyle(fontSize: 14, color: Colors.black,)
                      ),                    
                    ]
                  ),
                  Expanded(child: Container()),
                  Icon(FontAwesomeIcons.chevronRight, color: Color(0xff999999), size: 30),
                ]
              ),
              SizedBox(height:3),
              Row(
                children: [
                  SizedBox(width: 4),
                  Icon(FontAwesomeIcons.users, size: 16, color: Colors.black),
                  SizedBox(
                    width: 10,
                  ),
                  Text("$attendant",
                    style: TextStyle(fontSize: 14, color: Colors.black,)
                  ),
                ]
              ),
            ]
          ),
        ),
      ),
    );

  }

  _navigateToChallengeInfo(BuildContext context) async {
    await showDialog(
        context: context,
        barrierColor: Color(0x00ffffff),
        builder: (BuildContext context) {
          return ChallengeInfo(challenge: widget.challenge);
        });
    widget.notifyParent();
  }

  _navigateToAddedInfoScreen(BuildContext context) async {
    await Navigator.of(context).push(MaterialPageRoute<void>(builder: (BuildContext context) {
      return AddedChallengeInfo(challenge: widget.challenge);
    }));
    widget.notifyParent();
  }
}
