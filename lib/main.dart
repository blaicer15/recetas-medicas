import 'package:flutter/material.dart';
import 'package:recetas/router/main.route.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const supabaseUrl = 'https://fqeulcltjcbymahuvtml.supabase.co';

Future<void> main() async {
  await Supabase.initialize(url: supabaseUrl, anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZxZXVsY2x0amNieW1haHV2dG1sIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzU1NzU5MDUsImV4cCI6MjA1MTE1MTkwNX0.mfo1uy2DCz-S5aOcgc4gf5yUBGND1mJM92GifgBq6Hs',authOptions: const FlutterAuthClientOptions(
    authFlowType: AuthFlowType.pkce,
  ),
      realtimeClientOptions: const RealtimeClientOptions(
        logLevel: RealtimeLogLevel.info,
      ),
      storageOptions: const StorageClientOptions(
        retryAttempts: 10,
      ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: "Recetas medicas",
      routerConfig: appRouter,
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple), useMaterial3: true),
    );
  }


}
