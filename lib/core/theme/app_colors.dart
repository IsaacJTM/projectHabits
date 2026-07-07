import 'package:flutter/material.dart';

class AppColors{

    // Colores primarios (Cuentas principales, rachas , elementos interactivos)
    static const Color primary = Color(0xFF20C9C2);
    static const Color primaryDark = Color(0xFF005047);
    static const Color primaryLight = Color(0xFFD7F5F3);

    // Secundario (Alertas)
    static const Color secondary = Color(0xFFFF4D6D);
    static const Color secondaryLight = Color(0xFFFFE0E6);

    // Tercreos - estrellas, Usadon en el XP
    static const Color accentYellow = Color(0xFFFFC542);
    static const Color accentYellowLight = Color(0xFFFFF3D6);

    // Neutros
    static const Color background = Color(0xFFF7F8FA);
    static const Color surface = Color(0xFFFFFFFF);
    static const Color textPrimary = Color(0xFF1F2937);
    static const Color textSecondary = Color(0xFF6B7280);
    static const Color border = Color(0xFFE5E7EB);

    // Modo oscuro (Para otras variantes)
    static const Color backgroundDark = Color(0xFF121417);
    static const Color surfaceDark = Color(0xFF1C1F23);
    static const Color textPrimaryDark = Color(0xFFF3F4F6);
    static const Color textSecondaryDark = Color(0xFF9CA3AF);

    // Heatmap (intensidad de cumplimiento)
    static const List<Color> heatmapSale = [
    Color(0xFFE5E7EB), // sin actividad
    Color(0xFFB8ECE9),
    Color(0xFF7FDDD8),
    Color(0xFF45CEC6),
    Color(0xFF20C9C2), // máxima actividad (= primary)
    ];

    //Colores seleccionados al crea un hábito 
    static const List<Color> habitColorOptions = [
    Color(0xFF20C9C2), // teal
    Color(0xFFE74C3C), // rojo
    Color(0xFFFFC542), // amarillo
    Color(0xFF1ABC9C), // verde azulado
    Color(0xFF8E2DE2), // morado
    Color(0xFFFF4D6D), // coral
    ];
}