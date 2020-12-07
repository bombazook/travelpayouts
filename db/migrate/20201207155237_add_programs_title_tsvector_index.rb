class AddProgramsTitleTsvectorIndex < ActiveRecord::Migration[6.0]
  def up
    execute <<-SQL
      CREATE OR REPLACE FUNCTION extract_bigrams_tsvector ( t text )
      RETURNS tsvector
      LANGUAGE plpgsql
      AS
      $$
        DECLARE
          array_chars text[] := string_to_array(t, null);
          array_grams text[] := '{}';
          length integer := length(t);
          endpoint integer := length + 1;
          prev_index integer;
          counter integer := 1;
        BEGIN
          IF length > 0 THEN
            counter := counter + 1;
          end if;
          LOOP
            EXIT WHEN counter = endpoint;
            prev_index := counter - 1;
            array_grams := array_grams || concat(array_chars[prev_index], array_chars[counter]);
            counter := counter + 1;
          end loop;
          RETURN array_to_tsvector(array_grams);
        END;
      $$ IMMUTABLE;
    SQL
    add_index(:programs, 'extract_bigrams_tsvector(title)', using: 'gin') # speedup 2 letters searches
  end

  def down
    remove_index(:programs, 'extract_bigrams_tsvector(title)')
    execute 'DROP FUNCTION extract_bigrams_tsvector( t text )'
  end
end
