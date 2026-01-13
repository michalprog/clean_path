import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/l10n/app_localizations.dart';
import '/providers/achievment_provider.dart';
import '/widgets/achivement_widget.dart';

class AchievementView extends StatelessWidget {
  const AchievementView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final achievementProvider = Provider.of<AchievementProvider>(context, listen: false);
    final l10n = AppLocalizations.of(context)!;

    return FutureBuilder(
      future: achievementProvider.statisticInicjalization(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else {
          return Scaffold(
            appBar: AppBar(
                backgroundColor: Colors.greenAccent,
                centerTitle: true, title: Text(l10n.achievementsTitle)),
            body: Consumer<AchievementProvider>(
              builder: (context, achievementProvider, child) {
                final items = achievementProvider.showAchievements;

                if (items.isEmpty) {
                  return Center(child: Text(l10n.noAchievements));
                }

                // Jeśli masz mniej/więcej niż 20 rekordów, gablotka i tak będzie wyglądać spójnie:
                // - max 20 = 4x5
                final visible = items.take(20).toList();

                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                    // Rama gabloty
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.brown.shade500,
                          Colors.brown.shade800,
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.22),
                          blurRadius: 18,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10), // grubość ramy
                      child: Container(
                        // Wnętrze gabloty (tło + „szkło”)
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.white.withOpacity(0.22),
                              Colors.white.withOpacity(0.08),
                            ],
                          ),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.18),
                            width: 1,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Pasek „tabliczki”
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  color: Colors.black.withOpacity(0.18),
                                  border: Border.all(color: Colors.white.withOpacity(0.18)),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.emoji_events, color: Colors.white.withOpacity(0.9)),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        l10n.achievementsTitle,
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.95),
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 0.2,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 12),

                              // Siatka 4x5
                              Expanded(
                                child: GridView.builder(
                                  itemCount: visible.length,
                                  physics: const BouncingScrollPhysics(),
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 4,
                                    crossAxisSpacing: 12,
                                    mainAxisSpacing: 12,
                                    childAspectRatio: 1,
                                  ),
                                  itemBuilder: (context, index) {
                                    final record = visible[index];
                                    return AchievementWidget(record: record);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }
}
