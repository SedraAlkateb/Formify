import 'package:flutter/material.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/presentation/resources/color_manager.dart';


Widget surveyListWidget(MainSurveyModel survey,void Function()? onTap) {
  return _SurveyListPressCard(survey: survey,onTap: onTap,);
}

class _SurveyListPressCard extends StatefulWidget {
  final MainSurveyModel survey;
  final void Function()? onTap;
  const _SurveyListPressCard({required this.survey,required this.onTap});

  @override
  State<_SurveyListPressCard> createState() => _SurveyListPressCardState();
}

class _SurveyListPressCardState extends State<_SurveyListPressCard> {
  bool _pressed = false;

  Color _parseColor(String value) {
    try {
      if (value.startsWith('#')) {
        return Color(int.parse(value.replaceFirst('#', '0xff')));
      }
      if (value.contains('0x')) {
        return Color(int.parse(value));
      }
      return Colors.blue;
    } catch (_) {
      return Colors.blue;
    }
  }

  void _setPressed(bool v) {
    if (_pressed == v) return;
    setState(() => _pressed = v);
  }

  @override
  Widget build(BuildContext context) {
    final survey = widget.survey;
    final c = _parseColor(survey.color);

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTapDown: (_) => _setPressed(true),
      onTapUp: (_) => _setPressed(false),
      onTapCancel: () => _setPressed(false),
      onTap:widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 170),
        curve: Curves.easeOut,
        transform: Matrix4.identity()
          ..translate(0.0, _pressed ? -3.0 : 0.0)
          ..rotateY(_pressed ? 0.02 : 0.0)
          ..rotateX(_pressed ? 0.02 : 0.0)

          ..scale(_pressed ? 1.01 : 1.0),
        child: Card(
          color: ColorManager.white,
          elevation: _pressed ? 12 : 5,
          shadowColor: c.withOpacity(0.05),
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: ColorManager.black.withOpacity(0.08),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _PressIconBox(color: c, pressed: _pressed),
                const SizedBox(width: 20),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              survey.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              survey.description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: ColorManager.black.withOpacity(0.60),
                                height: 1.15,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.arrow_forward_ios,
                          color: ColorManager.black.withOpacity(0.5),
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PressIconBox extends StatelessWidget {
  final Color color;
  final bool pressed;

  const _PressIconBox({required this.color, required this.pressed});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutBack,
      transformAlignment: Alignment.center, // ✅ يثبت المركز
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.0018) // Perspective
      // لا translate نهائياً حتى لا “يطلع/ينزل/يتحرك”
        ..rotateX(pressed ? 0.22 : 0.0)
        ..rotateY(pressed ? -0.22 : 0.0)
        ..rotateZ(pressed ? 0.18 : 0.0)
        ..scale(pressed ? 1.12 : 1.0),
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            color.withOpacity(0.95),
            color.withOpacity(0.70),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(pressed ? 0.15 : 0.2),
            blurRadius: pressed ? 15 : 11,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Center(
        child:
         Icon(
            Icons.description_outlined,
            color: const Color(0xffffffff),
            size: 30,
          ),

      ),
    );
  }
}
