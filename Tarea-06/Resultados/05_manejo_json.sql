
-- Asegurar que existe la columna
ALTER TABLE perfil ADD COLUMN IF NOT EXISTS configuracion_privacidad JSON;

-- 1. Inserción
UPDATE perfil SET configuracion_privacidad = '{"perfil_publico": true, "idioma": "es"}' WHERE id_perfil = (SELECT id_perfil FROM perfil LIMIT 1);

-- 2. Consulta
SELECT configuracion_privacidad->>'idioma' FROM perfil WHERE configuracion_privacidad IS NOT NULL;

-- 3. Modificación
UPDATE perfil SET configuracion_privacidad = '{"perfil_publico": false, "idioma": "en"}' WHERE id_perfil = (SELECT id_perfil FROM perfil LIMIT 1);

-- 4. Eliminación (Cast a jsonb para operar)
UPDATE perfil SET configuracion_privacidad = (configuracion_privacidad::jsonb - 'idioma')::json WHERE id_perfil = (SELECT id_perfil FROM perfil LIMIT 1);