
import 'package:apphabitsv01/features/habits/data/models/habit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

final _dateFormat = DateFormat('yyyy-MM-dd');

class HabitsRepository {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _habitsCol(String uid) =>
    _firestore.collection('users').doc(uid).collection('habits');

  DocumentReference<Map<String, dynamic>> _userDoc(String uid) =>
    _firestore.collection('users').doc(uid);


  Stream<List<Habit>> watchHabits(String uid){
    return _habitsCol(uid).snapshots().asyncMap((snapshot) async {
      final todayId = _dateFormat.format(DateTime.now());
      final habits = <Habit>[];
      for( final doc in snapshot.docs){
        final checkinDoc = await doc.reference.collection('checkins').doc(todayId).get();
        habits.add(Habit.fromDoc(doc, completedToday: checkinDoc.data()?['completed'] == true));
      }
      return habits;
    });
  }

  //Agregar un nuevo habito
  Future<void> addHabit(String uid, Habit habit) async{
    await _habitsCol(uid).add(habit.toMap());
  }

  //Acutalizar un  hábito
  Future<void> updateHabit(String uid, Habit habit) async{
    await _habitsCol(uid).doc(habit.id).update(habit.toMap());
  }

  //Eliminar un hábito
  Future<void> deleteHaibt(String uid, String habitId) async{
    await _habitsCol(uid).doc(habitId).delete();
  }


  //Marcar/desmarcar el check-in de hoy
  // otorgar XP y desbloquear badges por hitos de racha
  Future<CheckInResult?> toggleCheckIn(String uid, Habit habit) async{
    final todayId = _dateFormat.format(DateTime.now());
    final habitRef = _habitsCol(uid).doc(habit.id);
    final checkinRef = habitRef.collection('checkins').doc(todayId);
    final userRef = _userDoc(uid);

    return _firestore.runTransaction<CheckInResult?>((valor) async {
      final checkinSnap = await valor.get(checkinRef);
      final wasCompleted = checkinSnap.data()?['completed'] == true;
      final nowCompleted = !wasCompleted;
      
      final newStreak = nowCompleted ? habit.currentStreak + 1 : habit.currentStreak -1;
      final newLongest = newStreak > habit.longestStreak ? newStreak : habit.longestStreak;

      valor.set(checkinRef, {
        'completed': nowCompleted,
        'completedAt': FieldValue.serverTimestamp(),
      });

      valor.update(habitRef, {
        'currentStreak' : newStreak,
        'longestStreak' : newLongest,
      });

      if(!nowCompleted) return null; // se des-marcó, no hay celebration

      const xpPerCheckIn = 10;
      final newBadges = <String>[];
      if(newStreak == 7) newBadges.add('week_warrior');
      if(newStreak == 30) newBadges.add('century_club');

      return CheckInResult(
        newStreak: newStreak, 
        xpEarned: xpPerCheckIn, 
        newLYUnlockedBeadgeIds: newBadges
        );
    });
  } 

  Stream<Map<DateTime, double>> watchHeatmap(String uid, String habitId, {int days = 60}){
    final habitRef = _habitsCol(uid).doc(habitId);
    return habitRef.collection('checkins').snapshots().map((snapshot){
       final map = <DateTime, double>{};
       for(final doc in snapshot.docs){
        final parts = doc.id.split('-').map(int.parse).toList();
        final date = DateTime(parts[0], parts[1], parts[2]);
        map[date] = (doc.data()['completed'] == true) ? 1.0 : 0.0;
       }
       return map;
    });
  }

}

class CheckInResult{
  final int newStreak;
  final int xpEarned;
  final List<String> newLYUnlockedBeadgeIds;

  const CheckInResult({
    required this.newStreak,
    required this.xpEarned,
    required this.newLYUnlockedBeadgeIds
  });
}