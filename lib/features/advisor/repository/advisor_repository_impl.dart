import 'package:injectable/injectable.dart';

import '../data/advisor_datasource.dart';
import '../data/models/advisor_response.dart';
import 'advisor_repository.dart';

/// Delegates the advisor chat use case to the [AdvisorDataSource]. Cubits
/// depend only on the [AdvisorRepository] interface (constitution §2).
@Injectable(as: AdvisorRepository)
class AdvisorRepositoryImpl implements AdvisorRepository {
  AdvisorRepositoryImpl(this._dataSource);

  final AdvisorDataSource _dataSource;

  @override
  Future<AdvisorResponse> sendChat({
    required String message,
    String? sessionId,
  }) =>
      _dataSource.sendChat(message: message, sessionId: sessionId);
}
