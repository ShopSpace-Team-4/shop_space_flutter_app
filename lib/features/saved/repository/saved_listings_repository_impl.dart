import 'package:injectable/injectable.dart';

import '../data/models/saved_listing.dart';
import '../data/saved_listings_datasource.dart';
import 'saved_listings_repository.dart';

@Injectable(as: SavedListingsRepository)
class SavedListingsRepositoryImpl implements SavedListingsRepository {
  SavedListingsRepositoryImpl(this._dataSource);

  final SavedListingsDataSource _dataSource;

  @override
  Future<void> save(String listingId) => _dataSource.save(listingId);

  @override
  Future<void> unsave(String listingId) => _dataSource.unsave(listingId);

  @override
  Future<List<SavedListing>> getSavedListings() =>
      _dataSource.getSavedListings();
}
