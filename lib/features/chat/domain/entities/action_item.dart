import 'package:freezed_annotation/freezed_annotation.dart';

part 'action_item.freezed.dart';
part 'action_item.g.dart';

@freezed
abstract class ActionItem with _$ActionItem {
  const factory ActionItem({
    required String id,
    required String task,
    required String? assignee,
    required DateTime? dueDate,
    @Default(false) bool isCompleted,
  }) = _ActionItem;

  factory ActionItem.fromJson(Map<String, dynamic> json) => _$ActionItemFromJson(json);
}
