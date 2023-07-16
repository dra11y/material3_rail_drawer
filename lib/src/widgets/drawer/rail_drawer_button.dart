import 'package:flutter/material.dart';

class RailDrawerButton extends StatefulWidget {
  const RailDrawerButton({
    super.key,
    required this.level,
    required this.drawerItemIndent,
    this.extraIndent = 0,
    this.index,
    required this.isSelected,
    this.isAccessibilityFocused = false,
    required this.icon,
    required this.selectedIcon,
    this.expanderIcon,
    required this.label,
    this.isExpanded,
    required this.onPressed,
    this.isSelectedBold = true,
  });

  final int level;
  final double drawerItemIndent;
  final double extraIndent;
  final int? index;
  final bool isSelected;
  final bool isAccessibilityFocused;
  final IconData icon;
  final IconData selectedIcon;
  final IconData? expanderIcon;
  final String label;
  final bool? isExpanded;
  final VoidCallback onPressed;
  final bool isSelectedBold;

  @override
  State<RailDrawerButton> createState() => _RailDrawerButtonState();

  factory RailDrawerButton.back({required VoidCallback onPressed}) =>
      RailDrawerButton(
        level: 0,
        drawerItemIndent: 0,
        extraIndent: 0,
        isSelected: false,
        icon: Icons.arrow_back,
        selectedIcon: Icons.arrow_back,
        label: 'Main menu',
        onPressed: onPressed,
      );
}

class _RailDrawerButtonState extends State<RailDrawerButton> {
  bool? needsTooltip;

  @override
  Widget build(BuildContext context) {
    final drawerTheme = NavigationDrawerTheme.of(context);
    final isMobileNative = [TargetPlatform.android, TargetPlatform.iOS]
        .contains(Theme.of(context).platform);
    final colorScheme = Theme.of(context).colorScheme;
    final indicatorColor = colorScheme.secondaryContainer;
    final foregroundColor = widget.isSelected
        ? colorScheme.onSecondaryContainer
        : colorScheme.onSurfaceVariant;

    final double leftIndent =
        widget.extraIndent + widget.level * widget.drawerItemIndent;

    final textStyle = Theme.of(context).textTheme.labelLarge?.copyWith(
          fontWeight: widget.isSelected && widget.isSelectedBold
              ? FontWeight.bold
              : null,
        );

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: SizedBox(
            width: drawerTheme.indicatorSize!.width - leftIndent,
            height: drawerTheme.tileHeight ?? drawerTheme.indicatorSize?.height,
            child: Semantics(
              container: true,
              button: true,
              selected: widget.isSelected,
              focused: widget.isAccessibilityFocused,
              excludeSemantics: true,
              label: [
                /// Semantics `selected` currently does not work outside of mobile native,
                /// so we must add it manually to the label in that case.
                if (widget.isSelected && !isMobileNative) 'selected',
                if (widget.isExpanded == false) 'collapsed',
                if (widget.isExpanded == true) 'expanded',
                widget.label,
              ].join(', '),
              child: Tooltip(
                excludeFromSemantics: true,
                message: needsTooltip == true ? widget.label : '',
                child: TextButton.icon(
                  style: ButtonStyle(
                    shape: MaterialStatePropertyAll(
                        drawerTheme.indicatorShape is OutlinedBorder
                            ? drawerTheme.indicatorShape as OutlinedBorder
                            : const StadiumBorder()),
                    backgroundColor: MaterialStatePropertyAll(
                        widget.isSelected ? indicatorColor : null),
                    padding: const MaterialStatePropertyAll(
                        EdgeInsets.symmetric(horizontal: 12)),
                  ),
                  icon: Icon(
                    widget.isSelected ? widget.selectedIcon : widget.icon,
                    color: foregroundColor,
                  ),
                  label: Row(
                    children: [
                      Expanded(
                          child: LayoutBuilder(builder: (context, constraints) {
                        _computeTooltipVisibility(
                            textStyle, context, constraints);
                        return Text(
                          widget.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textStyle,
                        );
                      })),
                      if (widget.isExpanded != null)
                        Icon(
                          widget.expanderIcon ??
                              (widget.isExpanded == true
                                  ? Icons.arrow_drop_up
                                  : Icons.arrow_drop_down),
                          color: foregroundColor,
                        ),
                    ],
                  ),
                  onPressed: () {
                    /// Dismiss the tooltip to prevent it from blocking VoiceOver.
                    Future.delayed(const Duration(milliseconds: 0), () {
                      Tooltip.dismissAllToolTips();
                    });
                    widget.onPressed();
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _computeTooltipVisibility(
      TextStyle? textStyle, BuildContext context, BoxConstraints constraints) {
    if (needsTooltip != null) return;

    final textSpan = TextSpan(
      text: widget.label,
      style: textStyle,
    );
    final textPainter = TextPainter(
      maxLines: 1,
      text: textSpan,
      textDirection: Directionality.of(context),
    )..layout(maxWidth: constraints.maxWidth);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (!mounted) return;

      setState(() {
        needsTooltip = textPainter.didExceedMaxLines;
      });
    });
  }
}
