// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'companyhivemodel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CompanyHiveModelAdapter extends TypeAdapter<CompanyHiveModel> {
  @override
  final int typeId = 0;

  @override
  CompanyHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CompanyHiveModel(
      name: fields[0] as String,
      currency: fields[1] as String,
      symbol: fields[2] as String,
      price: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, CompanyHiveModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.currency)
      ..writeByte(2)
      ..write(obj.symbol)
      ..writeByte(3)
      ..write(obj.price);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CompanyHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
