BEGIN;

DROP FUNCTION IF EXISTS "member_add", "client_add", "loading_unit_add", "financial_datas_add", "cnr_rating_add", "costing_add";

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
INSERT INTO "client"("buisness_name") VALUES (
newDatas ->> 'buisness_name'
) RETURNING *;
$$
LANGUAGE sql VOLATILE STRICT;

CREATE FUNCTION "loading_unit_add"(newDatas json) RETURNS SETOF "loading_unit" AS
$$
INSERT INTO "loading_unit"("unit") VALUES (
newDatas ->> 'unit'
) RETURNING *;
$$
LANGUAGE sql VOLATILE STRICT;

CREATE FUNCTION "financial_datas_add"(newDatas json) RETURNS SETOF "financial_datas" AS
$$
INSERT INTO "financial_datas"("yearly_mileage", "in_charge_mileage", "nb_towed_vehicles", "nb_days_in_operation", "loading_unit_id", "loading_capacity", "capacity_utilisation_factor", "gazoline_consumption", "average_price_liter", "proportion_tanker_supply", "average_price_liter_tanker", "km_cost_tyres", "nb_tyres_motor_vehicle", "nb_tyres_towed_vehicle", "price_tyre_motor_vehicle", "price_tyre_towed_vehicle", "lifetime_motor_vehicle", "lifetime_towed_vehicle", "yearly_maintenance_cost", "yearly_toll_cost", "duration_motor_vehicle_use", "motor_vehicle_loading_unit_id", "value_motor_vehicle", "motor_vehicle_loan_amount", "motor_vehicle_borrowing_rate", "motor_vehicle_loan_duration", "mv_resale_value", "mv_contract_length", "mv_monthly_rental_amount", "optional purchase value", "duration_towed_vehicle", "towed_vehicle_loading_unit_id", "value_towed_vehicle", "towed_vehicle_loan_amount", "towed_vehicle_borrowing_rate", "towed_vehicle_loan_duration", "tv_resale_value", "tv_contract_length", "tv_monthly_rental_amount", "yearly_insurance_amount", "yearly_goods_carried_insurance_amount", "yearly_axle_tax", "yearly structural_cost", "nb_driver_per_vehicle", "yearly_activity_driver", "monthly_working_time", "monthly_driving_time", "monthly_driver_salary", "yearly_bonuses", "employment_contribution_rate", "yearly_travel_allowance", "nb_paid_month", "cost_component_label", "cost_component_unit", "nb_trying_unit", "yearly_amount_cist_component") VALUES (
    (newDatas ->>'yearly_mileage')::int,
    (newDatas ->>'in_charge_mileage')::int,
    (newDatas ->>'nb_towed_vehicles')::int,
    (newDatas ->>'nb_days_in_operation')::int,
    (newDatas ->>'loading_unit_id')::int,
    (newDatas ->>'loading_capacity')::int,
    (newDatas ->>'capacity_utilisation_factor')::float,
    (newDatas ->>'gazoline_consumption')::float,
    (newDatas ->>'average_price_liter')::float,
    (newDatas ->>'proportion_tanker_supply')::float,
    (newDatas ->>'average_price_liter_tanker')::float,
    (newDatas ->>'km_cost_tyres')::float,
    (newDatas ->>'nb_tyres_motor_vehicle')::int,
    (newDatas ->>'nb_tyres_towed_vehicle')::int,
    (newDatas ->>'price_tyre_motor_vehicle')::float,
    (newDatas ->>'price_tyre_towed_vehicle')::float,
    (newDatas ->>'lifetime_motor_vehicle')::int,
    (newDatas ->>'lifetime_towed_vehicle')::int,
    (newDatas ->>'yearly_maintenance_cost')::int,
    (newDatas ->>'yearly_toll_cost')::float,
    (newDatas ->>'duration_motor_vehicle_use')::int,
    (newDatas ->>'motor_vehicle_loading_unit_id')::int,
    (newDatas ->>'value_motor_vehicle')::int,
    (newDatas ->>'motor_vehicle_loan_amount')::float,
    (newDatas ->>'motor_vehicle_borrowing_rate')::float,
    (newDatas ->>'motor_vehicle_loan_duration')::int,
    (newDatas ->>'mv_resale_value')::float,
    (newDatas ->>'mv_contract_length')::int,
    (newDatas ->>'mv_monthly_rental_amount')::float,
    (newDatas ->>'optional purchase value')::float,
    (newDatas ->>'duration_towed_vehicle')::int,
    (newDatas ->>'towed_vehicle_loading_unit_id')::int,
    (newDatas ->>'value_towed_vehicle')::float,
    (newDatas ->>'towed_vehicle_loan_amount')::float,
    (newDatas ->>'towed_vehicle_borrowing_rate')::float,
    (newDatas ->>'towed_vehicle_loan_duration')::float,
    (newDatas ->>'tv_resale_value')::float,
    (newDatas ->>'tv_contract_length')::int,
    (newDatas ->>'tv_monthly_rental_amount')::float,
    (newDatas ->>'yearly_insurance_amount')::float,
    (newDatas ->>'yearly_goods_carried_insurance_amount')::float,
    (newDatas ->>'yearly_axle_tax')::float,
    (newDatas ->>'yearly structural_cost')::float,
    (newDatas ->>'nb_driver_per_vehicle')::float,
    (newDatas ->>'yearly_activity_driver')::int,
    (newDatas ->>'monthly_working_time')::int,
    (newDatas ->>'monthly_driving_time')::int,
    (newDatas ->>'monthly_driver_salary')::float,
    (newDatas ->>'yearly_bonuses')::float,
    (newDatas ->>'employment_contribution_rate')::float,
    (newDatas ->>'yearly_travel_allowance')::float,
    (newDatas ->>'nb_paid_month')::int,
    newDatas ->>'cost_component_label',
    newDatas ->>'cost_component_unit',
    (newDatas ->>'nb_trying_unit')::int,
    (newDatas ->>'yearly_amount_cist_component')::float
) RETURNING *;
$$
LANGUAGE sql VOLATILE STRICT;

