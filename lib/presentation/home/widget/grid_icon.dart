import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:formify/app/di.dart';
import 'package:formify/presentation/active_conference/bloc/active_conference_bloc.dart';
import 'package:formify/presentation/resources/assets_manager.dart';
import 'package:formify/presentation/resources/color_manager.dart';
import 'package:formify/presentation/resources/routes_manager.dart';

class CustomGridPage extends StatelessWidget {
  const CustomGridPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: StaggeredGrid.count(
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        children: [
          StaggeredGridTile.count(
            crossAxisCellCount: 1,
            mainAxisCellCount: 1,
            child: AnimatedGridItem(
              text: "get all conference",
              onTap: () {
                initActiveConferenceModule();
                BlocProvider.of<ActiveConferenceBloc>(context).add(GetAllActiveConferenceEvent());

                Navigator.pushNamed(context, Routes.getAllActiveConference);
              },
            ),
          ),

          StaggeredGridTile.count(
            crossAxisCellCount: 1,
            mainAxisCellCount: 1.6, // أكبر من الباقي
            child: AnimatedGridItem(
              text: "create Survey dynamic",
              onTap: () {
               Navigator.pushNamed(context, Routes.createSurvey);
              },
              type: "Survey",
              image: HomeImageAssets.survey,
            ),
          ),

          StaggeredGridTile.count(
            crossAxisCellCount: 1,
            mainAxisCellCount: 1.6,
            child: AnimatedGridItem(
              text: "create conference dynamic",
              onTap: () {
                Navigator.pushNamed(context, Routes.createConference);
              },
              image: HomeImageAssets.conference,
              type: "conference",
            ),
          ),
          StaggeredGridTile.count(
            crossAxisCellCount: 1,
            mainAxisCellCount: 1,
            child: AnimatedGridItem(
              text: "get all Survey",
              onTap: () {
                Navigator.pushNamed(context, Routes.getAllSurvey);

              },
            ),
          ),

          // مربع كبير للجهة المقابلة
        ],
      ),
    );
  }
}

class AnimatedGridItem extends StatefulWidget {
  final String text;
  final VoidCallback onTap;
  final String? image;
  final String ?type;
  const AnimatedGridItem({
    super.key,
    required this.text,
    required this.onTap,
     this.type,
    this.image,
  });

  @override
  State<AnimatedGridItem> createState() => _AnimatedGridItemState();
}

class _AnimatedGridItemState extends State<AnimatedGridItem> {
  double _scale = 1.0;

  void _onTapDown(_) => setState(() => _scale = 0.95);
  void _onTapUp() => setState(() => _scale = 1.0);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: (_) {
        _onTapUp();
        widget.onTap(); // استدعاء الإجراء
      },
      onTapCancel: () => setState(() => _scale = 1.0),

      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 140),
        curve: Curves.easeOut,
        child: Container(
          padding: EdgeInsets.only(left: 16,right: 16,top: 16),
          alignment: Alignment.bottomCenter,
          decoration: BoxDecoration(
            color: widget.image != null
                ? ColorManager.primary.withOpacity(0.2)
                : ColorManager.white.withOpacity(0.8),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),

          child:  Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
             Column(
               mainAxisAlignment: MainAxisAlignment.start,
               crossAxisAlignment: CrossAxisAlignment.center,
               children: [
                 Text(
                   widget.text,
                   style: const TextStyle(
                     color: ColorManager.primary,
                     fontSize: 18,
                     fontWeight: FontWeight.bold,
                   ),
                 ),
                 widget.type==null?
                 Text(
                   "num of ${widget.type} : 30",
                   style: const TextStyle(
                     color: ColorManager.accent,
                     fontSize: 14,
                     fontWeight: FontWeight.w500,
                   ),
                 ):SizedBox(),
               ],
             ),
              if (widget.image != null)
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: SvgPicture.asset(
                      widget.image ?? "",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
