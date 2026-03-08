import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/presentation/excel/bloc/excel_st_bloc.dart';
import 'package:formify/presentation/resources/color_manager.dart';
import 'package:formify/presentation/resources/routes_manager.dart';
import 'package:formify/presentation/resources/theme_bloc/theme_bloc.dart';
import 'package:formify/presentation/resources/values_manager.dart';
import 'package:formify/presentation/survey/bloc/survey_bloc.dart';

Widget surveyCardActiveConference(MainSurveyModel survey,int conferenceId) {
  return _SurveyCardPressCard(survey: survey,conferenceId: conferenceId,);
}

class _SurveyCardPressCard extends StatefulWidget {
  final MainSurveyModel survey;
final int conferenceId;
  const _SurveyCardPressCard({required this.survey,required this.conferenceId});

  @override
  State<_SurveyCardPressCard> createState() => _SurveyCardPressCardState();
}

class _SurveyCardPressCardState extends State<_SurveyCardPressCard> {
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
    final conferenceId = widget.conferenceId;

    final c = _parseColor(survey.color);

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTapDown: (_) => _setPressed(true),
      onTapUp: (_) => _setPressed(false),
      onTapCancel: () => _setPressed(false),
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
            padding: EdgeInsets.symmetric(
              vertical: AppPadding.p16,
              horizontal: AppPadding.p10,
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    _PressIconBox(color: c, pressed: _pressed),
                    const SizedBox(width: 20),
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
                          SizedBox(height: AppSize.s6),
                          Text(
                            survey.description,
                            maxLines: 3,
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
                  ],
                ),
                SizedBox(height: 40),
                SurveyFeedbackCard(survey: survey,conferenceId: conferenceId,),
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
          colors: [color.withOpacity(0.95), color.withOpacity(0.70)],
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
        child: Icon(
          Icons.description_outlined,
          color: const Color(0xffffffff),
          size: 30,
        ),
      ),
    );
  }
}

class SurveyFeedbackCard extends StatefulWidget {
  const SurveyFeedbackCard({super.key, required this.survey,required this.conferenceId});
  final MainSurveyModel survey;
  final int  conferenceId;
  @override
  State<SurveyFeedbackCard> createState() => _SurveyFeedbackCardState();
}

class _SurveyFeedbackCardState extends State<SurveyFeedbackCard> {
  int? hoveredActionIndex;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(height: 1, color: Color(0xFFE5E7EB)),
        SizedBox(
          height: 82,
          child: Row(
            children: [
              Expanded(
                child: _AnimatedActionButton(
                  label: 'الإحصائيات',
                  icon: Icons.bar_chart_rounded,
                  baseColor: const Color(0xFF2563EB),
                  isHovered: hoveredActionIndex == 0,
                  onHover: (value) {
                    setState(() => hoveredActionIndex = value ? 0 : null);
                  },
                  onTap: () {

                    BlocProvider.of<ThemeBloc>(context).add(
                      ChangeThemeColorEvent(
                        Color(int.parse(widget.survey.color)),
                        widget.survey.color,
                      ),
                    );
                    BlocProvider.of<ExcelStBloc>(
                      context,
                    ).add(SurveyStatisticsEvent(

                        widget.survey.id,widget.conferenceId

                    ));
                    Navigator.pushNamed(context, Routes.dashboardSurvey);
                  },
                ),
              ),
              const VerticalDivider(width: 1, color: Color(0xFFE5E7EB)),
              Expanded(
                child: _AnimatedActionButton(
                  label: 'تصدير Excel',
                  icon: Icons.table_chart_outlined,
                  baseColor: const Color(0xFF16A34A),
                  isHovered: hoveredActionIndex == 1,
                  onHover: (value) {
                    setState(() => hoveredActionIndex = value ? 1 : null);
                  },
                  onTap: () {
                    BlocProvider.of<ThemeBloc>(context).add(
                      ChangeThemeColorEvent(
                        Color(int.parse(widget.survey.color)),
                        widget.survey.color,
                      ),
                    );
                    Navigator.pushNamed(context, Routes.exelConference);
                    BlocProvider.of<ExcelStBloc>(
                      context,
                    ).add(UsersAnswersStatisticsEvent(widget.survey.id));
                  },
                ),
              ),
              const VerticalDivider(width: 1, color: Color(0xFFE5E7EB)),
              Expanded(
                child: _AnimatedActionButton(
                  label: 'عرض التفاصيل',
                  icon: Icons.visibility_outlined,
                  baseColor: const Color(0xFF9333EA),
                  isHovered: hoveredActionIndex == 2,
                  onHover: (value) {
                    setState(() => hoveredActionIndex = value ? 2 : null);
                  },
                  onTap: () {
                    Navigator.pushNamed(context, Routes.viewSurvey);
                    BlocProvider.of<ThemeBloc>(context).add(
                      ChangeThemeColorEvent(
                        Color(int.parse(widget.survey.color)),
                        widget.survey.color,
                      ),
                    );
                    BlocProvider.of<SurveyBloc>(
                      context,
                    ).add(ViewSurveyByIdEvent(widget.survey.id));
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AnimatedActionButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final Color baseColor;
  final bool isHovered;
  final ValueChanged<bool> onHover;
  final VoidCallback onTap;

  const _AnimatedActionButton({
    required this.label,
    required this.icon,
    required this.baseColor,
    required this.isHovered,
    required this.onHover,
    required this.onTap,
  });

  @override
  State<_AnimatedActionButton> createState() => _AnimatedActionButtonState();
}

class _AnimatedActionButtonState extends State<_AnimatedActionButton> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    final bool hovered = widget.isHovered;

    final backgroundColor = isPressed
        ? widget.baseColor.withOpacity(0.15) // 👈 لون عند الضغط
        : hovered
        ? Color.lerp(Colors.white, widget.baseColor, 0.08)!
        : Colors.white;

    final iconScale = hovered ? 1.08 : 1.0;

    return MouseRegion(
      onEnter: (_) => widget.onHover(true),
      onExit: (_) => widget.onHover(false),
      cursor: SystemMouseCursors.click,
      child: InkWell(
        onTap: widget.onTap,
        onHighlightChanged: (value) {
          setState(() => isPressed = value);
        },
        //  borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          color: backgroundColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedScale(
                scale: iconScale,
                duration: const Duration(milliseconds: 200),
                child: Icon(widget.icon, color: widget.baseColor, size: 24),
              ),
              const SizedBox(height: 8),
              Text(
                widget.label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: widget.baseColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
