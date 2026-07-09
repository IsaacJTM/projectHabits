import 'package:apphabitsv01/core/theme/app_colors.dart';
import 'package:apphabitsv01/core/util/icon_mapper.dart';
import 'package:apphabitsv01/features/auth/data/auth_repository.dart';
import 'package:apphabitsv01/features/habits/data/habits_provider.dart';
import 'package:apphabitsv01/features/habits/data/models/habit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateHabitScreen extends ConsumerStatefulWidget {
  final Habit? existingHabit;
  const CreateHabitScreen({super.key, this.existingHabit});

  @override
  ConsumerState<CreateHabitScreen> createState() => _CreateHabitScreenState();
}

class _CreateHabitScreenState extends ConsumerState<CreateHabitScreen> {
  late final _nameController = TextEditingController(text: widget.existingHabit?.name);

  static const _weekDays = ['L', 'M', 'M', 'J', 'V', 'S', 'D'];

  late IconData _selectedIcon = widget.existingHabit?.icon ?? IconMapper.allIcons.first; 
  late Color _selectedColor = widget.existingHabit?.color ?? AppColors.habitColorOptions.first;
  late Set<int> _selectedDays = widget.existingHabit != null 
      ? widget.existingHabit!.activeDays
        .map((toElement) => _weekDays.indexOf(toElement))
        .where((index) => index >= 0)
        .toSet()
      : {0,1,2,3,4};

  bool _reminderEnabled = true;
  TimeOfDay _reminderTime = const TimeOfDay(hour: 8, minute: 30);
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final existing = widget.existingHabit;
    if (existing != null) {
      _reminderEnabled = existing.reminderEnabled;
      _reminderTime = existing.reminderTime ?? _reminderTime;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickTime() async{
    final picked = await showTimePicker(context: context, initialTime: _reminderTime);
    if(picked != null ) setState(() => _reminderTime = picked);
  }

 Future<void> _save() async{
  if(_nameController.text.trim().isEmpty || _isSaving) return;
  setState(() => _isSaving = true);
  final habit = Habit(
    id: widget.existingHabit?.id ?? '', 
    name: _nameController.text, 
    icon: _selectedIcon, 
    color: _selectedColor, 
    goalDescription: widget.existingHabit?.goalDescription ?? 'Meta diario personal', 
    currentStreak: widget.existingHabit?.currentStreak ?? 0, 
    longestStreak: widget.existingHabit?.longestStreak ?? 0, 
    activeDays: _selectedDays.map((index) => _weekDays[index]).toList(),
    reminderTime: _reminderEnabled ? _reminderTime : null,
    reminderEnabled: _reminderEnabled
  );

  final uid = ref.read(authRepositoryProvider).currentUser!.uid;
  final repo = ref.read(habitsRepositoryProvider);

  try{
    if(widget.existingHabit != null){
      await repo.updateHabit(uid, habit);
    }else{
      await repo.addHabit(uid, habit);
    }
    if (mounted) Navigator.of(context).pop();
  }catch (e){
    if(mounted) {
      ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Error al guardar : $e')));
    }
  }finally{
    if(mounted) setState(() => _isSaving = false);
  }
 }



  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existingHabit != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar Hábito': 'Nuevo Hábito'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Nombre del Hábito', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              hintText: 'Ej: Meditación matutina',
              filled: true,
              fillColor: AppColors.secondaryContainer,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide.none
              )
            ),
          ),
          const SizedBox(height: 16),
          Text('Icono', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(8),
            color: AppColors.primaryContainer,
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: IconMapper.allIcons.map((icon) {
                final selected = icon == _selectedIcon;
                return GestureDetector(
                  onTap: () => setState(() => _selectedIcon = icon),
                  child: Container(
                    width: 55,
                    height: 55,
                    decoration: BoxDecoration(
                      color:  selected ? AppColors.primary : AppColors.secondaryContainer,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: selected ? AppColors.primary : AppColors.border,
                        width: selected ? 2 : 0,
                      )
                    ),
                    child: Icon(icon, color: selected ? AppColors.primaryDark : AppColors.textSecondary),
                  ),
                );
              }).toList()
            ),
          ),
          const SizedBox(height: 16),
          Text('Color', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Container(
            padding:  const EdgeInsets.all(8),
            color: AppColors.primaryContainer,
            child: Wrap(
              spacing: 12,
              children: AppColors.habitColorOptions.map((color){
                final selected = color == _selectedColor;
                return GestureDetector(
                  onTap: () => setState(() => _selectedColor = color),
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: selected ? Border.all(color: color, width: 2) : null
                    ),
                   padding: const EdgeInsets.all(3),
                   child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: color
                    ),
                   ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),
          Text('Frecuencia', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(_weekDays.length, (index){
              final  selected = _selectedDays.contains(index);
              return GestureDetector(
                onTap: () => setState(() {
                  selected ? _selectedDays.remove(index) : _selectedDays.add(index);
                }),
                child: Container(
                  width: 42,
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: selected ? AppColors.primary : AppColors.secondaryContainer ,
                    borderRadius: BorderRadius.circular(8)
                  ),
                  child: Text(
                    _weekDays[index],
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
                  Text('Recordatorio', style: Theme.of(context).textTheme.titleMedium),
                  Row(
                    children: [
                      Text(
                        _reminderEnabled ? 'Activado' : 'Desactivado', 
                        style: TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.bold),
                      ),
                      Switch(
                        value: _reminderEnabled, 
                        onChanged: (valor) => setState(() => _reminderEnabled = valor)
                      )
                    ],
                  )
            ],
          ),
          const SizedBox(height: 8),
          if (_reminderEnabled)
          GestureDetector(
            onTap: _pickTime,
            child:  Container(
            height: 60,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: AppColors.secondaryContainer
            ),
                  child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.notifications_none_rounded, size: 25, color: AppColors.primaryDark),
                        Text(_reminderTime.format(context), style: TextStyle(fontSize: 20),)
                      ],
                    ),
                    Text('Cambiar', style: TextStyle(fontWeight: FontWeight.bold,color:  AppColors.primaryDark),)
                  ],
                ),
            )
          ),

          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isSaving ? null : _save,
              style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryDark,
                        foregroundColor: AppColors.surface,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.circular(8)
                        )
                    ),
              child: Text('Guardar hábito', style: TextStyle(color: Colors.white),)
            ),
          )
        ],
      )
    );
  }
}