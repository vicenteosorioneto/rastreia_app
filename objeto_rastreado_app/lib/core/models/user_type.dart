import 'package:flutter/material.dart';

enum UserType {
  cidadao,
  policial,
}

extension UserTypeExtension on UserType {
  String get label {
    switch (this) {
      case UserType.cidadao:
        return 'Cidadão';
      case UserType.policial:
        return 'Policial';
    }
  }

  String get description {
    switch (this) {
      case UserType.cidadao:
        return 'Registre e acompanhe objetos roubados';
      case UserType.policial:
        return 'Acesse e gerencie ocorrências registradas';
    }
  }

  IconData get icon {
    switch (this) {
      case UserType.cidadao:
        return Icons.person_outline;
      case UserType.policial:
        return Icons.local_police_outlined;
    }
  }
}
