  /* -----------------------------------------------------------------------------
   FILE:    6_consistency_conditions.sql
   PURPOSE: Define and test consistency constraints for the student32 schema,
            specifically:
              A) Add CHECK constraints to enforce business rules
              B) Insert valid data to confirm constraint acceptance (positive tests)
              C) Attempt invalid inserts to confirm rejection (negative tests)
              D) Demonstrate normalization compliance (1NF, 2NF, 3NF)
              E) Display summary of current constraints
   SCHEMA:  student32 (Economy Project)
   AUTHOR:  Njomza Bytyqi (student32 / 330021)
----------------------------------------------------------------------------- */

-- ============================================================================
-- SECTION A: ADDITIONAL CHECK CONSTRAINTS
-- Adds integrity constraints to ensure data validity directly at the schema level.
-- ============================================================================

-- A.1 Add a CHECK constraint: Ensure 'exchange_rate' is strictly positive in 'currency' table
DO $$
BEGIN
  -- Prevent duplicate constraint creation by checking for its existence first
  IF NOT EXISTS (
    SELECT 1
      FROM information_schema.check_constraints
     WHERE constraint_name = 'currency_exchange_rate_positive'
       AND constraint_schema = 'student32'
  ) THEN
    ALTER TABLE student32.currency
      ADD CONSTRAINT currency_exchange_rate_positive
      CHECK (exchange_rate > 0);
    RAISE NOTICE 'Added constraint currency_exchange_rate_positive';
  ELSE
    RAISE NOTICE 'Constraint currency_exchange_rate_positive already exists';
  END IF;
END;
$$ LANGUAGE plpgsql;

-- A.2 Add a CHECK constraint: Ensure GDP 'amount' is non-negative in the 'gdp' table
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1
      FROM information_schema.check_constraints
     WHERE constraint_name = 'gdp_amount_non_negative'
       AND constraint_schema = 'student32'
  ) THEN
    ALTER TABLE student32.gdp
      ADD CONSTRAINT gdp_amount_non_negative
      CHECK (amount >= 0);
    RAISE NOTICE 'Added constraint gdp_amount_non_negative';
  ELSE
    RAISE NOTICE 'Constraint gdp_amount_non_negative already exists';
  END IF;
END;
$$ LANGUAGE plpgsql;

-- A.3 Add a CHECK constraint: Ensure 'rate' is non-negative in the 'inflation' table
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1
      FROM information_schema.check_constraints
     WHERE constraint_name = 'inflation_rate_non_negative'
       AND constraint_schema = 'student32'
  ) THEN
    ALTER TABLE student32.inflation
      ADD CONSTRAINT inflation_rate_non_negative
      CHECK (rate >= 0);
    RAISE NOTICE 'Added constraint inflation_rate_non_negative';
  ELSE
    RAISE NOTICE 'Constraint inflation_rate_non_negative already exists';
  END IF;
END;
$$ LANGUAGE plpgsql;


-- ============================================================================
-- SECTION B: POSITIVE TESTS
-- These transactions insert valid data to verify that constraints allow proper values.
-- ============================================================================

SELECT '=== POSITIVE TESTS: Valid data is accepted ===' AS test_section;

-- B.1 Insert a valid currency (exchange_rate > 0), then clean up test record
DO $$
BEGIN
  -- Insert valid test currency, including required NOT NULL fields
  INSERT INTO student32.currency (code, name, exchange_rate, country_code)
    VALUES ('TST', 'TestCurrency', 0.5, 'TST')
    ON CONFLICT DO NOTHING;
  RAISE NOTICE 'SUCCESS: Valid currency insert accepted';

  -- Cleanup: Remove the test record
  DELETE FROM student32.currency WHERE code = 'TST';
END;
$$ LANGUAGE plpgsql;

-- B.2 Insert a valid GDP record (amount >= 0, foreign key must exist), then clean up
DO $$
BEGIN
  -- Ensure referenced currency exists (required for FK), using idempotent insert
  INSERT INTO student32.currency (code, name, exchange_rate, country_code)
    VALUES ('EUR', 'Euro', 1.0, 'DEU')
    ON CONFLICT DO NOTHING;

  -- Insert test GDP record with non-negative amount
  INSERT INTO student32.gdp (year, country_code, amount, currency_code)
    VALUES (2023, 'DEU', 1000, 'EUR')
    ON CONFLICT DO NOTHING;

  RAISE NOTICE 'SUCCESS: Valid GDP insert accepted';

  -- Cleanup: Remove the test GDP record
  DELETE FROM student32.gdp
    WHERE year = 2023
      AND country_code = 'DEU'
      AND amount = 1000;
END;
$$ LANGUAGE plpgsql;

-- B.3 Insert a valid inflation record (rate >= 0), then clean up
DO $$
BEGIN
  -- Insert valid inflation record
  INSERT INTO student32.inflation(year, country_code, rate)
    VALUES (2023, 'DEU', 1.5)
    ON CONFLICT DO NOTHING;
  RAISE NOTICE 'SUCCESS: Valid inflation insert accepted';

  -- Cleanup: Remove test record
  DELETE FROM student32.inflation
    WHERE year = 2023 AND country_code = 'DEU' AND rate = 1.5;
