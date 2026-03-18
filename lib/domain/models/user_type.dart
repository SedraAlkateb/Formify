import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum UserType {
  specialist,   // مختص
  student,      // طالب
  pharmacist,   // صيدلي
  resident,     // مقيم
  other,        // غير ذلك


}
extension UserTypeExtension on UserType {

  int get id {
    switch (this) {
      case UserType.specialist:
        return 1;
      case UserType.student:
        return 2;
      case UserType.pharmacist:
        return 3;
      case UserType.resident:
        return 4;
      case UserType.other:
        return 5;
    }
  }
  String get nameAr {
    switch (this) {
      case UserType.specialist:
        return "مختص";
      case UserType.student:
        return "طالب";
      case UserType.resident:
        return "مقيم";
      case UserType.pharmacist:
        return "صيدلي";
      case UserType.other:
        return "غير ذلك";
    }
  }
  String get nameEng {
    switch (this) {
      case UserType.specialist:
        return "specialist";
      case UserType.student:
        return "student";
      case UserType.resident:
        return "resident";
      case UserType.pharmacist:
        return "pharmacist";
      case UserType.other:
        return "other";
    }
  }
  IconData get icon {
    switch (this) {
      case UserType.specialist:
        return Icons.medical_services_outlined; // مختص
      case UserType.student:
        return Icons.school_outlined; // طالب
      case UserType.pharmacist:
        return Icons.local_pharmacy_outlined; // صيدلي
      case UserType.resident:
        return Icons.badge_outlined; // مقيم
      default:
        return Icons.more_horiz_outlined; // غير ذلك
    }
  }
  String toValue() {
    switch (this) {
      case UserType.specialist:
        return "specialist";
      case UserType.student:
        return "student";
      case UserType.resident:
        return "resident";
      case UserType.pharmacist:
        return "pharmacist";
      case UserType.other:
        return "other";
    }
  }

}  UserType userTypeFromString(String value) {
  switch (value.toLowerCase()) {
    case "مختص":
      return UserType.specialist;
    case "طالب":
      return UserType.student;
    case "مقيم":
      return UserType.resident;
    case "صيدلي":
      return UserType.pharmacist;
    default:
      return UserType.other;
  }
}
UserType userTypeFromId(int id) {
  switch (id) {
    case 1:
      return UserType.specialist;
    case 2:
      return UserType.student;
    case 3:
      return UserType.pharmacist;
    case 4:
      return UserType.resident;
    default:
      return UserType.other;
  }
}