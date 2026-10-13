import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stockroom/core/widgets/app_states.dart';
import 'package:stockroom/features/onboarding/data/business_profile_repository.dart';
import 'package:stockroom/features/onboarding/presentation/setup_cubit.dart';
import 'package:stockroom/features/onboarding/presentation/setup_screen.dart';

class _MockRepo extends Mock implements BusinessProfileRepository {}

void main() {
  testWidgets('empty state shows action', (tester) async {
    var tapped = false;
    await tester.pumpWidget(
      MaterialApp(
        home: AppEmpty(
          icon: Icons.store_outlined,
          title: 'No sales yet today',
          message: 'Add your first product.',
          actionLabel: 'Add product',
          onAction: () => tapped = true,
        ),
      ),
    );
    expect(find.text('No sales yet today'), findsOneWidget);
    await tester.tap(find.text('Add product'));
    expect(tapped, isTrue);
  });

  testWidgets('setup requires business name', (tester) async {
    final repo = _MockRepo();
    when(() => repo.read()).thenAnswer((_) async => const Right(null));
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider(
          create: (_) => BusinessSetupCubit(repo),
          child: const SetupScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Save and continue'), findsOneWidget);
    await tester.tap(find.text('Save and continue'));
    await tester.pump();
    expect(find.text('Business name is required'), findsOneWidget);
    verifyNever(() => repo.save(businessName: any(named: 'businessName')));
  });
}
