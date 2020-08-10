import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'pinned_file.g.dart';

@JsonSerializable()
@HiveType(typeId: 4)
class PinnedFile {
  @HiveField(0)
  final String path;  
  @HiveField(1)
  final String size;
  @HiveField(2)
  final String type;

  PinnedFile({
    this.path,
    this.size,
    this.type,
  });

  factory PinnedFile.fromJson(Map<String, dynamic> json) =>
      _$PinnedFileFromJson(json);

  Map<String, dynamic> toJson() => _$PinnedFileToJson(this);
}