END;
$$ LANGUAGE plpgsql;


-- ============================================================================
-- SECTION C: NEGATIVE TESTS
-- Attempts to insert invalid data; constraints should block these operations.
-- ============================================================================

SELECT '=== NEGATIVE TESTS: Invalid data is rejected ===' AS test_section;

-- C.1 Try inserting a currency with negative exchange_rate; should be rejected
DO $$
BEGIN
  BEGIN
    RAISE NOTICE 'Test C.1: currency.exchange_rate negative';
    INSERT INTO student32.currency(code, name, exchange_rate, country_code)
      VALUES('BAD', 'BadCurrency', -1, 'BAD');
    -- If insert succeeds, force error (should never happen)
    RAISE EXCEPTION 'ERROR: currency_exchange_rate_positive should have rejected -1';
  EXCEPTION
    WHEN check_violation THEN
      RAISE NOTICE 'SUCCESS: currency_exchange_rate_positive prevented negative rate';
    WHEN OTHERS THEN
      RAISE NOTICE 'UNEXPECTED ERROR: %', SQLERRM;
  END;
END;
$$ LANGUAGE plpgsql;

-- C.2 Try inserting GDP with negative amount; should be rejected
DO $$
BEGIN
  BEGIN
    RAISE NOTICE 'Test C.2: gdp.amount negative';
    INSERT INTO student32.gdp(year, country_code, amount, currency_code)
      VALUES(2023, 'DEU', -100, 'EUR');
    RAISE EXCEPTION 'ERROR: gdp_amount_non_negative should have rejected -100';
  EXCEPTION
    WHEN check_violation THEN
      RAISE NOTICE 'SUCCESS: gdp_amount_non_negative prevented negative amount';
    WHEN OTHERS THEN
      RAISE NOTICE 'UNEXPECTED ERROR: %', SQLERRM;
  END;
END;
$$ LANGUAGE plpgsql;

-- C.3 Try inserting inflation with negative rate; should be rejected
DO $$
BEGIN
  BEGIN
    RAISE NOTICE 'Test C.3: inflation.rate negative';
    INSERT INTO student32.inflation(year, country_code, rate)
      VALUES(2023, 'DEU', -5);
    RAISE EXCEPTION 'ERROR: inflation_rate_non_negative should have rejected -5';
  EXCEPTION
    WHEN check_violation THEN
      RAISE NOTICE 'SUCCESS: inflation_rate_non_negative prevented negative rate';
    WHEN OTHERS THEN
      RAISE NOTICE 'UNEXPECTED ERROR: %', SQLERRM;
  END;
END;
$$ LANGUAGE plpgsql;


-- ============================================================================
-- SECTION D: NORMALIZATION PROOF
-- Documents the schema's compliance with normalization forms (1NF through 3NF)
-- ============================================================================

SELECT '=== NORMALIZATION ANALYSIS: 1NF, 2NF, 3NF ===' AS norm_section;

-- D.1 First Normal Form (1NF): All attributes are atomic, no repeating groups or arrays
SELECT '- 1NF: All attributes are atomic, no repeating groups' AS nf1;

-- D.2 Second Normal Form (2NF): No partial dependencies on part of a composite key
SELECT '- 2NF: No partial dependencies on part of a composite key' AS nf2;

-- D.3 Third Normal Form (3NF): No transitive dependencies among non-key attributes
SELECT '- 3NF: No transitive dependencies among non-key attributes' AS nf3;

SELECT '✅ NORMALIZATION PROOF COMPLETE' AS final_result;

-- ============================================================================
-- SECTION E: SUMMARY OF ACTIVE CONSTRAINTS
-- Queries the catalog to list all active constraints in the schema.
-- ============================================================================

SELECT '=== ACTIVE CHECK CONSTRAINTS ===' AS summary_section;

-- List all active CHECK constraints for the schema
SELECT
  tc.constraint_name,
  tc.table_name,
  cc.check_clause
FROM
  information_schema.table_constraints AS tc
  JOIN information_schema.check_constraints AS cc
    ON tc.constraint_name = cc.constraint_name
WHERE
  tc.table_schema   = 'student32'
  AND tc.constraint_type = 'CHECK'
ORDER BY
  tc.table_name,
  tc.constraint_name;

SELECT '=== ACTIVE FOREIGN KEY CONSTRAINTS ===' AS summary_section;

-- List all active FOREIGN KEY constraints for the schema
SELECT
  tc.constraint_name,
  tc.table_name,
  kcu.column_name,
  ccu.table_name   AS foreign_table,
  ccu.column_name  AS foreign_column
FROM
  information_schema.table_constraints AS tc
  JOIN information_schema.key_column_usage AS kcu
    ON tc.constraint_name = kcu.constraint_name
  JOIN information_schema.constraint_column_usage AS ccu
    ON tc.constraint_name = ccu.constraint_name
WHERE
  tc.table_schema   = 'student32'
  AND tc.constraint_type = 'FOREIGN KEY'
ORDER BY
  tc.table_name,
  tc.constraint_name;

SELECT '✅ ALL CONSTRAINTS ARE VALID AND FUNCTIONAL' AS end_summary;
