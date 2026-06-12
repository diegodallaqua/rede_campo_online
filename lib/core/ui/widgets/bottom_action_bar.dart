import 'package:flutter/material.dart';

import '../buttons/custom_button.dart';
import '../theme/custom_colors.dart';

class BottomActionBar extends StatelessWidget {
  const BottomActionBar({
    super.key,
    required this.editing,
    required this.loading,
    required this.onSave,
    this.onDelete,
    this.putLabel = 'Salvar',
    this.postLabel = 'Publicar',
    this.deleteLabel = 'Apagar',
  });

  final bool editing;
  final bool loading;
  final VoidCallback onSave;
  final VoidCallback? onDelete;
  final String putLabel;
  final String postLabel;
  final String deleteLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      decoration: const BoxDecoration(
        color: CustomColors.salt_flower,
        border: Border(top: BorderSide(color: Color(0xFFE8E8DC))),
      ),
      child: SafeArea(
        top: false,
        child: loading
            ? const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: CircularProgressIndicator(
                    color: CustomColors.copper_spice,
                    strokeWidth: 2.5,
                  ),
                ),
              )
            : editing
                ? Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: CustomButton(
                          width: double.infinity,
                          color: CustomColors.vanilla_haze,
                          text: deleteLabel,
                          textColor: CustomColors.copper_spice,
                          borderRadius: 10,
                          fontWeight: FontWeight.w600,
                          function: onDelete,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 3,
                        child: CustomButton(
                          width: double.infinity,
                          color: CustomColors.copper_spice,
                          text: putLabel,
                          textColor: CustomColors.vanilla_haze,
                          borderRadius: 10,
                          fontWeight: FontWeight.w600,
                          function: onSave,
                        ),
                      ),
                    ],
                  )
                : CustomButton(
                    width: double.infinity,
                    color: CustomColors.copper_spice,
                    text: postLabel,
                    textColor: CustomColors.vanilla_haze,
                    borderRadius: 10,
                    fontWeight: FontWeight.w600,
                    function: onSave,
                  ),
      ),
    );
  }
}
