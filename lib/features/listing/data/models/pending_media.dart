import 'package:image_picker/image_picker.dart' show XFile;

/// A photo staged in the create/edit form but not yet uploaded to the backend
/// (data-model.md §3.3). Lives only in the `ListingFormCubit` state — never
/// serialized or sent directly.
class PendingMedia {
  const PendingMedia({required this.file, required this.clientId});

  final XFile file;

  /// Local identity for reordering while the file is unpersisted.
  final int clientId;
}
