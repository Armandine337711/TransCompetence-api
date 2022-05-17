BEGIN;
-------------------------------
-- EXTENTION & DOMAIN
-------------------------------

DROP EXTENSION IF EXISTS unaccent;

CREATE EXTENSION unaccent;

DROP DOMAIN IF EXISTS TEXT_ONLY, ALPHANUM, TEXT_MAIL;

CREATE DOMAIN TEXT_ONLY AS TEXT CHECK(unaccent(VALUE) ~ '^[A-Za-z \-]+$');
CREATE DOMAIN ALPHANUM AS TEXT CHECK(unaccent(VALUE) ~ '^[A-Za-z\ \-\#\d]+$');
CREATE DOMAIN TEXT_MAIL AS TEXT CHECK(VALUE ~ '(^[a-z\d\.\-\_]+)@{1}([a-z\d\.\-]{2,})[.]([a-z]{2,5})$');

-------------------------------
-- TABLES
-------------------------------
DROP TABLE IF EXISTS "position", "member", "client";

CREATE TABLE IF NOT EXISTS "position"(
"id" INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
"entitled" TEXT_ONLY NOT NULL UNIQUE
);

INSERT INTO "position"("entitled") VALUES (
('Contrôleur de Gestion'),
('Administrateur'),
('Commercial'),
('Db_Concept')
);

CREATE TABLE IF NOT EXISTS "member"(
"id" INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
"firstname" TEXT_ONLY NOT NULL,
"lastname" TEXT_ONLY NOT NULL,
"email" TEXT_MAIL NOT NULL UNIQUE,
"pwd" TEXT NOT NULL,
"position_id" INT REFERENCES "position"("id") DEFAULT 3,
"createdAt" TIMESTAMPSTZ DEFAULT NOW(),
"updatedAt" TIMESTAMPSTZ DEFAULT NOW(),
"last_connection" TIMESTAMPSTZ
);

CREATE TABLE IF NOT EXISTS "client"(
"id" INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
"business_name" ALPHANUM NOT NULL UNIQUE
);
-------------------------------
-- EXAMPLE CREATE FUNCTION ADD
-------------------------------
DROP FUNCTION IF EXISTS "member_add";

CREATE FUNCTION "member_add"(newDatas json) RETURNS SETOF "member" AS
$$
INSERT INTO "member"("firstname", "lastname", "email", "pwd") VALUES (
    newDatas ->> 'firstname',
    newDatas ->> 'lastname',
    newDatas ->> 'email',
    newDatas ->> 'pwd'

) RETURNING *;
$$
LANGUAGE sql VOLATILE STRICT;

CREATE FUNCTION "client_add"(newDatas json) RETURNS SETOF "client" AS
$$
INSERT INTO "client"("business_name") VALUES (
"business_name" = newDatas ->> 'business_name'
) RETURNING *;
$$
LANGUAGE sql VOLATILE STRICT;

-------------------------------
-- EXAMPLE CREATE FUNCTION UPDATE
-------------------------------
DROP FUNCTION IF EXISTS "member_update";

CREATE FUNCTION "member_update"(updatedDatas json) RETURNS SETOF "member" AS
$$
UPDATE "member" SET
"firstname" = updatedDatas ->> 'firstname',
"lastname" = updatedDatas ->> 'lastname',
"email" = updatedDatas ->> 'email',
"pwd" = updatedDatas ->> 'pwd',
"position_id" = (updatedDatas ->> 'id')::int
"updatedAt" = NOW()
WHERE "id" = (updatedDatas ->> 'id')::int
 RETURNING *;
$$
LANGUAGE sql VOLATILE STRICT;

-- update the last connection of the member
CREATE FUNCTION "connection_update"() RETURNS VOID AS
$$
UPDATE "member" SET
"last_connection" = NOW()
WHERE "id" = (updatedDatas ->> 'id')::int;
$$
LANGUAGE sql VOLATILE STRICT;

COMMIT;