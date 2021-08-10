# ALTER TABLE contact MODIFY COLUMN provider INT NOT NULL;
# ALTER TABLE contact RENAME COLUMN provider TO provider_id;

ALTER TABLE contact
    ADD CONSTRAINT FOREIGN KEY (provider_id) REFERENCES provider (id);

SHOW INDEXES FROM customer;
SHOW INDEXES FROM provider;

ALTER TABLE provider
    ADD CONSTRAINT UNIQUE (provider);

/* Stored Function */

/* CREATE FUNCTION sf_function_name(PRAMS:= param_identifier DATATYPE) RETURNS return_data_type
   BEGIN

        Your code goes here
        RETURN ;

   END;*/

-- if () {}
/* IF condition THEN
    statements;
   ELSEIF condition THEN
    statements;
   END IF;
*/

/*
    switch (expression){
        case case1:
            statements;
        case case2:
            statements;
        default:
            statements;
    }
*/

/* CASE expression
    WHEN case1 THEN
        statements;
    WHEN case2 THEN
        statements;
    ELSE
        statements;
   END CASE
*/

SET GLOBAL log_bin_trust_function_creators = 1;

DROP FUNCTION IF EXISTS sf_contact_number;

CREATE FUNCTION sf_contact_number(contact VARCHAR(15), provider VARCHAR(15)) RETURNS VARCHAR(50)
BEGIN
    CASE provider
        WHEN 'SLT' THEN
            RETURN CONCAT(contact, '-TELECOM');
        WHEN 'DIALOG' THEN
            RETURN CONCAT(contact, '-DLG');
        ELSE
            RETURN CONCAT(contact, '-UNKNOWN');
        END CASE;
END;

SELECT s.id, s.name, sf_contact_number(c.contact, p.provider) AS contact
FROM student s
         LEFT OUTER JOIN contact c ON s.id = c.student_id
         LEFT OUTER JOIN provider p on c.provider_id = p.id;

DROP FUNCTION IF EXISTS sf_loop_demo;
CREATE FUNCTION sf_loop_demo(count INT) RETURNS INT
BEGIN
    DECLARE x INT;          /* Variable declaration syntax DECLARE identifier datatype */
    DECLARE total INT DEFAULT 0;
    SET x = 0;

    loop1:
    WHILE x <= count DO
            SET total = total + x;

            IF x = 3 THEN
                LEAVE loop1;
            end if;

            SET x = x + 1;
        END WHILE;

    RETURN total;
END;

/* 1+2+3+4+5 */

SELECT sf_loop_demo(5);

DROP TRIGGER IF EXISTS st_student;
CREATE TRIGGER st_student AFTER INSERT ON student FOR EACH ROW
BEGIN
    INSERT INTO contact VALUES ('trigger', NEW.id, 1);
end;

DROP PROCEDURE  IF EXISTS sp_add_students;
CREATE PROCEDURE sp_add_students(IN num INT)
BEGIN
    DECLARE x INT DEFAULT 0;
    WHILE x < num DO
            INSERT INTO student (name) VALUES (CONCAT('KASUN', x));
            SET x = x + 1;
        END WHILE;
end;
CALL sp_add_students(5);

# DROP FUNCTION IF EXISTS sf_my_functions;
# CREATE FUNCTION sf_my_functions() RETURNS VARCHAR(100)
# BEGIN
#     SELECT * FROM student;
#     RETURN '10';
# end;
#
# SELECT sf_my_functions();

CREATE PROCEDURE sf_my_proc()
BEGIN
    SELECT * FROM student;
end;

CALL sf_my_proc();

/* IN
   OUT
   INOUT
   */

/* Select Syntax */
-- aggregate functions (SUM, COUNT, MIN, MAX)

# SELECT [column list] FROM table JOIN table ON <join_condtion> WHERE <condition1> GROUP BY <column> HAVING <condtion2>
#                             ORDER BY <col> [ASC|DESC] OFFSET 10 FETCH FIRST 5 ROWS
-- mysql dialect
# SELECT [column list] FROM table JOIN table ON <join_condtion> WHERE <condition1> GROUP BY <column> HAVING <condtion2>
# ORDER BY <col> [ASC|DESC] LIMIT 5 OFFSET 10;


SELECT * from provider;
SELECT * FROM contact;

/* Lexical Order, Logical Order */

-- Lexical Order
/* SELECT [DISTINCT] FROM JOIN ON WHERE GROUP BY HAVING ORDER BY [ASC | DESC] [LIMIT OFFSET] - MYSQL */
/* SELECT [DISTINCT] FROM JOIN ON WHERE GROUP BY HAVING ORDER BY [ASC | DESC] [OFFSET FETCH FIRST ROWS] - STANDARD SQL */

/* SELECT TOP [DISTINCT] FROM JOIN ON WHERE GROUP BY HAVING ORDER BY - Microsoft SQL SERVER */

-- Logical Order
/*
    FROM <tables>
    [JOIN(s) <tables> ON <join_condition>]
    WHERE <condition> (can't use aggregate functions)
    GROUP BY <column>
    HAVING <condition> (ca use aggregate functions)
    SELECT [DISTINCT]
    ORDER BY <columns> ASC | DESC
    LIMIT
*/

SELECT * FROM student INNER JOIN contact C JOIN provider p on p.id = C.provider_id;

SELECT id, provider, COUNT(contact) as contacts, COUNT(DISTINCT student_id) as students
FROM contact RIGHT OUTER JOIN provider p on contact.provider_id = p.id GROUP BY provider ORDER BY contacts DESC;

SELECT * FROM provider LEFT OUTER JOIN contact c ON provider.id = c.provider_id;


SELECT id, provider, COUNT(contact) as contacts, COUNT(DISTINCT student_id) as students FROM provider
            LEFT OUTER JOIN contact c ON provider.id = c.provider_id GROUP BY provider HAVING COUNT(contact) = 3  ORDER BY contacts DESC;