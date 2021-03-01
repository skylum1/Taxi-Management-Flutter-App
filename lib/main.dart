import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:taxi/screens/add_booking.dart';
import 'package:taxi/screens/add_expenses.dart';
import 'screens/add_driv.dart';
import 'package:taxi/screens/add_taxi.dart';
import 'package:carousel_slider/carousel_slider.dart';

const Color bgcolor = Color(0xFF383d61);
const Color bgcolor2 = Color(0xFF2f3351);
const Color card1color = Color(0xFF00adb5);
const Color card2color = Color(0xFF842e4b);
const Color card3color = Color(0xFF00b359);
const Color card4color = Color(0xFF634f64);
const Color fgcolor = Colors.black38;
const Color textcolor = Colors.white;
const TextStyle textstyle = TextStyle(color: Colors.white);
const Color bordercolor = Colors.white;

void main() async {
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => Menu_man(),
      '/booking': (context) => AddBooking(),
      '/add_tax': (context) => TaxiClass(),
      '/add_driv': (context) => Add_driver(),
      '/add_exp': (context) => MyApp(),
    },
  ));
}

class Menu_man extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgcolor,
      appBar: AppBar(
          backgroundColor: bgcolor2, title: Center(child: Text('Main Menu'))),
      body: Center(
        child: CarouselSlider(
          options: CarouselOptions(
              pageSnapping: false,
              autoPlay: true,
              autoPlayInterval: const Duration(milliseconds: 2500),
              aspectRatio: 1.0,
              enlargeCenterPage: true),
          items: [
            My_card(
              text: 'Booking',
              fc: () {
                Navigator.pushNamed(context, '/booking');
              },
              color: card1color,
            ),
            My_card(
              text: 'Add Taxi',
              fc: () {
                Navigator.pushNamed(context, '/add_tax');
              },
              color: card2color,
            ),
            My_card(
              text: 'Add Driver',
              fc: () {
                Navigator.pushNamed(context, '/add_driv');
              },
              color: card3color,
            ),
            My_card(
              text: 'Add Expenses',
              fc: () {
                Navigator.pushNamed(context, '/add_exp');
              },
              color: card4color,
            )
          ],
        ),
      ),
    );
  }
}

/* CarouselSlider(
        options: CarouselOptions(
            pageSnapping: false,
            autoPlay: true,
            autoPlayInterval: const Duration(milliseconds: 2500),
            aspectRatio: 1.0,
            enlargeCenterPage: true),
        items: [
          My_card(
              text: 'Booking',
              fc: () {
                Navigator.pushNamed(context, '/booking');
              }),
          My_card(
            text: 'Add Taxi',
            fc: () {
              Navigator.pushNamed(context, '/add_tax');
            },
          ),
          My_card(
              text: 'Add Driver',
              fc: () {
                Navigator.pushNamed(context, '/add_driv');
              }),
          My_card(
              text: 'Add Expenses',
              fc: () {
                Navigator.pushNamed(context, '/add_exp');
              })
        ],
      ),*/
/* Column(
        children: [
          Expanded(
            child: Row(
              children: [
                My_card(
                    text: 'Booking',
                    fc: () {
                      Navigator.pushNamed(context, '/booking');
                    },
                    color: card1color),
                My_card(
                  text: 'Add Taxi',
                  fc: () {
                    Navigator.pushNamed(context, '/add_tax');
                  },
                  color: card2color,
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: Row(
              children: [
                My_card(
                  text: 'Add Driver',
                  fc: () {
                    Navigator.pushNamed(context, '/add_driv');
                  },
                  color: card3color,
                ),
                My_card(
                    text: 'Add Expenses',
                    fc: () {
                      Navigator.pushNamed(context, '/add_exp');
                    },
                    color: card4color)
              ],
            ),
          ),
        ],
      )*/
class My_card extends StatelessWidget {
  My_card({@required this.text, this.fc, this.color});
  final String text;
  final Function fc;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: fc,
      child: Container(
        child: Center(
            child: Text(
          text,
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 30, color: textcolor),
        )),
        margin: EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}
