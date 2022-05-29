BEGIN;

DROP VIEW IF EXISTS "member_role";

CREATE VIEW "member_role" AS
    SELECT m."id",
            m."login",
            m."firstname", 
            m."lastname",
            m."email",
            m."pwd",
            p."entitled"
        FROM "member" m
        JOIN "position" p
            ON p."id" = m."position_id";

COMMIT;