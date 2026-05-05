import 'package:flutter/material.dart';
import 'package:formify/presentation/resources/color_manager.dart';
import 'package:formify/presentation/resources/values_manager.dart';

class SearchField extends StatelessWidget {
  const SearchField(
      {super.key, required this.searchController, this.onPressed});
  final TextEditingController searchController;
  final Function(String)? onPressed;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.symmetric( horizontal: 8),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(

              controller: searchController,
              onChanged: onPressed,

              decoration: InputDecoration(
                fillColor: ColorManager.white,
                border: InputBorder.none,
                isDense: true,
                suffixIcon: Icon(
                  Icons.search,
                  color: ColorManager.medicalMuted,
                  size: AppSize.s28,
                ),

                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: ColorManager.medicalBorder),
                    borderRadius:
                        BorderRadius.all(
                            Radius.circular(AppSize.s12))),

                hintText: 'ابحث هنا',
                hintStyle: TextStyle(
                    fontSize: 16, overflow: TextOverflow.fade),
              ),
            ),
          ),
          //   IconButton(onPressed:onPressed , icon: Icon(Icons.search,color: ColorManager.secondaryColor,size: AppSize.s28,))
        ],
      ),
    );
  }
}
