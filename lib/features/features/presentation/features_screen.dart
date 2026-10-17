import 'package:flutter/material.dart';
import 'package:syzygy_ai_flutter/syzygy_ai_flutter.dart'
    show AIError, LLMMessage, LLMProvider, LLMRequest, MessageRole;
import 'package:syzygy_core_flutter/syzygy_core_flutter.dart'
    show ConfigKey, ConfigRegistry, FeatureFlag, InMemoryFeatureFlagProvider;
import 'package:syzygy_foundation_flutter/syzygy_foundation_flutter.dart'
    show StorageKey, StorageProvider, SyzygyID;
import 'package:syzygy_ui_flutter/syzygy_ui_flutter.dart'
    show AppSpacing, CardView, PrimaryButton, ProgressBar;

import '../../../core/extensions/context_extensions.dart';
import '../../../di/app_module.dart';
import '../data/offline_llm_provider.dart';

class _DemoItem {}

/// A small demonstration of each Syzygy layer, using only public APIs and no
/// keys.
class FeaturesScreen extends StatefulWidget {
  const FeaturesScreen({super.key});

  @override
  State<FeaturesScreen> createState() => _FeaturesScreenState();
}

class _FeaturesScreenState extends State<FeaturesScreen> {
  String _foundation = '';
  String _core = '';
  String _services = '';
  String _ai = '';
  double _progress = 0;

  @override
  void initState() {
    super.initState();
    _runDemos();
  }

  Future<void> _runDemos() async {
    setState(() => _progress = 0);

    // Foundation: a typed identifier.
    final id = SyzygyID.generate<_DemoItem>();
    _update(() => _foundation = id.toString(), 0.2);

    // Core: a config value and a feature flag, each with a default.
    try {
      final registry = appContainer.resolve<ConfigRegistry>();
      final flags = appContainer.resolve<InMemoryFeatureFlagProvider>();
      final greeting = registry.get(
        const ConfigKey<String>(
          'example.greeting',
          defaultValue: 'Hello from Core',
        ),
      );
      final enabled = flags.value(
        const FeatureFlag<bool>(
          key: 'example.showAIDemo',
          defaultValue: true,
          description: 'Shows the AI demo',
        ),
      );
      _update(() => _core = '$greeting | flag: ${enabled ? 'on' : 'off'}', 0.4);
    } catch (error) {
      _update(() => _core = 'Core registry unavailable: $error', 0.4);
    }

    // Services: storage write and read, handling the storage error type.
    try {
      final storage = appContainer.resolve<StorageProvider>();
      const key = StorageKey<String>('example.lastRun');
      storage.set<String>('run ${DateTime.now().toIso8601String()}', key);
      final stored = storage.get<String>(key);
      _update(() => _services = 'Stored: ${stored ?? 'nothing'}', 0.6);
    } on StateError catch (error) {
      _update(() => _services = 'Storage error: ${error.message}', 0.6);
    } catch (error) {
      _update(() => _services = 'Storage unavailable: $error', 0.6);
    }

    // AI: one call through the LLMProvider contract with the offline provider.
    const LLMProvider provider = OfflineLLMProvider();
    const request = LLMRequest(
      messages: [LLMMessage(role: MessageRole.user, content: 'Hello Syzygy')],
      model: 'offline-demo',
    );
    try {
      final response = await provider.complete(request);
      _update(
        () => _ai = '${response.content} (${response.providerName ?? 'unknown'})',
        1,
      );
    } on AIError catch (error) {
      _update(() => _ai = 'AI error: ${error.message}', 1);
    }
  }

  void _update(VoidCallback change, double progress) {
    if (!mounted) return;
    setState(() {
      change();
      _progress = progress;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Features')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            _LayerCard(
              title: 'Foundation',
              detail: 'SyzygyID.generate<T>()',
              result: _foundation,
            ),
            const SizedBox(height: AppSpacing.md),
            _LayerCard(
              title: 'Core',
              detail: 'ConfigRegistry.get and FeatureFlag, each with a default',
              result: _core,
            ),
            const SizedBox(height: AppSpacing.md),
            _LayerCard(
              title: 'Services',
              detail: 'StorageProvider.set and get, StateError on a bad type',
              result: _services,
            ),
            const SizedBox(height: AppSpacing.md),
            _LayerCard(
              title: 'AI',
              detail: 'LLMProvider.complete with the offline provider',
              result: _ai,
            ),
            const SizedBox(height: AppSpacing.md),
            CardView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('UI', style: context.textTheme.titleMedium),
                  Text(
                    'PrimaryButton, CardView and ProgressBar from '
                    'syzygy_ui_flutter',
                    style: context.textTheme.bodySmall,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  ProgressBar(progress: _progress),
                  const SizedBox(height: AppSpacing.sm),
                  PrimaryButton(
                    label: 'Run the layer demos',
                    onPressed: _runDemos,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LayerCard extends StatelessWidget {
  const _LayerCard({
    required this.title,
    required this.detail,
    required this.result,
  });

  final String title;
  final String detail;
  final String result;

  @override
  Widget build(BuildContext context) {
    return CardView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: context.textTheme.titleMedium),
          Text(detail, style: context.textTheme.bodySmall),
          const SizedBox(height: AppSpacing.xs),
          Text(
            result.isEmpty ? 'Not run yet' : result,
            style: context.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
