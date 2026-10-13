import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/business_profile_repository.dart';
import '../domain/business_profile.dart';

/// Setup flow states. No business logic in widgets (PRD §9.3).
sealed class SetupState extends Equatable {
  const SetupState();
  @override
  List<Object?> get props => [];
}

class SetupInitial extends SetupState {
  const SetupInitial();
}

class SetupLoading extends SetupState {
  const SetupLoading();
}

class SetupLoaded extends SetupState {
  const SetupLoaded(this.existing);
  final BusinessProfile? existing;
  @override
  List<Object?> get props => [existing];
}

class SetupSaving extends SetupState {
  const SetupSaving();
}

class SetupSuccess extends SetupState {
  const SetupSuccess(this.profile);
  final BusinessProfile profile;
  @override
  List<Object?> get props => [profile];
}

class SetupError extends SetupState {
  const SetupError(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}

class BusinessSetupCubit extends Cubit<SetupState> {
  BusinessSetupCubit(this._repo) : super(const SetupInitial());

  final BusinessProfileRepository _repo;

  Future<void> load() async {
    emit(const SetupLoading());
    final result = await _repo.read();
    result.fold(
      (f) => emit(SetupError(f.message)),
      (p) => emit(SetupLoaded(p)),
    );
  }

  Future<void> save({
    required String businessName,
    String? phone,
    String? address,
    String? receiptFooter,
  }) async {
    emit(const SetupSaving());
    final result = await _repo.save(
      businessName: businessName,
      phone: phone,
      address: address,
      receiptFooter: receiptFooter,
    );
    result.fold(
      (f) => emit(SetupError(f.message)),
      (p) => emit(SetupSuccess(p)),
    );
  }
}