CREATE FUNCTION "cnr_rating_add"(newDatas json) RETURNS SETOF "cnr_rating" AS
$$
INSERT INTO "cnr_rating"("rating_date", "frozen_fridge_ld_ea", "professionnal_fuel", "service", "insfrastructure", "structural_costs") VALUES (
(newDatas ->> 'rating_date')::timestamptz,
(newDatas ->> 'frozen_fridge_ld_ea')::float,
(newDatas ->> 'professionnal_fuel')::float,
(newDatas ->> 'service')::float,
(newDatas ->> 'insfrastructure')::float,
(newDatas ->> 'structural_costs')::float
) RETURNING *;
$$
LANGUAGE sql VOLATILE STRICT;

CREATE FUNCTION "costing_add"(newDatas json) RETURNS SETOF "costing" AS
$$
INSERT INTO "costing"("quotation_date", "member_id", "client_id", "AB_distance", "AB_toll", "AB_duration", "B_loading_time", "BC_distance", "BC_toll", "BC_duration" , "C_unloading_time", "CA_distance", "CA_toll", "CA_duration", "loading_unit_id", "quantity_loading_unit", "dayly_working_time") VALUES (
(newDatas ->> 'quotation_date')::timestamptz,
(newDatas ->> 'member_id')::int,
(newDatas ->> 'client_id')::int,
(newDatas ->> 'AB_distance')::float,
(newDatas ->> 'AB_toll')::float,
(newDatas ->> 'AB_duration')::float,
(newDatas ->> 'B_loading_time')::float,
(newDatas ->> 'BC_distance')::float,
(newDatas ->> 'BC_toll')::float,
(newDatas ->> 'BC_duration')::float,
(newDatas ->> 'C_unloading_time')::float,
(newDatas ->> 'CA_distance')::float,
(newDatas ->> 'CA_toll')::float,
(newDatas ->> 'CA_duration')::float,
(newDatas ->> 'loading_unit_id')::int,
(newDatas ->> 'quantity_loading_unit')::float,
(newDatas ->> 'dayly_working_time')::float
) RETURNING *;
$$
LANGUAGE sql VOLATILE STRICT;

COMMIT;