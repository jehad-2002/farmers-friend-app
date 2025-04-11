import 'package:equatable/equatable.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class User extends Equatable {
  final int? id;
  final String name;
  final String? dateOfBirth;
  final int accountStatus;
  final String? address;
  final int accountType;
  final String? profileImage;
  final String username;
  final String password;
  final String phoneNumber;
  final String? createdAt;
  final String? updatedAt;

  const User({
    this.id,
    required this.name,
    this.dateOfBirth,
    required this.accountStatus,
    this.address,
    required this.accountType,
    this.profileImage,
    required this.username,
    required this.password,
    required this.phoneNumber,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        dateOfBirth,
        accountStatus,
        address,
        accountType,
        profileImage,
        username,
        password,
        phoneNumber,
        createdAt,
        updatedAt
      ];

  Map<String, dynamic> toMap() {
    return {
      'ID': id,
      'Name': name,
      'DateOfBirth': dateOfBirth,
      'AccountStatus': accountStatus,
      'Address': address,
      'AccountType': accountType,
      'ProfileImage': profileImage,
      'Username': username,
      'Password': password,
      'PhoneNumber': phoneNumber,
      'CreatedAt': createdAt,
      'UpdatedAt': updatedAt,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['ID'] as int?,
      name: map['Name'] as String,
      dateOfBirth: map['DateOfBirth'] as String?,
      accountStatus: map['AccountStatus'] as int,
      address: map['Address'] as String?,
      accountType: map['AccountType'] as int,
      profileImage: map['ProfileImage'] as String?,
      username: map['Username'] as String,
      password: map['Password'] as String,
      phoneNumber: map['PhoneNumber'] as String,
      createdAt: map['CreatedAt'] as String?,
      updatedAt: map['UpdatedAt'] as String?,
    );
  }

  static String hashPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  bool verifyPassword(String inputPassword) {
    return password == hashPassword(inputPassword);
  }

  User copyWith({
    int? id,
    String? name,
    String? dateOfBirth,
    int? accountStatus,
    String? address,
    int? accountType,
    String? profileImage,
    String? username,
    String? password,
    String? phoneNumber,
    String? createdAt,
    String? updatedAt,
  }) {
    return User(
        id: id ?? this.id,
        name: name ?? this.name,
        dateOfBirth: dateOfBirth ?? this.dateOfBirth,
        accountStatus: accountStatus ?? this.accountStatus,
        address: address ?? this.address,
        accountType: accountType ?? this.accountType,
        profileImage: profileImage ?? this.profileImage,
        username: username ?? this.username,
        password: password ?? this.password,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt);
  }
}

