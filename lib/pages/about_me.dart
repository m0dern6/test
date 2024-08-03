import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portfolio/constants/about_me.dart';
import 'package:portfolio/styles/text_style.dart';

class AboutMe extends StatefulWidget {
  const AboutMe({super.key});

  @override
  State<AboutMe> createState() => _AboutMeState();
}

class _AboutMeState extends State<AboutMe> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width / 1.5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'About Me',
              style: GoogleFonts.poppins(
                fontSize: 42,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            Gap(20),
            Text(
              aboutMe,
              style: GoogleFonts.dmSans(
                fontSize: 20,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            Gap(20),
            Text(
              'Work Experience',
              style: GoogleFonts.poppins(
                fontSize: 42,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            Flexible(
              child: ListView.builder(
                itemCount: workExp.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            workExp[index]['title'],
                            style: GoogleFonts.dmSans(
                              fontSize: 20,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width *
                                (120 / MediaQuery.of(context).size.width),
                            height: MediaQuery.of(context).size.height *
                                (30 / MediaQuery.of(context).size.height),
                            decoration: BoxDecoration(
                                color: Color(0xffD7FFE0),
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                              child: Text(
                                workExp[index]['category'],
                                style: GoogleFonts.dmSans(
                                  fontSize: 20,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Gap(5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.grid_4x4, size: 15),
                              Gap(5),
                              Text(
                                workExp[index]['company'],
                                style: GoogleFonts.dmSans(
                                  fontSize: 20,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.location_off, size: 15),
                              Text(
                                workExp[index]['location'],
                                style: GoogleFonts.dmSans(
                                  fontSize: 20,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.calendar_today, size: 15),
                              Gap(5),
                              Text(
                                workExp[index]['duration'].toString(),
                                style: GoogleFonts.dmSans(
                                  fontSize: 20,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                      Gap(10),
                      Divider(
                        thickness: 2,
                      ),
                    ],
                  );
                },
              ),
            ),
            Text('Education',
                style: GoogleFonts.poppins(
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                )),
            Flexible(
              child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: education.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            education[index]['degree'],
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width *
                                (130 / MediaQuery.of(context).size.width),
                            height: MediaQuery.of(context).size.height *
                                (30 / MediaQuery.of(context).size.height),
                            decoration: BoxDecoration(
                                color: Color(0xffD7FFE0),
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                              child: Text(
                                education[index]['status'],
                                style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Gap(5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.grid_4x4, size: 15),
                              Gap(5),
                              Text(
                                education[index]['institution'],
                                style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.location_off, size: 15),
                              Text(
                                education[index]['location'],
                                style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.calendar_today, size: 15),
                              Gap(5),
                              Text(
                                education[index]['duration'].toString(),
                                style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                      Gap(10),
                      Divider(
                        thickness: 2,
                      ),
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
