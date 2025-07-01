-- ====================================
-- EJECUTAR EN SUPABASE SQL EDITOR
-- ====================================

-- 1. Crear tabla USERS
CREATE TABLE users (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    full_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    birth_date DATE NOT NULL,
    city VARCHAR(255) NOT NULL,
    whatsapp VARCHAR(20) NOT NULL,
    favorite_genres TEXT[] NOT NULL DEFAULT '{}',
    terms_accepted BOOLEAN NOT NULL DEFAULT false,
    ticket_code VARCHAR(10) UNIQUE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 2. Crear índices para USERS
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_ticket_code ON users(ticket_code);
CREATE INDEX idx_users_created_at ON users(created_at);

-- 3. Crear tabla TICKETS
CREATE TABLE tickets (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    ticket_code VARCHAR(10) UNIQUE NOT NULL,
    event_date DATE NOT NULL DEFAULT '2025-07-05',
    event_name VARCHAR(255) NOT NULL DEFAULT 'FRIENDS - 05 DE JULIO 2025',
    venue VARCHAR(255) NOT NULL DEFAULT 'TBD',
    is_valid BOOLEAN NOT NULL DEFAULT true,
    used_at TIMESTAMP WITH TIME ZONE NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 4. Crear índices para TICKETS
CREATE INDEX idx_tickets_user_id ON tickets(user_id);
CREATE INDEX idx_tickets_ticket_code ON tickets(ticket_code);
CREATE INDEX idx_tickets_event_date ON tickets(event_date);

-- 5. Crear tabla EVENT_STATS
CREATE TABLE event_stats (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    total_registrations INTEGER NOT NULL DEFAULT 0,
    capacity_percentage DECIMAL(5,2) NOT NULL DEFAULT 0.00,
    max_capacity INTEGER NOT NULL DEFAULT 1000,
    last_updated TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 6. Insertar datos iniciales
INSERT INTO event_stats (total_registrations, capacity_percentage, max_capacity) 
VALUES (0, 0.00, 1000);

-- 7. Crear función para actualizar updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- 8. Trigger para actualizar updated_at en users
CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- 9. Función para crear ticket automáticamente
CREATE OR REPLACE FUNCTION create_user_ticket()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO tickets (user_id, ticket_code, event_date, event_name, venue)
    VALUES (
        NEW.id,
        NEW.ticket_code,
        '2025-07-05',
        'FRIENDS - 05 DE JULIO 2025',
        'TBD'
    );
    RETURN NEW;
END;
$$ language 'plpgsql';

-- 10. Trigger para crear ticket automáticamente
CREATE TRIGGER create_ticket_on_user_insert 
    AFTER INSERT ON users
    FOR EACH ROW EXECUTE FUNCTION create_user_ticket();

-- 11. Función para actualizar estadísticas
CREATE OR REPLACE FUNCTION update_event_stats()
RETURNS TRIGGER AS $$
DECLARE
    total_count INTEGER;
    capacity_pct DECIMAL(5,2);
    max_cap INTEGER;
BEGIN
    SELECT COUNT(*) INTO total_count FROM users;
    SELECT max_capacity INTO max_cap FROM event_stats ORDER BY last_updated DESC LIMIT 1;
    capacity_pct := (total_count::DECIMAL / max_cap::DECIMAL) * 100;
    
    UPDATE event_stats 
    SET total_registrations = total_count,
        capacity_percentage = capacity_pct,
        last_updated = NOW()
    WHERE id = (SELECT id FROM event_stats ORDER BY last_updated DESC LIMIT 1);
    
    RETURN NULL;
END;
$$ language 'plpgsql';

-- 12. Triggers para actualizar estadísticas
CREATE TRIGGER update_stats_on_user_insert 
    AFTER INSERT ON users
    FOR EACH ROW EXECUTE FUNCTION update_event_stats();

CREATE TRIGGER update_stats_on_user_delete 
    AFTER DELETE ON users
    FOR EACH ROW EXECUTE FUNCTION update_event_stats();

-- 13. Habilitar RLS (Row Level Security)
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE tickets ENABLE ROW LEVEL SECURITY;
ALTER TABLE event_stats ENABLE ROW LEVEL SECURITY;

-- 14. Políticas de seguridad
CREATE POLICY "Permitir inserción pública de usuarios" ON users
    FOR INSERT WITH CHECK (true);

CREATE POLICY "Permitir lectura de usuarios" ON users
    FOR SELECT USING (true);

CREATE POLICY "Permitir lectura de tickets" ON tickets
    FOR SELECT USING (true);

CREATE POLICY "Permitir lectura pública de estadísticas" ON event_stats
    FOR SELECT USING (true);

-- ====================================
-- ¡MIGRACIÓN COMPLETADA!
-- ==================================== 