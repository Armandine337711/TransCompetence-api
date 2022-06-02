BEGIN;

-------------------------------
-- EXAMPLE CREATE FUNCTION UPDATE
-------------------------------
DROP FUNCTION IF EXISTS "member_update", "connection_update", "client_update", "loading_unit_update", "financial_datas_update", "validate_financial_datas_update", "in_course_financial_datas_update" ;

CREATE FUNCTION "member_update"(updatedDatas json) RETURNS SETOF "member" AS
    $$
    UPDATE "member" SET
    "login" = updatedDatas ->> 'login',
    "firstname" = updatedDatas ->> 'firstname',
    "lastname" = updatedDatas ->> 'lastname',
    "email" = updatedDatas ->> 'email',
    "pwd" = updatedDatas ->> 'pwd',
    "position_id" = (updatedDatas ->> 'position_id')::int,
    "updatedAt" = NOW()
    WHERE "id" = (updatedDatas ->> 'id')::int
    RETURNING *;
    $$
LANGUAGE sql VOLATILE STRICT;

-- update the last connection of the member
CREATE FUNCTION "connection_update"(id INT) RETURNS VOID AS
    $$
    UPDATE "member" SET
    "last_connection" = NOW()
    WHERE "id"= id;
    $$
LANGUAGE sql VOLATILE STRICT;

CREATE FUNCTION "client_update"(updatedDatas json) RETURNS SETOF "client" AS
    $$
    UPDATE "client" SET
    "buisness_name" = updatedDatas ->> 'buisness_name'
    WHERE "id" = (updatedDatas ->> 'id')::int
    RETURNING *;
    $$
LANGUAGE sql VOLATILE STRICT;

CREATE FUNCTION "loading_unit_update"(updatedDatas json) RETURNS SETOF "loading_unit" AS
    $$
    UPDATE "loading_unit" SET
    "unit" = updatedDatas ->> 'unit'
    WHERE "id" = (updatedDatas ->> 'id')::int
    RETURNING *;
    $$
LANGUAGE sql VOLATILE STRICT;

CREATE FUNCTION "datapackage1_update"(updatedDatas json) RETURNS SETOF "financial_datas" AS
$$
UPDATE "financial_datas" SET
    "yearly_mileage" = (updatedDatas ->>'yearly_mileage')::int,
    "in_charge_mileage" = (updatedDatas ->>'in_charge_mileage')::int,
    "nb_towed_vehicles" = (updatedDatas ->>'nb_towed_vehicles')::int,
    "nb_days_in_operation" = (updatedDatas ->>'nb_days_in_operation')::int,
    "loading_unit_id" = (updatedDatas ->>'loading_unit_id')::int,
    "loading_capacity" = (updatedDatas ->>'loading_capacity')::int,
    "capacity_utilisation_factor" = (updatedDatas ->>'capacity_utilisation_factor')::float
    WHERE "id" = (updatedDatas ->> 'id')::int
 RETURNING *;
$$
LANGUAGE sql VOLATILE STRICT;
CREATE FUNCTION "datapackage2_update"(updatedDatas json) RETURNS SETOF "financial_datas" AS
$$
UPDATE "financial_datas" SET
    "gazoline_consumption" = (updatedDatas ->>'gazoline_consumption')::float,
    "average_price_liter" = (updatedDatas ->>'average_price_liter')::float,
    "proportion_tanker_supply" = (updatedDatas ->>'proportion_tanker_supply')::float,
    "average_price_liter_tanker" = (updatedDatas ->>'average_price_liter_tanker')::float
    WHERE "id" = (updatedDatas ->> 'id')::int
 RETURNING *;
