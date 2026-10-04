import '../../domain/entities/registration.dart';

/// Wire form of a [Registration], as `POST /auth/register` expects it.
///
/// Owns the JSON contract so the domain entity never learns the API's field
/// names. Optional parts are omitted rather than sent as `null`.
class RegistrationRequestModel {
  const RegistrationRequestModel(this._registration);

  final Registration _registration;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'firstName': _registration.firstName,
    'surname': _registration.surname,
    if (_registration.otherNames != null)
      'otherNames': _registration.otherNames,
    'email': _registration.email,
    if (_registration.phone != null) 'phone': _registration.phone,
    'password': _registration.password,
  };
}
