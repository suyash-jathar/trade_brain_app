// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'companypricemodel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CompanyPriceModelAdapter extends TypeAdapter<CompanyPriceModel> {
  @override
  final int typeId = 1;

  @override
  CompanyPriceModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CompanyPriceModel(
      symbol: fields[0] as String,
      price: fields[1] as double,
    );
  }

  @override
  void write(BinaryWriter writer, CompanyPriceModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.symbol)
      ..writeByte(1)
      ..write(obj.price);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CompanyPriceModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
