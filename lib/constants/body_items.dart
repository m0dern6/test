import 'package:flutter/material.dart';
import 'package:portfolio/pages/about_me.dart';
import 'package:portfolio/pages/contacts.dart';
import 'package:portfolio/pages/home.dart';
import 'package:portfolio/pages/projects.dart';
import 'package:portfolio/pages/tech_stack.dart';

List<Widget> bodyItems = [
  const Home(),
  const AboutMe(),
  const TechStack(),
  const Projects(),
  const Contacts(),
];