$$
LANGUAGE sql VOLATILE STRICT;
CREATE FUNCTION "datapackage3_update"(updatedDatas json) RETURNS SETOF "financial_datas" AS
$$
UPDATE "financial_datas" SET
    "km_cost_tyres" = (updatedDatas ->>'km_cost_tyres')::float,
    "nb_tyres_motor_vehicle" = (updatedDatas ->>'nb_tyres_motor_vehicle')::int,
    "nb_tyres_towed_vehicle" = (updatedDatas ->>'nb_tyres_towed_vehicle')::int,
    "price_tyre_motor_vehicle" = (updatedDatas ->>'price_tyre_motor_vehicle')::float,
    "price_tyre_towed_vehicle" = (updatedDatas ->>'price_tyre_towed_vehicle')::float,
    "lifetime_motor_vehicle" = (updatedDatas ->>'lifetime_motor_vehicle')::float,
    "lifetime_towed_vehicle" = (updatedDatas ->>'lifetime_towed_vehicle')::float,
    "yearly_maintenance_cost" = (updatedDatas ->>'yearly_maintenance_cost')::float,
    "yearly_toll_cost" = (updatedDatas ->>'yearly_toll_cost')::float
    WHERE "id" = (updatedDatas ->> 'id')::int
 RETURNING *;
$$
LANGUAGE sql VOLATILE STRICT;
CREATE FUNCTION "financial_datas_update"(updatedDatas json) RETURNS SETOF "financial_datas" AS
$$
UPDATE "financial_datas" SET
    "exercice_year" = (updatedDatas ->> 'exercice_year')::timestamptz,
    "yearly_mileage" = (updatedDatas ->>'yearly_mileage')::int,
    "in_charge_mileage" = (updatedDatas ->>'in_charge_mileage')::int,
    "nb_towed_vehicles" = (updatedDatas ->>'nb_towed_vehicles')::int,
    "nb_days_in_operation" = (updatedDatas ->>'nb_days_in_operation')::int,
    "loading_unit_id" = (updatedDatas ->>'loading_unit_id')::int,
    "loading_capacity" = (updatedDatas ->>'loading_capacity')::int,
    "capacity_utilisation_factor" = (updatedDatas ->>'capacity_utilisation_factor')::float,
    "gazoline_consumption" = (updatedDatas ->>'gazoline_consumption')::float,
    "average_price_liter" = (updatedDatas ->>'average_price_liter')::float,
    "proportion_tanker_supply" = (updatedDatas ->>'proportion_tanker_supply')::float,
    "average_price_liter_tanker" = (updatedDatas ->>'average_price_liter_tanker')::float,
    "km_cost_tyres" = (updatedDatas ->>'km_cost_tyres')::float,
    "nb_tyres_motor_vehicle" = (updatedDatas ->>'nb_tyres_motor_vehicle')::int,
    "nb_tyres_towed_vehicle" = (updatedDatas ->>'nb_tyres_towed_vehicle')::int,
    "price_tyre_motor_vehicle" = (updatedDatas ->>'price_tyre_motor_vehicle')::float,
    "price_tyre_towed_vehicle" = (updatedDatas ->>'price_tyre_towed_vehicle')::float,
    "lifetime_motor_vehicle" = (updatedDatas ->>'lifetime_motor_vehicle')::int,
    "lifetime_towed_vehicle" = (updatedDatas ->>'lifetime_towed_vehicle')::int,
    "yearly_maintenance_cost" = (updatedDatas ->>'yearly_maintenance_cost')::int,
    "yearly_toll_cost" = (updatedDatas ->>'yearly_toll_cost')::float,
    "duration_motor_vehicle_use" = (updatedDatas ->>'duration_motor_vehicle_use')::int,
    "motor_vehicle_loading_unit_id" = (updatedDatas ->>'motor_vehicle_loading_unit_id')::int,
    "value_motor_vehicle" = (updatedDatas ->>'value_motor_vehicle')::int,
    "motor_vehicle_loan_amount" = (updatedDatas ->>'motor_vehicle_loan_amount')::float,
    "motor_vehicle_borrowing_rate" = (updatedDatas ->>'motor_vehicle_borrowing_rate')::float,
    "motor_vehicle_loan_duration" = (updatedDatas ->>'motor_vehicle_loan_duration')::int,
    "mv_resale_value" = (updatedDatas ->>'mv_resale_value')::float,
    "mv_contract_length" = (updatedDatas ->>'mv_contract_length')::int,
    "mv_monthly_rental_amount" = (updatedDatas ->>'mv_monthly_rental_amount')::float,
    "optional_purchase_value" = (updatedDatas ->>'optional purchase value')::float,
    "duration_towed_vehicle" = (updatedDatas ->>'duration_towed_vehicle')::int,
    "towed_vehicle_loading_unit_id" = (updatedDatas ->>'towed_vehicle_loading_unit_id')::int,
    "value_towed_vehicle" = (updatedDatas ->>'value_towed_vehicle')::float,
    "towed_vehicle_loan_amount" = (updatedDatas ->>'towed_vehicle_loan_amount')::float,
    "towed_vehicle_borrowing_rate" = (updatedDatas ->>'towed_vehicle_borrowing_rate')::float,
    "towed_vehicle_loan_duration" = (updatedDatas ->>'towed_vehicle_loan_duration')::float,
    "tv_resale_value" = (updatedDatas ->>'tv_resale_value')::float,
    "tv_contract_length" = (updatedDatas ->>'tv_contract_length')::int,
    "tv_monthly_rental_amount" = (updatedDatas ->>'mv_monthly_rental_amount')::float,
    "yearly_insurance_amount" = (updatedDatas ->>'yearly_insurance_amount')::float,
    "yearly_goods_carried_insurance_amount" = (updatedDatas ->>'yearly_goods_carried_insurance_amount')::float,
    "yearly_axle_tax" = (updatedDatas ->>'yearly_axle_tax')::float,
    "yearly structural_cost" = (updatedDatas ->>'yearly structural_cost')::float,
    "nb_driver_per_vehicle" = (updatedDatas ->>'nb_driver_per_vehicle')::float,
    "yearly_activity_driver" = (updatedDatas ->>'yearly_activity_driver')::int,
    "monthly_working_time" = (updatedDatas ->>'monthly_working_time')::int,
    "monthly_driving_time" = (updatedDatas ->>'monthly_driving_time')::int,
    "monthly_driver_salary" = (updatedDatas ->>'monthly_driver_salary')::float,
    "yearly_bonuses" = (updatedDatas ->>'yearly_bonuses')::float,
    "employment_contribution_rate" = (updatedDatas ->>'employment_contribution_rate')::float,
    "yearly_travel_allowance" = (updatedDatas ->>'yearly_travel_allowance')::float,
    "nb_paid_month" = (updatedDatas ->>'nb_paid_month')::int,
    "cost_component_label" = updatedDatas ->>'cost_component_label',
    "cost_component_unit" = updatedDatas ->>'cost_component_unit',
    "nb_trying_unit" = (updatedDatas ->>'nb_trying_unit')::int,
    "yearly_amount_cist_component" = (updatedDatas ->>'yearly_amount_cist_component')::float
    WHERE "id" = (updatedDatas ->> 'id')::int
 RETURNING *;
