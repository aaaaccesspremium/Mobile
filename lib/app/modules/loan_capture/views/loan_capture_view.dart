import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/models/loan_document.dart';
import '../controllers/loan_capture_controller.dart';

class LoanCaptureView extends GetView<LoanCaptureController> {
  const LoanCaptureView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Captura de documentos'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Obx(() {
            final state = controller.status.value;
            if (state == LoanCaptureStatus.loading ||
                state == LoanCaptureStatus.capturing) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state == LoanCaptureStatus.empty) {
              return _LoanCaptureEmpty(onRetry: controller.loadDocuments);
            }

            if (state == LoanCaptureStatus.error) {
              return _LoanCaptureError(
                message: controller.errorMessage.value ??
                    'No pudimos cargar los documentos. Inténtalo de nuevo.',
                onRetry: controller.loadDocuments,
              );
            }

            if (state == LoanCaptureStatus.permissionDenied) {
              return _LoanCapturePermission(
                onOpenSettings: controller.openSettings,
                onRetry: controller.resetPermissionWarning,
              );
            }

            final appColors = AppColors.of(context);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Asegúrate de que tus documentos estén bien iluminados y en una superficie plana.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: ListView.separated(
                    itemCount: controller.documents.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final document = controller.documents[index];
                      return _LoanDocumentTile(
                        document: document,
                        appColors: appColors,
                        onTap: () => controller.startCapture(document.type),
                      );
                    },
                  ),
                ),
                if (controller.errorMessage.value != null) ...[
                  const SizedBox(height: 16),
                  Semantics(
                    liveRegion: true,
                    child: Text(
                      controller.errorMessage.value!,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.error,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: controller.isReadyToSubmit
                      ? controller.finishCapture
                      : null,
                  child: Text(
                    controller.isReadyToSubmit
                        ? 'Continuar'
                        : 'Completa la captura',
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}

class _LoanDocumentTile extends StatelessWidget {
  const _LoanDocumentTile({
    required this.document,
    required this.appColors,
    required this.onTap,
  });

  final LoanDocument document;
  final AppColors appColors;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isCompleted = document.isCompleted;
    final backgroundColor = isCompleted
        ? appColors.success.withOpacity(0.12)
        : theme.colorScheme.surfaceVariant.withOpacity(0.4);
    final borderColor =
        isCompleted ? appColors.success : theme.colorScheme.outlineVariant;

    return Semantics(
      button: true,
      label:
          '${document.type.title}${isCompleted ? ' capturado' : ' sin capturar'}',
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor),
        ),
        child: ListTile(
          onTap: onTap,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          leading: Icon(
            document.type.icon,
            color:
                isCompleted ? appColors.success : theme.colorScheme.primary,
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
                ? appColors.success
                : theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

class _LoanCaptureEmpty extends StatelessWidget {
  const _LoanCaptureEmpty({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.file_present_rounded,
              size: 72, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(height: 16),
          Text(
            'No encontramos documentos pendientes.',
            style: theme.textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Actualiza para volver a cargar la lista.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: onRetry,
            child: const Text('Actualizar'),
          ),
        ],
      ),
    );
  }
}

class _LoanCaptureError extends StatelessWidget {
  const _LoanCaptureError({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.wifi_off,
              size: 72, color: theme.colorScheme.error),
          const SizedBox(height: 16),
          Text(
            'No pudimos conectar',
            style: theme.textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: onRetry,
            child: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }
}

class _LoanCapturePermission extends StatelessWidget {
  const _LoanCapturePermission({
    required this.onOpenSettings,
    required this.onRetry,
  });

  final Future<void> Function() onOpenSettings;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.lock_outline,
              size: 72, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(height: 16),
          Text(
            'Necesitamos permisos',
            style: theme.textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Activa los permisos de cámara y almacenamiento para continuar.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: onRetry,
            child: const Text('Intentar de nuevo'),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: onOpenSettings,
            child: const Text('Abrir ajustes'),
          ),
        ],
      ),
    );
  }
}
