import 'package:grocery_flutter/http/social/user_info.dart';

class PersonInviteArgs {
  PersonInviteArgs({required this.jwt, required this.person});
  final String jwt;
  final UserInfo person;
}
