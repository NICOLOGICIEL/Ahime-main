import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:ahime/config/my_config.dart';

class SearchDropdown extends StatelessWidget {
  const SearchDropdown(
      {super.key,
      required this.myItems,
      required this.myhintText,
      this.onChanged,
      this.headerFontSize=12});

  final List<MyListf> myItems;
  final String myhintText;
  final dynamic Function(MyListf?)? onChanged;
  final double headerFontSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: CustomDropdown<MyListf>.search(
        hintText: myhintText,
        items: myItems,
        decoration: CustomDropdownDecoration(
            closedFillColor: Color.fromARGB(59, 223, 221, 221),
            headerStyle: TextStyle(fontSize: headerFontSize),
            hintStyle: TextStyle(fontSize: 12)),
        excludeSelected: false,
        searchHintText: 'Rechercher',
        noResultFoundText: 'Aucun résultat trouvé',
        onChanged: onChanged,
      ),
    );
  }
}
