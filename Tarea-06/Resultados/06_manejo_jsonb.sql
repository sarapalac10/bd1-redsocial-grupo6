-- Asegurar que existe la columna
ALTER TABLE perfil ADD COLUMN IF NOT EXISTS preferencias_sistema JSONB;

-- 1. Inserción
UPDATE perfil SET preferencias_sistema = '{"tema": "oscuro", "notificaciones": true}' WHERE id_perfil = (SELECT id_perfil FROM perfil LIMIT 1);

-- 2. Consulta (Operador de existencia)
SELECT * FROM perfil WHERE preferencias_sistema @> '{"tema": "oscuro"}';

-- 3. Modificación (jsonb_set)
UPDATE perfil SET preferencias_sistema = jsonb_set(preferencias_sistema, '{tema}', '"claro"') WHERE id_perfil = (SELECT id_perfil FROM perfil LIMIT 1);

-- 4. Eliminación de llave
UPDATE perfil SET preferencias_sistema = preferencias_sistema - 'notificaciones' WHERE id_perfil = (SELECT id_perfil FROM perfil LIMIT 1);