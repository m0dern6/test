import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portfolio/constants/skills.dart';
import 'package:portfolio/styles/text_style.dart';

class TechStack extends StatefulWidget {
  const TechStack({super.key});

  @override
  State<TechStack> createState() => _TechStackState();
}

class _TechStackState extends State<TechStack> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gap(80),
            Text(title,
                style: GoogleFonts.poppins(
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                )),
            Gap(20),
            Text(
              description,
              style: GoogleFonts.dmSans(
                fontSize: 20,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            Gap(80),
            Expanded(
              child: GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: skills.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio:
                        (MediaQuery.of(context).size.width / 4) / 200,
                  ),
                  itemBuilder: (context, index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            child: Center(
                          child: Text(
                            skills[index]['name'],
                            style: GoogleFonts.dmSans(
                              fontSize: 20,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                        )),
                        Container(
                            height: 120,
                            width: 120,
                            child: Image.asset(skills[index]['image'])),
                      ],
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
