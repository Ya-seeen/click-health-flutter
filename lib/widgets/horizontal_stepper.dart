import 'package:flutter/material.dart';

enum StepperStepState {
  /// A step that displays its index in its circle.
  indexed,

  /// A step that displays a pencil icon in its circle.
  editing,

  /// A step that displays a tick icon in its circle.
  complete,

  /// A step that is disabled and does not to react to taps.
  disabled,

  /// A step that is currently having an error. e.g. the user has submitted wrong
  /// input.
  error,
}

const TextStyle _kStepStyle = TextStyle(
  fontSize: 12.0,
  color: Colors.white,
);
const Color _kErrorLight = Colors.red;
final Color _kErrorDark = Colors.red.shade400;
const Color _kCircleActiveLight = Colors.white;
const Color _kCircleActiveDark = Colors.black87;
const Color _kDisabledLight = Colors.black38;
const Color _kDisabledDark = Colors.white38;
const double _kStepSize = 24.0;
const double _kStepSizeActive = 28.0;

@immutable
class StepperStep {
  const StepperStep({
    @required this.title,
    this.subtitle,
    this.isActive = false,
    this.state = StepperStepState.indexed,
  })  : assert(title != null),
        assert(state != null);

  final Widget title;
  final bool isActive;
  final Widget subtitle;
  final StepperStepState state;
}

class HorizontalStepper extends StatefulWidget {
  final List<StepperStep> steps;
  final int currentStep;

  HorizontalStepper({
    @required this.steps,
    this.currentStep = 0,
  });

  @override
  _HorizontalStepperState createState() => _HorizontalStepperState();
}

class _HorizontalStepperState extends State<HorizontalStepper> {
  @override
  Widget build(BuildContext context) {
    return _buildHorizontal();
  }

  bool _isDark() {
    return Theme.of(context).brightness == Brightness.dark;
  }

  Widget _buildCircleChild(int index) {
    final StepperStepState state = widget.steps[index].state;
    final bool isDarkActive = _isDark();
    assert(state != null);
    switch (state) {
      case StepperStepState.indexed:
      case StepperStepState.disabled:
        return Text(
          '${index + 1}',
          style: isDarkActive
              ? _kStepStyle.copyWith(color: Colors.black87)
              : _kStepStyle,
        );
      case StepperStepState.editing:
        return Icon(
          Icons.edit,
          color: isDarkActive ? _kCircleActiveDark : _kCircleActiveLight,
          size: 18.0,
        );
      case StepperStepState.complete:
        return Icon(
          Icons.check,
          color: isDarkActive ? _kCircleActiveDark : _kCircleActiveLight,
          size: 18.0,
        );
      case StepperStepState.error:
        return const Text('!', style: _kStepStyle);
    }
    return null;
  }

  Color _circleColor(int index) {
    final ThemeData themeData = Theme.of(context);
    if (!_isDark()) {
      return index < widget.currentStep
          ? themeData.accentColor
          : (widget.steps[index].isActive
          ? themeData.primaryColor
          : Colors.black38);
    } else {
      return index < widget.currentStep
          ? themeData.accentColor
          : (widget.steps[index].isActive
              ? themeData.primaryColor
              : themeData.backgroundColor);
    }
  }

  Widget _buildCircle(int index) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      width: widget.steps[index].isActive ? _kStepSizeActive : _kStepSize,
      height: widget.steps[index].isActive ? _kStepSizeActive : _kStepSize,
      child: AnimatedContainer(
        curve: Curves.fastOutSlowIn,
        duration: kThemeAnimationDuration,
        decoration: BoxDecoration(
          color: _circleColor(index),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: _buildCircleChild(index),
        ),
      ),
    );
  }

  TextStyle _titleStyle(int index) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;

    assert(widget.steps[index].state != null);
    switch (widget.steps[index].state) {
      case StepperStepState.indexed:
      case StepperStepState.editing:
      case StepperStepState.complete:
        return textTheme.bodyText1;
      case StepperStepState.disabled:
        return textTheme.bodyText1
            .copyWith(color: _isDark() ? _kDisabledDark : _kDisabledLight);
      case StepperStepState.error:
        return textTheme.bodyText1
            .copyWith(color: _isDark() ? _kErrorDark : _kErrorLight);
    }
    return null;
  }

  TextStyle _subtitleStyle(int index) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;

    assert(widget.steps[index].state != null);
    switch (widget.steps[index].state) {
      case StepperStepState.indexed:
      case StepperStepState.editing:
      case StepperStepState.complete:
        return textTheme.caption;
      case StepperStepState.disabled:
        return textTheme.caption
            .copyWith(color: _isDark() ? _kDisabledDark : _kDisabledLight);
      case StepperStepState.error:
        return textTheme.caption
            .copyWith(color: _isDark() ? _kErrorDark : _kErrorLight);
    }
    return null;
  }

  Widget _buildIcon(int index) {
    return _buildCircle(index);
  }

  Widget _buildHeaderText(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        AnimatedDefaultTextStyle(
          style: _titleStyle(index),
          duration: kThemeAnimationDuration,
          curve: Curves.fastOutSlowIn,
          child: widget.steps[index].title,
        ),
        widget.steps[index].subtitle != null
            ? Container(
                margin: const EdgeInsets.only(top: 2.0),
                child: AnimatedDefaultTextStyle(
                  style: _subtitleStyle(index),
                  duration: kThemeAnimationDuration,
                  curve: Curves.fastOutSlowIn,
                  child: widget.steps[index].subtitle,
                ),
              )
            : Container(),
      ],
    );
  }

  bool _isLast(int index) {
    return widget.steps.length - 1 == index;
  }

  Widget _buildHorizontal() {
    final List<Widget> children = <Widget>[
      for (int i = 0; i < widget.steps.length; i += 1) ...<Widget>[
        InkResponse(
          canRequestFocus: widget.steps[i].state != StepState.disabled,
          child: Container(
            height: 72.0,
            child: Center(
              child: _buildIcon(i),
            ),
          ),
        ),
        if (!_isLast(i))
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(10),
              height: 1.0,
              color: Colors.grey.shade400,
            ),
          ),
      ],
    ];

    return Container(
      child: Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Row(
              children: children,
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              for (int i = 0; i < widget.steps.length; i += 1) ...<Widget>[
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: _buildHeaderText(i),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  /*Widget _buildHorizontal() {
    final List<Widget> children = widget.steps
        .asMap()
        .map((index, value) => MapEntry(
              index,
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Container(
                        height: 72.0,
                        child: Center(
                          child: _buildIcon(index),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsetsDirectional.only(start: 12.0),
                        child: _buildHeaderText(index),
                      ),
                    ],
                  ),
                  Container(
                    height: 2.0,
                    width: 10,
                    color: Colors.grey.shade400,
                  ),
                ],
              ),
            ))
        .values
        .toList();

    return Column(
      children: <Widget>[
        Material(
          elevation: 2.0,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              children: children,
            ),
          ),
        ),
      ],
    );
  }*/
}