$$
LANGUAGE sql VOLATILE STRICT;
CREATE FUNCTION "financial_datas_update"(updatedDatas json) RETURNS SETOF "financial_datas" AS
$$
UPDATE "financial_datas" SET
    "exercice_year" = (updatedDatas ->> 'exercice_year')::timestamptz,
    "yearly_mileage" = (updatedDatas ->>'yearly_mileage')::int,
    "in_charge_mileage" = (updatedDatas ->>'in_charge_mileage')::int,
    "nb_towed_vehicles" = (updatedDatas ->>'nb_towed_vehicles')::int,
    "nb_days_in_operation" = (updatedDatas ->>'nb_days_in_operation')::int,
    "loading_unit_id" = (updatedDatas ->>'loading_unit_id')::int,
    "loading_capacity" = (updatedDatas ->>'loading_capacity')::int,
    "capacity_utilisation_factor" = (updatedDatas ->>'capacity_utilisation_factor')::float,
    "gazoline_consumption" = (updatedDatas ->>'gazoline_consumption')::float,
    "average_price_liter" = (updatedDatas ->>'average_price_liter')::float,
    "proportion_tanker_supply" = (updatedDatas ->>'proportion_tanker_supply')::float,
    "average_price_liter_tanker" = (updatedDatas ->>'average_price_liter_tanker')::float,
    "km_cost_tyres" = (updatedDatas ->>'km_cost_tyres')::float,
    "nb_tyres_motor_vehicle" = (updatedDatas ->>'nb_tyres_motor_vehicle')::int,
    "nb_tyres_towed_vehicle" = (updatedDatas ->>'nb_tyres_towed_vehicle')::int,
    "price_tyre_motor_vehicle" = (updatedDatas ->>'price_tyre_motor_vehicle')::float,
    "price_tyre_towed_vehicle" = (updatedDatas ->>'price_tyre_towed_vehicle')::float,
    "lifetime_motor_vehicle" = (updatedDatas ->>'lifetime_motor_vehicle')::int,
    "lifetime_towed_vehicle" = (updatedDatas ->>'lifetime_towed_vehicle')::int,
    "yearly_maintenance_cost" = (updatedDatas ->>'yearly_maintenance_cost')::int,
    "yearly_toll_cost" = (updatedDatas ->>'yearly_toll_cost')::float,
    "duration_motor_vehicle_use" = (updatedDatas ->>'duration_motor_vehicle_use')::int,
    "motor_vehicle_loading_unit_id" = (updatedDatas ->>'motor_vehicle_loading_unit_id')::int,
    "value_motor_vehicle" = (updatedDatas ->>'value_motor_vehicle')::int,
    "motor_vehicle_loan_amount" = (updatedDatas ->>'motor_vehicle_loan_amount')::float,
    "motor_vehicle_borrowing_rate" = (updatedDatas ->>'motor_vehicle_borrowing_rate')::float,
    "motor_vehicle_loan_duration" = (updatedDatas ->>'motor_vehicle_loan_duration')::int,
    "mv_resale_value" = (updatedDatas ->>'mv_resale_value')::float,
    "mv_contract_length" = (updatedDatas ->>'mv_contract_length')::int,
    "mv_monthly_rental_amount" = (updatedDatas ->>'mv_monthly_rental_amount')::float,
    "optional_purchase_value" = (updatedDatas ->>'optional purchase value')::float,
    "duration_towed_vehicle" = (updatedDatas ->>'duration_towed_vehicle')::int,
    "towed_vehicle_loading_unit_id" = (updatedDatas ->>'towed_vehicle_loading_unit_id')::int,
    "value_towed_vehicle" = (updatedDatas ->>'value_towed_vehicle')::float,
    "towed_vehicle_loan_amount" = (updatedDatas ->>'towed_vehicle_loan_amount')::float,
    "towed_vehicle_borrowing_rate" = (updatedDatas ->>'towed_vehicle_borrowing_rate')::float,
    "towed_vehicle_loan_duration" = (updatedDatas ->>'towed_vehicle_loan_duration')::float,
    "tv_resale_value" = (updatedDatas ->>'tv_resale_value')::float,
    "tv_contract_length" = (updatedDatas ->>'tv_contract_length')::int,
    "tv_monthly_rental_amount" = (updatedDatas ->>'mv_monthly_rental_amount')::float,
    "yearly_insurance_amount" = (updatedDatas ->>'yearly_insurance_amount')::float,
    "yearly_goods_carried_insurance_amount" = (updatedDatas ->>'yearly_goods_carried_insurance_amount')::float,
    "yearly_axle_tax" = (updatedDatas ->>'yearly_axle_tax')::float,
    "yearly structural_cost" = (updatedDatas ->>'yearly structural_cost')::float,
    "nb_driver_per_vehicle" = (updatedDatas ->>'nb_driver_per_vehicle')::float,
    "yearly_activity_driver" = (updatedDatas ->>'yearly_activity_driver')::int,
    "monthly_working_time" = (updatedDatas ->>'monthly_working_time')::int,
    "monthly_driving_time" = (updatedDatas ->>'monthly_driving_time')::int,
    "monthly_driver_salary" = (updatedDatas ->>'monthly_driver_salary')::float,
    "yearly_bonuses" = (updatedDatas ->>'yearly_bonuses')::float,
    "employment_contribution_rate" = (updatedDatas ->>'employment_contribution_rate')::float,
    "yearly_travel_allowance" = (updatedDatas ->>'yearly_travel_allowance')::float,
    "nb_paid_month" = (updatedDatas ->>'nb_paid_month')::int,
    "cost_component_label" = updatedDatas ->>'cost_component_label',
    "cost_component_unit" = updatedDatas ->>'cost_component_unit',
    "nb_trying_unit" = (updatedDatas ->>'nb_trying_unit')::int,
    "yearly_amount_cist_component" = (updatedDatas ->>'yearly_amount_cist_component')::float
    WHERE "id" = (updatedDatas ->> 'id')::int
 RETURNING *;
