

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meal_plan_app/features/auth/infrastructure/infrastructure.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'repository_provider.g.dart';

@riverpod
AuthRepositoryImpl authRepository(Ref ref) {
  return AuthRepositoryImpl(SupabaseDatasourceImpl(Supabase.instance.client));
}