import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/event.dart';

class EventService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<Event>> getUpcomingEvents() async {
    try {
      // On utilise le début de la journée actuelle pour la comparaison
      final now = DateTime.now();
      final startOfDay = DateTime(now.year, now.month, now.day).toIso8601String();
      
      final response = await _supabase
          .from('events')
          .select()
          .gte('end_date', startOfDay) // On vérifie que l'événement n'est pas terminé
          .order('start_date')
          .limit(10);

      final events = response.map((json) => Event.fromJson(json)).toList();
      
      // Filtrage supplémentaire pour s'assurer que les dates sont valides
      return events.where((event) => 
        event.endDate.isAfter(now) || // L'événement n'est pas terminé
        (event.endDate.year == now.year && 
         event.endDate.month == now.month && 
         event.endDate.day == now.day) // Ou se termine aujourd'hui
      ).toList();
    } catch (e) {
      throw Exception('Erreur lors de la récupération des événements: $e');
    }
  }

  Future<Event> getEventById(String id) async {
    try {
      final response = await _supabase
          .from('events')
          .select()
          .eq('id', id)
          .single();

      return Event.fromJson(response);
    } catch (e) {
      throw Exception('Erreur lors de la récupération de l\'événement: $e');
    }
  }

  // Méthode utilitaire pour obtenir le prochain samedi
  DateTime getNextSaturday() {
    final now = DateTime.now();
    final daysUntilSaturday = (DateTime.saturday - now.weekday) % 7;
    return DateTime(now.year, now.month, now.day + daysUntilSaturday);
  }

  // Méthode utilitaire pour obtenir le dimanche suivant un samedi donné
  DateTime getNextSunday(DateTime saturday) {
    return DateTime(saturday.year, saturday.month, saturday.day + 1);
  }
} 