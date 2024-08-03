import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:portfolio/constants/body_items.dart';
import 'package:portfolio/constants/header_items.dart';
import 'package:portfolio/theme/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher_web/url_launcher_web.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();

  var modeImg = 'assets/sun.png';

  _scrollToIndex(int index) {
    final screenHeight = MediaQuery.of(context).size.height;
    _scrollController.animateTo(index * screenHeight,
        duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          elevation: 0,
          // title: Padding(
          //   padding: const EdgeInsets.only(left: 60),
          //   child: Text(
          //     'Nabin Adhikari',
          //     style: CustomTextStyle().regularFontStyle,
          //   ),
          // ),
          actions: [
            for (int i = 0; i < headerItems.length; i++)
              InkWell(
                  onTap: () => _scrollToIndex(i),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      headerItems[i],
                      style: TextStyle(
                        fontSize: 20,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  )),
            const Gap(20),
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
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Image.asset(
                          navIcons[i]['icon'].toString(),
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ))
                ],
              )
          ],
        ),
        body: ListView.builder(
            controller: _scrollController,
            itemCount: bodyItems.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(left: 80, right: 80),
                child: bodyItems[index],
              );
            }),
        floatingActionButton: GestureDetector(
          onTap: () {
            Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
            setState(() {
              modeImg = modeImg == 'assets/sun.png'
                  ? 'assets/moon.png'
                  : 'assets/sun.png';
            });
          },
          child: Image.asset(
            modeImg,
            height: MediaQuery.of(context).size.height *
                (60 / MediaQuery.of(context).size.height),
            width: MediaQuery.of(context).size.width *
                (60 / MediaQuery.of(context).size.width),
          ),
        ));
  }
}
