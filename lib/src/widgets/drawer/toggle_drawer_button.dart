import 'package:flutter/material.dart';

class ToggleDrawerButton extends StatelessWidget {
  const ToggleDrawerButton({
    super.key,
    required this.isOpen,
    this.alignment = Alignment.centerLeft,
    required this.onPressed,
  });

  final bool isOpen;
  final Alignment alignment;
  final void Function(ScaffoldState)? onPressed;

  @override
  Widget build(BuildContext context) {
    final String drawerLabel = MaterialLocalizations.of(context).drawerLabel;
    return Builder(builder: (context) {
      return Align(
        alignment: alignment,
        child: IconButton(
          padding: const EdgeInsets.all(12),
          icon: Icon(
            isOpen ? Icons.menu_open : Icons.menu,
            semanticLabel: isOpen ? 'Close $drawerLabel' : 'Open $drawerLabel',
          ),
          onPressed: onPressed != null
              ? () => onPressed!.call(Scaffold.of(context))
              : null,
        ),
      );
    });
  }
}
