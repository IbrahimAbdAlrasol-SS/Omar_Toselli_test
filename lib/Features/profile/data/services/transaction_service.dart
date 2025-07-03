
import 'package:Tosell/core/api/client/BaseClient.dart';
import 'package:Tosell/core/api/endpoints/APIendpoint.dart';
import 'package:Tosell/features/profile/data/models/transaction.dart';

class TransactionService {
  final BaseClient<Transaction> baseClient;

  TransactionService()
      : baseClient = BaseClient<Transaction>(
            fromJson: (json) => Transaction.fromJson(json));

  Future<List<Transaction>> getAllTransactions() async {
    try {
      var result =
          await baseClient.getAll(endpoint: ProfileEndpoints.transactions);
      if (result.data == null) return [];
      return result.data!;
    } catch (e) {
      rethrow;
    }
  }
}