$$
LANGUAGE sql VOLATILE STRICT;
CREATE FUNCTION "financial_datas_update"(updatedDatas json) RETURNS SETOF "financial_datas" AS
$$
UPDATE "financial_datas" SET
    "exercice_year" = (updatedDatas ->> 'exercice_year')::timestamptz,
    "yearly_mileage" = (updatedDatas ->>'yearly_mileage')::int,
    "in_charge_mileage" = (updatedDatas ->>'in_charge_mileage')::int,
    "nb_towed_vehicles" = (updatedDatas ->>'nb_towed_vehicles')::int,
    "nb_days_in_operation" = (updatedDatas ->>'nb_days_in_operation')::int,
    "loading_unit_id" = (updatedDatas ->>'loading_unit_id')::int,
    "loading_capacity" = (updatedDatas ->>'loading_capacity')::int,
    "capacity_utilisation_factor" = (updatedDatas ->>'capacity_utilisation_factor')::float,
    "gazoline_consumption" = (updatedDatas ->>'gazoline_consumption')::float,
    "average_price_liter" = (updatedDatas ->>'average_price_liter')::float,
    "proportion_tanker_supply" = (updatedDatas ->>'proportion_tanker_supply')::float,
    "average_price_liter_tanker" = (updatedDatas ->>'average_price_liter_tanker')::float,
    "km_cost_tyres" = (updatedDatas ->>'km_cost_tyres')::float,
    "nb_tyres_motor_vehicle" = (updatedDatas ->>'nb_tyres_motor_vehicle')::int,
    "nb_tyres_towed_vehicle" = (updatedDatas ->>'nb_tyres_towed_vehicle')::int,
    "price_tyre_motor_vehicle" = (updatedDatas ->>'price_tyre_motor_vehicle')::float,
    "price_tyre_towed_vehicle" = (updatedDatas ->>'price_tyre_towed_vehicle')::float,
    "lifetime_motor_vehicle" = (updatedDatas ->>'lifetime_motor_vehicle')::int,
    "lifetime_towed_vehicle" = (updatedDatas ->>'lifetime_towed_vehicle')::int,
    "yearly_maintenance_cost" = (updatedDatas ->>'yearly_maintenance_cost')::int,
    "yearly_toll_cost" = (updatedDatas ->>'yearly_toll_cost')::float,
    "duration_motor_vehicle_use" = (updatedDatas ->>'duration_motor_vehicle_use')::int,
    "motor_vehicle_loading_unit_id" = (updatedDatas ->>'motor_vehicle_loading_unit_id')::int,
    "value_motor_vehicle" = (updatedDatas ->>'value_motor_vehicle')::int,
    "motor_vehicle_loan_amount" = (updatedDatas ->>'motor_vehicle_loan_amount')::float,
    "motor_vehicle_borrowing_rate" = (updatedDatas ->>'motor_vehicle_borrowing_rate')::float,
    "motor_vehicle_loan_duration" = (updatedDatas ->>'motor_vehicle_loan_duration')::int,
    "mv_resale_value" = (updatedDatas ->>'mv_resale_value')::float,
    "mv_contract_length" = (updatedDatas ->>'mv_contract_length')::int,
    "mv_monthly_rental_amount" = (updatedDatas ->>'mv_monthly_rental_amount')::float,
    "optional_purchase_value" = (updatedDatas ->>'optional purchase value')::float,
    "duration_towed_vehicle" = (updatedDatas ->>'duration_towed_vehicle')::int,
    "towed_vehicle_loading_unit_id" = (updatedDatas ->>'towed_vehicle_loading_unit_id')::int,
    "value_towed_vehicle" = (updatedDatas ->>'value_towed_vehicle')::float,
    "towed_vehicle_loan_amount" = (updatedDatas ->>'towed_vehicle_loan_amount')::float,
    "towed_vehicle_borrowing_rate" = (updatedDatas ->>'towed_vehicle_borrowing_rate')::float,
    "towed_vehicle_loan_duration" = (updatedDatas ->>'towed_vehicle_loan_duration')::float,
    "tv_resale_value" = (updatedDatas ->>'tv_resale_value')::float,
    "tv_contract_length" = (updatedDatas ->>'tv_contract_length')::int,
    "tv_monthly_rental_amount" = (updatedDatas ->>'mv_monthly_rental_amount')::float,
    "yearly_insurance_amount" = (updatedDatas ->>'yearly_insurance_amount')::float,
    "yearly_goods_carried_insurance_amount" = (updatedDatas ->>'yearly_goods_carried_insurance_amount')::float,
    "yearly_axle_tax" = (updatedDatas ->>'yearly_axle_tax')::float,
    "yearly structural_cost" = (updatedDatas ->>'yearly structural_cost')::float,
    "nb_driver_per_vehicle" = (updatedDatas ->>'nb_driver_per_vehicle')::float,
    "yearly_activity_driver" = (updatedDatas ->>'yearly_activity_driver')::int,
    "monthly_working_time" = (updatedDatas ->>'monthly_working_time')::int,
    "monthly_driving_time" = (updatedDatas ->>'monthly_driving_time')::int,
    "monthly_driver_salary" = (updatedDatas ->>'monthly_driver_salary')::float,
    "yearly_bonuses" = (updatedDatas ->>'yearly_bonuses')::float,
    "employment_contribution_rate" = (updatedDatas ->>'employment_contribution_rate')::float,
    "yearly_travel_allowance" = (updatedDatas ->>'yearly_travel_allowance')::float,
    "nb_paid_month" = (updatedDatas ->>'nb_paid_month')::int,
    "cost_component_label" = updatedDatas ->>'cost_component_label',
    "cost_component_unit" = updatedDatas ->>'cost_component_unit',
    "nb_trying_unit" = (updatedDatas ->>'nb_trying_unit')::int,
    "yearly_amount_cist_component" = (updatedDatas ->>'yearly_amount_cist_component')::float
    WHERE "id" = (updatedDatas ->> 'id')::int
 RETURNING *;
