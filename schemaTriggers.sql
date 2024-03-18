DROP TRIGGER IF EXISTS update_nfrd_db_trigger ON ArchiveVersions;
DROP TRIGGER IF EXISTS update_nfrd_db_trigger ON CurrentVersions;

CREATE OR REPLACE FUNCTION update_nfrd_db() RETURNS TRIGGER AS $$
DECLARE
  author_name VARCHAR;
  source_id INT;
  article_id INT;
BEGIN
  -- Insert into Sources table
  INSERT INTO nfrd.Sources (name) VALUES (NEW.source_domain)
  ON CONFLICT DO NOTHING;

  -- Get the source ID
  SELECT id INTO source_id FROM nfrd.Sources WHERE name = NEW.source_domain;

  -- Insert into Articles table
  INSERT INTO nfrd.Articles (date_modify, date_download, localpath, filename, source_id, url, image_url, title, title_page, title_rss, maintext, description, date_publish, language, ancestor, descendant, version)
  VALUES (NEW.date_modify, NEW.date_download, NEW.localpath, NEW.filename, source_id, NEW.url, NEW.image_url, NEW.title, NEW.title_page, NEW.title_rss, NEW.maintext, NEW.description, NEW.date_publish, NEW.language, NEW.ancestor, NEW.descendant, NEW.version)
  RETURNING id INTO article_id;

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

    -- Insert into AuthorArticle table
    INSERT INTO nfrd.AuthorArticle (author_id, article_id) VALUES ((SELECT id FROM nfrd.Authors WHERE name = author_name), article_id);
  END LOOP;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_nfrd_db_trigger
AFTER INSERT ON CurrentVersions
FOR EACH ROW
EXECUTE FUNCTION update_nfrd_db();
