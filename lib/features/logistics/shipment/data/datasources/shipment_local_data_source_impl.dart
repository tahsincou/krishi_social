import 'package:flutter_mvp_starter/core/database/database_helper.dart';
import 'package:flutter_mvp_starter/features/logistics/shipment/data/datasources/shipment_local_data_source.dart';
import 'package:flutter_mvp_starter/features/logistics/shipment/data/models/shipement_model.dart';
import 'package:sqflite/sqflite.dart';

class ShipmentLocalDataSourceImpl implements ShipmentLocalDataSource {
  final DatabaseHelper databaseHelper;

  ShipmentLocalDataSourceImpl(this.databaseHelper);

  @override
  Future<List<ShipmentModel>> getShipments() async {
    return [];
  }

  @override
  Future<void> replaceShipments(List<ShipmentModel> shipments) async {
    final db = await databaseHelper.database;

    await db.transaction((txn) async {
      await txn.delete('shipments');

      for (final shipment in shipments) {
        await txn.insert(
          'shipments',
          shipment.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    });
  }
}
