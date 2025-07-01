# 🗄️ SQLite Integration - FRIENDS Club

## 📋 **Resumen**

Tu aplicación web FRIENDS ahora utiliza **SQLite** para almacenar toda la información localmente en el navegador. Esto significa:

- ✅ **Persistencia local**: Los datos se guardan en el navegador del usuario
- ✅ **Sin servidor**: No necesitas configurar base de datos externa
- ✅ **Offline ready**: Funciona sin conexión a internet
- ✅ **Rendimiento**: Consultas rápidas y eficientes
- ✅ **Privacidad**: Los datos permanecen en el dispositivo del usuario

## 🛠️ **Tecnologías utilizadas**

- **SQL.js**: SQLite compilado a WebAssembly para navegadores
- **localforage**: Persistencia de datos usando IndexedDB
- **TypeScript**: Tipado fuerte para mejor desarrollo

## 📊 **Estructura de la base de datos**

### Tabla `users`
```sql
CREATE TABLE users (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  full_name TEXT NOT NULL,
  email TEXT UNIQUE NOT NULL,
  birth_date TEXT NOT NULL,
  city TEXT NOT NULL,
  favorite_genres TEXT NOT NULL, -- JSON string
  terms_accepted INTEGER NOT NULL DEFAULT 0,
  ticket_code TEXT UNIQUE NOT NULL,
  created_at TEXT DEFAULT CURRENT_TIMESTAMP,
  updated_at TEXT DEFAULT CURRENT_TIMESTAMP
);
```

### Tabla `tickets`
```sql
CREATE TABLE tickets (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER NOT NULL,
  ticket_code TEXT UNIQUE NOT NULL,
  event_name TEXT NOT NULL DEFAULT 'FRIENDS CLUB',
  event_date TEXT NOT NULL DEFAULT '2025-07-05',
  venue TEXT NOT NULL DEFAULT 'TBA',
  status TEXT NOT NULL DEFAULT 'active',
  qr_code_data TEXT,
  created_at TEXT DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users (id)
);
```

### Tabla `ticket_stats`
```sql
CREATE TABLE ticket_stats (
  id INTEGER PRIMARY KEY CHECK (id = 1),
  tickets_generated INTEGER NOT NULL DEFAULT 0,
  max_tickets INTEGER NOT NULL DEFAULT 500,
  updated_at TEXT DEFAULT CURRENT_TIMESTAMP
);
```

## 🚀 **Uso de la aplicación**

### **Desarrollo**
```bash
# Instalar dependencias
npm install

# Ejecutar en desarrollo
npm run dev
```

### **Funcionalidades disponibles**

1. **Registro de usuarios**: 
   - Formulario completo con validación
   - Verificación de emails duplicados
   - Generación automática de códigos de ticket

2. **Estadísticas en tiempo real**:
   - Contador de tickets generados
   - Tickets disponibles restantes
   - Porcentaje de ocupación

3. **Panel de administración**:
   - Agregar `?admin=true` a la URL para activarlo
   - Ver todos los usuarios registrados
   - Estadísticas detalladas
   - Limpiar base de datos (solo desarrollo)

## 🔧 **API Principal**

### **Funciones disponibles**

```typescript
import { 
  registerUser, 
  checkEmailExists, 
  getUserByTicketCode,
  getTicketData,
  getTicketStats,
  getAllUsers,
  clearAllData,
  initDatabase 
} from './lib/sqlite';

// Registrar usuario
const user = await registerUser({
  fullName: "Juan Pérez",
  email: "juan@email.com",
  birthDate: "1995-03-15",
  city: "Lima",
  favoriteGenres: ["Techno", "House"],
  termsAccepted: true
});

// Verificar email
const exists = await checkEmailExists("juan@email.com");

// Obtener estadísticas
const stats = await getTicketStats();
// Resultado: { generated: 5, remaining: 495, maxTickets: 500 }
```

## 🎯 **Ventajas de esta implementación**

### **Para el desarrollador:**
- No necesitas configurar servidor de base de datos
- Desarrollo más rápido y sencillo
- Testing local sin dependencias externas
- Control total sobre el esquema de datos

### **Para el usuario:**
- Carga inicial rápida
- Funcionalidad offline
- Privacidad garantizada (datos locales)
- No requiere registro en servicios externos

### **Para el proyecto:**
- Costo cero de infraestructura
- Escalabilidad horizontal automática
- Sin problemas de latencia de red
- Backup automático local

## 🛡️ **Consideraciones importantes**

### **Persistencia**
- Los datos se almacenan en IndexedDB del navegador
- Persisten entre sesiones del navegador
- Se pierden si el usuario limpia datos del navegador
- No se sincronizan entre dispositivos

### **Limitaciones**
- Máximo ~50MB de datos por dominio (típico)
- Solo acceso desde el navegador donde se guardó
- No hay backup automático en la nube

### **Recomendaciones**
- Implementar exportación de datos para backup
- Considerar migración a servidor si creces mucho
- Informar a usuarios sobre la persistencia local

## 🔍 **Panel de administración**

Para acceder al panel de administración durante desarrollo:

1. Abre la aplicación en el navegador
2. Agrega `?admin=true` al final de la URL
3. Verás un panel flotante en la esquina inferior derecha

**Funciones del panel:**
- Ver cantidad de usuarios registrados
- Estadísticas de tickets en tiempo real
- Lista de últimos usuarios
- Botón para limpiar todos los datos (desarrollo)

## 📱 **Compatibilidad**

- ✅ Chrome/Chromium (recomendado)
- ✅ Firefox
- ✅ Safari
- ✅ Edge
- ❌ Internet Explorer (no soportado)

## 🚨 **Para producción**

Si planeas usar esto en producción, considera:

1. **Backup de datos**: Implementar exportación de datos
2. **Analíticas**: Agregar seguimiento de eventos
3. **Migración**: Plan para migrar a servidor si es necesario
4. **Testing**: Pruebas en diferentes navegadores y dispositivos

## 🎉 **¡Listo para usar!**

Tu aplicación FRIENDS ahora tiene una base de datos SQLite completamente funcional que:

- Se inicializa automáticamente al cargar la aplicación
- Maneja todos los registros de usuarios
- Genera códigos de tickets únicos
- Mantiene estadísticas en tiempo real
- Funciona completamente offline

¡Disfruta desarrollando tu evento! 🎵🎉