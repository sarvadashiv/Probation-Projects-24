import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../data/header_items.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key, required this.itemController});
  final ItemScrollController itemController;
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
          child: ListView.separated(
              itemBuilder: (context, index){
                return ListTile(
                  title: Text(
                    headerItems[index].title,
                    style: const TextStyle(color: Colors.white),
                  ),
                  onTap: (){
                    itemController.scrollTo(index: headerItems[index].index, duration: const Duration(seconds: 1));
                    Navigator.pop(context) ;
                  },
                );
              },
              separatorBuilder: (context, index)=> const SizedBox(height: 12),
              itemCount: headerItems.length)),
    );
  }
}