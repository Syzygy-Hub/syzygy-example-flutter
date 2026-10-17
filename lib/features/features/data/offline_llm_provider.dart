import 'package:syzygy_ai_flutter/syzygy_ai_flutter.dart'
    show
        FinishReason,
        InvalidRequest,
        LLMChunk,
        LLMProvider,
        LLMRequest,
        LLMResponse,
        MessageRole;

/// An offline [LLMProvider] for the example. It answers locally, needs no API
/// key and makes no network call. Replace it with a real provider to talk to a
/// model.
class OfflineLLMProvider implements LLMProvider {
  const OfflineLLMProvider();

  static const _providerName = 'offline';

  @override
  Future<LLMResponse> complete(LLMRequest request) async {
    final userMessages = request.messages.where(
      (message) => message.role == MessageRole.user,
    );
    final prompt = userMessages.isEmpty ? '' : userMessages.last.content.trim();
    if (prompt.isEmpty) {
      throw const InvalidRequest('The prompt is empty.');
    }
    return LLMResponse(
      content: 'Offline reply to: $prompt',
      finishReason: FinishReason.stop,
      providerName: _providerName,
      modelName: request.model,
    );
  }

  @override
  Stream<LLMChunk> stream(LLMRequest request) async* {
    final response = await complete(request);
    yield LLMChunk(
      content: response.content,
      providerName: _providerName,
      modelName: request.model,
    );
    yield const LLMChunk(
      finishReason: FinishReason.stop,
      providerName: _providerName,
    );
  }
}
