import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/models/loan_document.dart';
import '../../../routes/app_routes.dart';
import '../controllers/home_controller.dart';

class HomeRequestLoanContent extends StatelessWidget {
  const HomeRequestLoanContent({
    super.key,
    required this.controller,
  });

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = AppColors.of(context);

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      children: [
        Text(
          'Solicitar préstamo',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Captura y envía tus documentos oficiales para continuar con la solicitud.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 24),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Documentos requeridos',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                Obx(() {
                  final docs = controller.capturedDocuments;
                  return Column(
                    children: LoanDocumentType.values.map((type) {
                      final document = docs.firstWhere(
                        (doc) => doc.type == type,
                        orElse: () => LoanDocument(type: type),
                      );
                      return _DocumentTile(
                        document: document,
                        accentColor: appColors,
                        onTap: () async {
                          final result =
                              await Get.toNamed<List<LoanDocument>>(
                            AppRoutes.loanCapture,
                          );
                          if (result != null) {
                            await controller.onDocumentsCaptured(result);
                          }
                        },
                      );
                    }).toList(),
                  );
                }),
                const SizedBox(height: 8),
                Text(
                  'Asegúrate de que las imágenes sean claras, sin reflejos y con buena iluminación.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        FilledButton.icon(
          icon: const Icon(Icons.camera_alt_outlined),
          label: const Text('Escanear documentos'),
          onPressed: () async {
            final result = await Get.toNamed<List<LoanDocument>>(
              AppRoutes.loanCapture,
            );
            if (result != null) {
              await controller.onDocumentsCaptured(result);
            }
          },
        ),
        const SizedBox(height: 12),
        FilledButton(
          onPressed: controller.submitLoanRequest,
          child: const Text('Enviar solicitud'),
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: () => controller.changeTab(0),
          child: const Text('Volver al inicio'),
        ),
      ],
    );
  }
}

class _DocumentTile extends StatelessWidget {
  const _DocumentTile({
    required this.document,
    required this.accentColor,
    required this.onTap,
  });

  final LoanDocument document;
  final AppColors accentColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isCompleted = document.isCompleted;
    final backgroundColor = isCompleted
        ? accentColor.success.withOpacity(0.12)
        : theme.colorScheme.surfaceVariant.withOpacity(0.6);
    final borderColor = isCompleted
        ? accentColor.success
        : theme.colorScheme.outlineVariant;

    return Semantics(
      button: true,
      label:
          '${document.type.title}${isCompleted ? ' capturado' : ' sin capturar'}',
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(16),
        ),
        child: ListTile(
          onTap: onTap,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          leading: Icon(
            document.type.icon,
            color:
                isCompleted ? accentColor.success : theme.colorScheme.primary,
            size: 28,
          ),
          title: Text(
            document.type.title,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(
            isCompleted ? 'Documento capturado' : document.type.helper,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          trailing: Icon(
            isCompleted ? Icons.check_circle : Icons.chevron_right,
            color: isCompleted
                ? accentColor.success
                : theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
