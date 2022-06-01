BEGIN;

DROP FUNCTION IF EXISTS "member_add", "client_add", "loading_unit_add", "financial_datas_add", "cnr_rating_add", "costing_add";

CREATE FUNCTION "member_add"(newDatas json) RETURNS SETOF "member" AS
$$
INSERT INTO "member"("login", "firstname", "lastname", "email", "pwd", "position_id") VALUES (
    newDatas ->> 'login',
    newDatas ->> 'firstname',
    newDatas ->> 'lastname',
    newDatas ->> 'email',
    newDatas ->> 'pwd',
    (newDatas ->> 'position_id')::int

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
INSERT INTO "financial_datas"("yearly_mileage") VALUES (
    (newDatas ->>'yearly_mileage')::int
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