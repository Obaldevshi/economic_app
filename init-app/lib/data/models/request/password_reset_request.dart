import 'package:json_annotation/json_annotation.dart';

part 'password_reset_request.g.dart';

@JsonSerializable()
class PasswordResetRequest {
  final String email;
  final String language;
  PasswordResetRequest({required this.email, required this.language});
  Map<String, dynamic> toJson() => _$PasswordResetRequestToJson(this);
}

@JsonSerializable()
class PasswordResetConfirmRequest {
  final String email;
  final String code;
  @JsonKey(name: 'new_password')
  final String newPassword;
  PasswordResetConfirmRequest({
    required this.email,
    required this.code,
    required this.newPassword,
  });
  Map<String, dynamic> toJson() => _$PasswordResetConfirmRequestToJson(this);
}
