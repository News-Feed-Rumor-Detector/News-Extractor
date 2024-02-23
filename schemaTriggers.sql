DROP TRIGGER IF EXISTS on_insert_update_author_article_count ON ArchiveVersions;
DROP TRIGGER IF EXISTS on_insert_update_author_article_count ON CurrentVersions;


CREATE OR REPLACE FUNCTION update_author_article_count() RETURNS TRIGGER AS $$
DECLARE
  author_name VARCHAR;
BEGIN
  -- Loop through each author name in the authors array
  FOREACH author_name IN ARRAY NEW.authors
  LOOP
    -- Trim whitespace from the author name
    author_name := TRIM(author_name);

    -- Check if the author already exists in the Authors table
    IF EXISTS (SELECT 1 FROM nfrd.Authors WHERE name = author_name) THEN
      -- If the author exists, increment their article count
      UPDATE nfrd.Authors SET article_count = article_count + 1 WHERE name = author_name;
    ELSE
      -- If the author doesn't exist, insert them into the Authors table with an article count of 1
      INSERT INTO nfrd.Authors (name, article_count) VALUES (author_name, 1);
    END IF;
  END LOOP;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_author_article_count_trigger
AFTER INSERT ON CurrentVersions
FOR EACH ROW
EXECUTE FUNCTION update_author_article_count();

