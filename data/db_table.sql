BEGIN;
-------------------------------
-- EXTENTION & DOMAIN
-------------------------------
DROP TABLE IF EXISTS "position", "member", "client", "loading_unit", "financing_method", "financial_datas", "cnr_rating", "costing" CASCADE;
DROP DOMAIN IF EXISTS TEXT_ONLY, ALPHANUM, TEXT_MAIL;
DROP EXTENSION IF EXISTS unaccent;

CREATE EXTENSION unaccent;



CREATE DOMAIN TEXT_ONLY AS TEXT CHECK(unaccent(VALUE) ~ '^[A-Za-z \-]+$');
CREATE DOMAIN ALPHANUM AS TEXT CHECK(unaccent(VALUE) ~ '^[A-Za-z\ \-\#\d]+$');
CREATE DOMAIN TEXT_MAIL AS TEXT CHECK(VALUE ~ '(^[a-z\d\.\-\_]+)@{1}([a-z\d\.\-]{2,})[.]([a-z]{2,5})$');

-------------------------------
-- TABLES
-------------------------------
CREATE TABLE IF NOT EXISTS "position"(
"id" INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
"entitled" TEXT_ONLY NOT NULL UNIQUE
);

INSERT INTO "position"("entitled") VALUES
('Contrôleur de Gestion'),
('Administrateur'),
('Commercial'),
('DbConcept'); 

CREATE TABLE IF NOT EXISTS "member"(
"id" INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
"login" TEXT_ONLY NOT NULL UNIQUE,
"firstname" TEXT_ONLY NOT NULL,
"lastname" TEXT_ONLY NOT NULL,
"email" TEXT_MAIL NOT NULL UNIQUE,
"pwd" TEXT NOT NULL,
"position_id" INT NOT NULL REFERENCES "position"("id"),
"createdAt" TIMESTAMPTZ DEFAULT NOW(),
"updatedAt" TIMESTAMPTZ DEFAULT NOW(),
"last_connection" TIMESTAMPTZ
);

CREATE TABLE IF NOT EXISTS "client"(
"id" INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
"buisness_name" ALPHANUM NOT NULL UNIQUE
);

-- CREATE TABLE IF NOT EXISTS "loading_unit"(
-- "id" INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
-- "unit" TEXT_ONLY NOT NULL UNIQUE
-- );

CREATE TABLE IF NOT EXISTS "financing_method"(
"id" INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
"method" TEXT_ONLY NOT NULL UNIQUE
);

INSERT INTO "financing_method"("method") VALUES 
    ('Emprunt'),
    ('Crédit Bail'),
    ('Location financière');

CREATE TABLE IF NOT EXISTS "financial_datas"(
    "id" INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    "exercice_year" INT NOT NULL UNIQUE,
    "yearly_mileage" INT,
    "in_charge_mileage" INT,
    "nb_towed_vehicles" INT,
    "nb_days_in_operation" INT,
    "loading_unit" ALPHANUM,
    "loading_capacity" FLOAT,
    "capacity_utilisation_factor" FLOAT,
    "gazoline_consumption" FLOAT,
    "average_price_liter" FLOAT,
    "proportion_tanker_supply" FLOAT,
    "average_price_liter_tanker" FLOAT,
    "km_cost_tyres" FLOAT,
    "nb_tyres_motor_vehicle" INT,
    "nb_tyres_towed_vehicle" INT,
    "price_tyre_motor_vehicle" FLOAT,
    "price_tyre_towed_vehicle" FLOAT,
    "lifetime_motor_vehicle" FLOAT, -- ou float ?
    "lifetime_towed_vehicle" FLOAT,
    "yearly_maintenance_cost" FLOAT,
    "yearly_toll_cost" FLOAT, -- trad toll = péage
    "duration_motor_vehicle_use" FLOAT, -- ou float ?
    --"motor_vehicle_loading_unit" ALPHANUM, -- 1 2 ou 3  default valeur ?
    "mv_financing_method_id" INT REFERENCES "financing_method"("id"),
    "value_motor_vehicle" FLOAT, --ou INT
    "motor_vehicle_loan_amount" FLOAT, -- si emprunt
    "motor_vehicle_borrowing_rate" FLOAT, -- <100 si emprunt
    "motor_vehicle_loan_duration" FLOAT, -- si emprunt
    "mv_resale_value" FLOAT, -- si emprunt
    "mv_contract_length" INT, -- si LLD ou crédit bail
    "mv_monthly_rental_amount" FLOAT,
    "mv_optional_purchase_value" FLOAT,
    "duration_towed_vehicle" FLOAT,
   "tv_financing_method_id" INT REFERENCES "financing_method"("id"),
    "value_towed_vehicle" FLOAT,
    "towed_vehicle_loan_amount" FLOAT,
    "towed_vehicle_borrowing_rate" FLOAT,
    "towed_vehicle_loan_duration" FLOAT,
    "tv_resale_value" FLOAT,
    "tv_contract_length" INT,
    "tv_monthly_rental_amount" FLOAT,
    "tv_optional_purchase_value" FLOAT,
    "yearly_insurance_amount" FLOAT,
    "yearly_goods_carried_insurance_amount" FLOAT,
    "yearly_axle_tax" FLOAT,
    "yearly_structural_cost" FLOAT,
    "nb_driver_per_vehicle" INT,-- >=1
    "yearly_activity_driver" INT,
    "monthly_working_time" FLOAT,
    "monthly_driving_time" FLOAT,
    "monthly_driver_salary" FLOAT,
    "yearly_bonuses" FLOAT,
    "employment_contribution_rate" FLOAT,
    "yearly_travel_allowance" FLOAT,
    "nb_paid_month" FLOAT,
    "cost_component_label" TEXT,
    "cost_component_unit" TEXT,
    "nb_trying_unit" FLOAT,
    "yearly_amount_cist_component" FLOAT,
    "validated" BOOLEAN DEFAULT false,
    "in_course" BOOLEAN DEFAULT false
);

CREATE TABLE IF NOT EXISTS "cnr_rating"(
"id" INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
"rating_date" TIMESTAMPTZ UNIQUE NOT NULL,
"frozen_fridge_ld_ea" FLOAT,
"professionnal_fuel" FLOAT,
"service" FLOAT,
"insfrastructure" FLOAT,
"structural_costs" FLOAT
);

CREATE TABLE IF NOT EXISTS "costing"(
"id" INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
"quotation_date" TIMESTAMPTZ NOT NULL,
"member_id" INT NOT NULL REFERENCES "member"("id"),
"client_id" INT NOT NULL REFERENCES "client"("id"),
"AB_distance" FLOAT, -- ou INT
"AB_toll" FLOAT,
"AB_duration" FLOAT,
"B_loading_time" FLOAT,
"BC_distance" FLOAT,
"BC_toll" FLOAT,
"BC_duration" FLOAT,
"C_unloading_time" FLOAT,
"CA_distance" FLOAT,
"CA_toll" FLOAT,
"CA_duration" FLOAT,
"loading_unit_id" INT REFERENCES "loading_unit"("id"),
"quantity_loading_unit" FLOAT,
"dayly_working_time" FLOAT
);

COMMIT;