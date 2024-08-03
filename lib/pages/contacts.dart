import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portfolio/constants/header_items.dart';
import 'package:portfolio/styles/text_style.dart';
import 'package:url_launcher/url_launcher.dart';

class Contacts extends StatefulWidget {
  const Contacts({super.key});

  @override
  State<Contacts> createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height - 40,
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Gap(40),
          Column(
            children: [
              Text('For any inquiries, please contact me at:',
                  style: GoogleFonts.dmSans(
                    fontSize: 58,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  )),
              ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                        colors: [Color(0xff13B0f5), Color(0xffE70FAA)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight)
                    .createShader(bounds),
                child: Text(
                  'modrn153@gmail.com',
                  style: GoogleFonts.dmSans(
                    fontSize: 58,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Nabin Adhikari',
                    style: GoogleFonts.dmSans(
                      fontSize: 20,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          '+977-9869020603',
                          style: GoogleFonts.dmSans(
                            fontSize: 20,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          '+977-9806682907',
                          style: GoogleFonts.dmSans(
                            fontSize: 20,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          'modrn153@gmail.com',
                          style: GoogleFonts.dmSans(
                            fontSize: 20,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Gap(30),
              Divider(
                thickness: 2,
              ),
              Gap(20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(children: [
                    for (int i = 0; i < navIcons.length; i++)
                      Row(
                        children: [
                          InkWell(
                              onTap: () async {
                                final url = Uri.parse(navIcons[i]['link']);
                                print(url);
                                if (await canLaunchUrl(url)) {
                                  launchUrl(url);
                                } else {
                                  throw 'Could not launch $url';
                                }
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Image.asset(
                                  navIcons[i]['icon'].toString(),
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              ))
                        ],
                      )
                  ]),
                  Text(
                    'Developed using Flutter Web',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ],
              ),
              Gap(20),
            ],
          ),
        ],
      ),
    );
  }
}
