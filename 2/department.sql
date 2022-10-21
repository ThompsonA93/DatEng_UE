abort;-- DROP TABLE public.department;

CREATE TABLE public.department
(
    "deptId" integer NOT NULL PRIMARY KEY,
    name character varying(30) COLLATE pg_catalog."default" NOT NULL,
    "parentId" integer,
    "numEmpl" integer NOT NULL,
    CONSTRAINT "department_parentId_fkey" FOREIGN KEY ("parentId")
        REFERENCES public.department ("deptId") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.department
    OWNER to postgres;

-- Index: deptParentIdx

-- DROP INDEX public."deptParentIdx";

CREATE INDEX "deptParentIdx"
    ON public.department USING btree
    ("parentId")
    TABLESPACE pg_default;

insert into department values (1, 'Headquarter', 1, 10);
insert into department values (2, 'Sales', 1, 15);
insert into department values (3, 'Logistics', 1, 25);
insert into department values (4, 'F&E', 1, 11);
insert into department values (5, 'Marketing', 1, 25);
insert into department values (6, 'Basic Research', 4, 70);
insert into department values (7, 'Field Research', 4, 90);
insert into department values (8, 'Project Developement', 4, 190);
insert into department values (9, '3D Printing', 8, 10);
insert into department values (10, 'Software Developemnet', 8, 75);
insert into department values (11, 'Direct Sales', 2, 7);
insert into department values (12, 'Indirect Sales', 2, 10);
insert into department values (13, 'Phone Sales', 11, 50);
insert into department values (14, 'Online Sales', 11, 25);

