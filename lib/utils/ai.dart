import 'package:path_provider/path_provider.dart';
// ai
import 'package:aub_ai/aub_ai.dart';
import 'package:aub_ai/prompt_template.dart';

const modelFilename = 'llama-2-7b.Q4_K_M.gguf';

Future<String> get _localFilePath async {
  String applicationSupportDirectory =
      (await getApplicationSupportDirectory()).path;
  return '${applicationSupportDirectory}/${modelFilename}';
}

Future<String> talkToAi(String prompt) async {
  String filePath = await _localFilePath;
  String aiResponse = '';

// TODO: need to review this so that it is specific to the app use case
  final promptTemplate = PromptTemplate.chatML().copyWith(
    prompt: prompt,
  );

  // THe main function that does all the magic.
  await talkAsync(
    filePathToModel: filePath,
    promptTemplate: promptTemplate,
    onTokenGenerated: (String token) {
      aiResponse += token;
    },
  );

  return aiResponse;
}
