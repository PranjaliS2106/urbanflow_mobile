import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Advanced timing controls with slider inputs for phase duration
class TimingControlsWidget extends StatefulWidget {
  const TimingControlsWidget({
    super.key,
    required this.greenDuration,
    required this.yellowDuration,
    required this.redDuration,
    required this.onDurationChanged,
    required this.isEnabled,
  });

  final int greenDuration;
  final int yellowDuration;
  final int redDuration;
  final Function(String phase, int duration) onDurationChanged;
  final bool isEnabled;

  @override
  State<TimingControlsWidget> createState() => _TimingControlsWidgetState();
}

class _TimingControlsWidgetState extends State<TimingControlsWidget> {
  late double _greenValue;
  late double _yellowValue;
  late double _redValue;

  @override
  void initState() {
    super.initState();
    _greenValue = widget.greenDuration.toDouble();
    _yellowValue = widget.yellowDuration.toDouble();
    _redValue = widget.redDuration.toDouble();
  }

  @override
  void didUpdateWidget(TimingControlsWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.greenDuration != widget.greenDuration) {
      _greenValue = widget.greenDuration.toDouble();
    }
    if (oldWidget.yellowDuration != widget.yellowDuration) {
      _yellowValue = widget.yellowDuration.toDouble();
    }
    if (oldWidget.redDuration != widget.redDuration) {
      _redValue = widget.redDuration.toDouble();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'tune',
                color: widget.isEnabled
                    ? colorScheme.primary
                    : colorScheme.onSurface.withValues(alpha: 0.5),
                size: 24,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  'Timing Controls',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: widget.isEnabled
                        ? colorScheme.onSurface
                        : colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
              ),
              if (!widget.isEnabled)
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: colorScheme.outline.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'DISABLED',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.5),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 3.h),
          _buildTimingSlider(
            context,
            'Green Phase',
            _greenValue,
            const Color(0xFF4CAF50),
            10,
            120,
            (value) {
              setState(() => _greenValue = value);
              widget.onDurationChanged('green', value.round());
            },
          ),
          SizedBox(height: 2.h),
          _buildTimingSlider(
            context,
            'Yellow Phase',
            _yellowValue,
            const Color(0xFFFFA726),
            3,
            10,
            (value) {
              setState(() => _yellowValue = value);
              widget.onDurationChanged('yellow', value.round());
            },
          ),
          SizedBox(height: 2.h),
          _buildTimingSlider(
            context,
            'Red Phase',
            _redValue,
            const Color(0xFFE53935),
            10,
            120,
            (value) {
              setState(() => _redValue = value);
              widget.onDurationChanged('red', value.round());
            },
          ),
          SizedBox(height: 3.h),
          _buildTimingSummary(context, colorScheme),
          if (!widget.isEnabled) ...[
            SizedBox(height: 2.h),
            _buildDisabledNotice(context, colorScheme),
          ],
        ],
      ),
    );
  }

  Widget _buildTimingSlider(
    BuildContext context,
    String label,
    double value,
    Color color,
    double min,
    double max,
    Function(double) onChanged,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: theme.textTheme.labelMedium?.copyWith(
                color: widget.isEnabled
                    ? colorScheme.onSurface
                    : colorScheme.onSurface.withValues(alpha: 0.5),
                fontWeight: FontWeight.w600,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '${value.round()}s',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: widget.isEnabled
                ? color
                : colorScheme.outline.withValues(alpha: 0.3),
            inactiveTrackColor: widget.isEnabled
                ? color.withValues(alpha: 0.3)
                : colorScheme.outline.withValues(alpha: 0.1),
            thumbColor: widget.isEnabled
                ? color
                : colorScheme.outline.withValues(alpha: 0.5),
            overlayColor: color.withValues(alpha: 0.2),
            trackHeight: 4,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
          ),
          child: Slider(
            value: value,
            min: min,
            max: max,
            divisions: (max - min).round(),
            onChanged: widget.isEnabled ? onChanged : null,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${min.round()}s',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
            Text(
              '${max.round()}s',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTimingSummary(BuildContext context, ColorScheme colorScheme) {
    final theme = Theme.of(context);
    final totalCycle = _greenValue + _yellowValue + _redValue;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: colorScheme.primary.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Cycle Summary',
            style: theme.textTheme.labelMedium?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Row(
            children: [
              Expanded(
                child: _buildSummaryItem(
                  context,
                  'Total Cycle',
                  '${totalCycle.round()}s',
                  colorScheme,
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: _buildSummaryItem(
                  context,
                  'Cycles/Hour',
                  '${(3600 / totalCycle).round()}',
                  colorScheme,
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: _buildSummaryItem(
                  context,
                  'Green Ratio',
                  '${((_greenValue / totalCycle) * 100).round()}%',
                  colorScheme,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(
    BuildContext context,
    String label,
    String value,
    ColorScheme colorScheme,
  ) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Text(
          value,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: colorScheme.primary,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurface.withValues(alpha: 0.7),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildDisabledNotice(BuildContext context, ColorScheme colorScheme) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: colorScheme.outline.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: 'info',
            color: colorScheme.onSurface.withValues(alpha: 0.5),
            size: 20,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              'Enable Maintenance Mode to adjust timing controls.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
