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

CREATE TABLE IF NOT EXISTS "loading_unit"(
"id" INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
"unit" TEXT_ONLY NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS "financing_method"(
"id" INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
"method" TEXT_ONLY NOT NULL UNIQUE
);

INSERT INTO "financing_method"("method") VALUES (
    ('Emprunt'),
    ('Crédit Bail'),
    ('Location financière');
)

CREATE TABLE IF NOT EXISTS "financial_datas"(
    "id" INT GENERATED ALWAYS AS IDENTITY KEY,
    "yearly_mileage" INT NOT NULL,
    "in_charge_mileage" INT NOT NULL -- <= yearly
    "nb_towed_vehicles" INT -- 0 ou 1
    "nb_days_in_operation" INT -- <365
    "loading_unit_id" INT NOT NULL REFERENCES "loading_unit"("id"),
    "loading_capacity" INT,
    "capacity_utilisation_factor" FLOAT, -- >100
    "gazoline_consumption" FLOAT,
    "average_price_liter" FLOAT,
    "proportion_tanker_supply" FLOAT, -- <100
    "average_price_liter_tanker" FLOAT,
    "km_cost_tyres" FLOAT,
    "nb_tyres_motor_vehicle" INT,
    "nb_tyres_towed_vehicle" INT,
    "price_tyre_motor_vehicle" FLOAT,
    "price_tyre_towed_vehicle" FLOAT,
    "lifetime_motor_vehicle" INT, -- ou float ?
    "lifetime_towed_vehicle" INT,
    "yearly_maintenance_cost" FLOAT,
    "yearly_toll_cost", FLOAT -- trad toll = péage
    "duration_motor_vehicle_use" INT -- ou float ?
    "motor_vehicle_loading_unit_id" INT REFERENCES "loading_unit"("id"), -- 1 2 ou 3  default valeur ?
    "value_motor_vehicle" FLOAT, --ou INT
    "motor_vehicle_loan_amount" FLOAT, -- si emprunt
    "motor_vehicle_borrowing_rate" FLOAT, -- <100 si emprunt
    "motor_vehicle_loan_duration" INT, -- si emprunt
    "mv_resale_value" FLOAT, -- si emprunt
    "mv_contract_length" INT -- si LLD ou crédit bail
    "mv_monthly_rental_amount" FLOAT,
    "optional purchase value" FLOAT,
    "duration_towed_vehicle" INT,
    "towed_vehicle_loading_unit_id" INT REFERENCES "loading_unit"("id"),
    "value_towed_vehicle" FLOAT,
    "towed_vehicle_loan_amount" FLOAT,
    "towed_vehicle_borrowing_rate" FLOAT,
    "towed_vehicle_loan_duration" INT,
    "tv_resale_value" FLOAT,
    "tv_contract_length" INT,
    "mv_monthly_rental_amount" FLOAT,
    "yearly_insurance_amount" FLOAT,
    "yearly_goods_carried_insurance_amount" FLOAT,
    "yearly_axle_tax" FLOAT,
    "yearly structural_cost" FLOAT,
    "nb_driver_per_vehicle" INT,-- >=1
    "yearly_activity_driver" INT,
    "monthly_working_time" INT,
    "monthly_driving_time" INT,
    "monthly_driver_salary" FLOAT,
    "yearly_bonuses" FLOAT,
    "employment_contribution_rate" FLOAT,
    "yearly_travel_allowance" FLOAT,
    "nb_paid_month" INT,
    "cost_component_label" TEXT,
    



)
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