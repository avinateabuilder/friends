-- ====================================
-- ARREGLAR POLÍTICAS RLS
-- EJECUTAR EN SUPABASE SQL EDITOR
-- ====================================

-- 1. Agregar política para permitir inserción en tickets (necesario para triggers)
CREATE POLICY "Permitir inserción automática de tickets" ON tickets
    FOR INSERT WITH CHECK (true);

-- 2. Agregar política para permitir inserción en event_stats (por si acaso)
CREATE POLICY "Permitir inserción de estadísticas" ON event_stats
    FOR INSERT WITH CHECK (true);

-- 3. Agregar política para permitir actualización de event_stats (necesario para triggers)
CREATE POLICY "Permitir actualización de estadísticas" ON event_stats
    FOR UPDATE USING (true) WITH CHECK (true);

-- 4. Verificar que todas las políticas estén correctas
SELECT 
    schemaname, 
    tablename, 
    policyname, 
    cmd, 
    roles
FROM pg_policies 
WHERE schemaname = 'public' 
ORDER BY tablename, cmd;

-- ====================================
-- RESULTADO ESPERADO:
-- ====================================
-- users: INSERT + SELECT policies ✓
-- tickets: INSERT + SELECT policies ✓  
-- event_stats: INSERT + UPDATE + SELECT policies ✓
-- ==================================== 