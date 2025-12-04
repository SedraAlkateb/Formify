import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:formify/presentation/resources/assets_manager.dart';
import 'package:formify/presentation/resources/color_manager.dart';

class CustomGridPage extends StatelessWidget {
  const CustomGridPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
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
                big: false,
                onTap: () {
                  print("Big clicked");
                },
              ),
            ),

            StaggeredGridTile.count(
              crossAxisCellCount: 1,
              mainAxisCellCount: 1.6, // أكبر من الباقي
              child: AnimatedGridItem(
                text: "create Survey dynamic",
                big: true,
                onTap: () {
                  print("Big clicked");
                },
              ),
            ),

            StaggeredGridTile.count(
              crossAxisCellCount: 1,
              mainAxisCellCount: 1.6,
              child: AnimatedGridItem(
                text: "create conference dynamic",
                big: true,
                onTap: () {
                  print("Big clicked");
                },
              ),
            )
            ,
            StaggeredGridTile.count(
              crossAxisCellCount: 1,
              mainAxisCellCount: 1,
              child: AnimatedGridItem(
                text: "get all Survey",
                big: false,
                onTap: () {
                  print("Big clicked");
                },
              ),
            ),

            // مربع كبير للجهة المقابلة

          ],
        ),
      ),
    );
  }

}

class AnimatedGridItem extends StatefulWidget {
  final String text;
  final bool big;
  final VoidCallback onTap;

  const AnimatedGridItem({
    super.key,
    required this.text,
    required this.big,
    required this.onTap,
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
          decoration: BoxDecoration(
            color: widget.big
                ? ColorManager.primary.withOpacity(0.55)
                : ColorManager.secondary.withOpacity(0.55),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 8,
                offset: const Offset(0, 3),
              )
            ],
          ),

          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.text,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                  ),
                ),
                // فقط الكبيرة تعرض SVG
                if (widget.big)
                  Expanded(
                    child: SvgPicture.asset(HomeImageAssets.survey),
                  ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
