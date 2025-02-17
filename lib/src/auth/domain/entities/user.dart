import 'package:equatable/equatable.dart';

class LocalUser extends Equatable {
  const LocalUser({
    required this.uid,
  });

  const LocalUser.empty()
      : this(
          uid: '',
        );

  final String uid;

  @override
  List<Object?> get props => [uid];

  @override
  String toString() {
    return 'LocalUser uid: $uid';
  }
}
