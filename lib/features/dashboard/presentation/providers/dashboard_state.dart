import '../../domain/entities/dashboard_summary.dart';

class DashboardState {
  final bool isLoading;
  final DashboardSummary? summary;
  final String? error;
  final bool isFromCache;

  const DashboardState({
    this.isLoading = false,
    this.summary,
    this.error,
    this.isFromCache = false,
  });

  DashboardState copyWith({
    bool? isLoading,
    DashboardSummary? summary,
    String? error,
    bool? isFromCache,
  }) {
    return DashboardState(
      isLoading: isLoading ?? this.isLoading,
      summary: summary ?? this.summary,
      error: error,
      isFromCache: isFromCache ?? this.isFromCache,
    );
  }
}