$$
LANGUAGE sql VOLATILE STRICT;
CREATE FUNCTION "financial_datas_update"(updatedDatas json) RETURNS SETOF "financial_datas" AS
$$
UPDATE "financial_datas" SET
    "exercice_year" = (updatedDatas ->> 'exercice_year')::timestamptz,
    "yearly_mileage" = (updatedDatas ->>'yearly_mileage')::int,
    "in_charge_mileage" = (updatedDatas ->>'in_charge_mileage')::int,
    "nb_towed_vehicles" = (updatedDatas ->>'nb_towed_vehicles')::int,
    "nb_days_in_operation" = (updatedDatas ->>'nb_days_in_operation')::int,
    "loading_unit_id" = (updatedDatas ->>'loading_unit_id')::int,
    "loading_capacity" = (updatedDatas ->>'loading_capacity')::int,
    "capacity_utilisation_factor" = (updatedDatas ->>'capacity_utilisation_factor')::float,
    "gazoline_consumption" = (updatedDatas ->>'gazoline_consumption')::float,
    "average_price_liter" = (updatedDatas ->>'average_price_liter')::float,
    "proportion_tanker_supply" = (updatedDatas ->>'proportion_tanker_supply')::float,
    "average_price_liter_tanker" = (updatedDatas ->>'average_price_liter_tanker')::float,
    "km_cost_tyres" = (updatedDatas ->>'km_cost_tyres')::float,
    "nb_tyres_motor_vehicle" = (updatedDatas ->>'nb_tyres_motor_vehicle')::int,
    "nb_tyres_towed_vehicle" = (updatedDatas ->>'nb_tyres_towed_vehicle')::int,
    "price_tyre_motor_vehicle" = (updatedDatas ->>'price_tyre_motor_vehicle')::float,
    "price_tyre_towed_vehicle" = (updatedDatas ->>'price_tyre_towed_vehicle')::float,
    "lifetime_motor_vehicle" = (updatedDatas ->>'lifetime_motor_vehicle')::int,
    "lifetime_towed_vehicle" = (updatedDatas ->>'lifetime_towed_vehicle')::int,
    "yearly_maintenance_cost" = (updatedDatas ->>'yearly_maintenance_cost')::int,
    "yearly_toll_cost" = (updatedDatas ->>'yearly_toll_cost')::float,
    "duration_motor_vehicle_use" = (updatedDatas ->>'duration_motor_vehicle_use')::int,
    "motor_vehicle_loading_unit_id" = (updatedDatas ->>'motor_vehicle_loading_unit_id')::int,
    "value_motor_vehicle" = (updatedDatas ->>'value_motor_vehicle')::int,
    "motor_vehicle_loan_amount" = (updatedDatas ->>'motor_vehicle_loan_amount')::float,
    "motor_vehicle_borrowing_rate" = (updatedDatas ->>'motor_vehicle_borrowing_rate')::float,
    "motor_vehicle_loan_duration" = (updatedDatas ->>'motor_vehicle_loan_duration')::int,
    "mv_resale_value" = (updatedDatas ->>'mv_resale_value')::float,
    "mv_contract_length" = (updatedDatas ->>'mv_contract_length')::int,
    "mv_monthly_rental_amount" = (updatedDatas ->>'mv_monthly_rental_amount')::float,
    "optional_purchase_value" = (updatedDatas ->>'optional purchase value')::float,
    "duration_towed_vehicle" = (updatedDatas ->>'duration_towed_vehicle')::int,
    "towed_vehicle_loading_unit_id" = (updatedDatas ->>'towed_vehicle_loading_unit_id')::int,
    "value_towed_vehicle" = (updatedDatas ->>'value_towed_vehicle')::float,
    "towed_vehicle_loan_amount" = (updatedDatas ->>'towed_vehicle_loan_amount')::float,
    "towed_vehicle_borrowing_rate" = (updatedDatas ->>'towed_vehicle_borrowing_rate')::float,
    "towed_vehicle_loan_duration" = (updatedDatas ->>'towed_vehicle_loan_duration')::float,
    "tv_resale_value" = (updatedDatas ->>'tv_resale_value')::float,
    "tv_contract_length" = (updatedDatas ->>'tv_contract_length')::int,
    "tv_monthly_rental_amount" = (updatedDatas ->>'mv_monthly_rental_amount')::float,
    "yearly_insurance_amount" = (updatedDatas ->>'yearly_insurance_amount')::float,
    "yearly_goods_carried_insurance_amount" = (updatedDatas ->>'yearly_goods_carried_insurance_amount')::float,
    "yearly_axle_tax" = (updatedDatas ->>'yearly_axle_tax')::float,
    "yearly structural_cost" = (updatedDatas ->>'yearly structural_cost')::float,
    "nb_driver_per_vehicle" = (updatedDatas ->>'nb_driver_per_vehicle')::float,
    "yearly_activity_driver" = (updatedDatas ->>'yearly_activity_driver')::int,
    "monthly_working_time" = (updatedDatas ->>'monthly_working_time')::int,
    "monthly_driving_time" = (updatedDatas ->>'monthly_driving_time')::int,
    "monthly_driver_salary" = (updatedDatas ->>'monthly_driver_salary')::float,
    "yearly_bonuses" = (updatedDatas ->>'yearly_bonuses')::float,
    "employment_contribution_rate" = (updatedDatas ->>'employment_contribution_rate')::float,
    "yearly_travel_allowance" = (updatedDatas ->>'yearly_travel_allowance')::float,
    "nb_paid_month" = (updatedDatas ->>'nb_paid_month')::int,
    "cost_component_label" = updatedDatas ->>'cost_component_label',
    "cost_component_unit" = updatedDatas ->>'cost_component_unit',
    "nb_trying_unit" = (updatedDatas ->>'nb_trying_unit')::int,
    "yearly_amount_cist_component" = (updatedDatas ->>'yearly_amount_cist_component')::float
    WHERE "id" = (updatedDatas ->> 'id')::int
 RETURNING *;
$$
LANGUAGE sql VOLATILE STRICT;

CREATE FUNCTION "validate_financial_datas_update"(id INT) RETURNS VOID AS
    $$
    UPDATE "financial_datas" SET
    "validated" = true
    WHERE "id" = id
    RETURNING *;
    $$
LANGUAGE sql VOLATILE STRICT;

CREATE FUNCTION "in_course_financial_datas_update"(id INT) RETURNS VOID AS
$$
UPDATE "financial_datas" SET
"in_course" = false
WHERE "id" = id;

UPDATE "financial_datas" SET
"in_course" = false
WHERE "id" <> id;
$$
LANGUAGE sql VOLATILE STRICT;

COMMIT;