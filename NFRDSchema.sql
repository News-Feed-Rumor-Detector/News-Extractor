CREATE TABLE nfrd.Authors (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) UNIQUE NOT NULL,
  article_count INT DEFAULT 0
);

CREATE TABLE nfrd.Sources (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL
);

CREATE TABLE nfrd.Articles (
  id SERIAL PRIMARY KEY,
  source_id INTEGER REFERENCES nfrd.Sources(id),
  date_modify TIMESTAMP(0) NOT NULL,
  date_download TIMESTAMP(0) NOT NULL,
  localpath VARCHAR(255) NOT NULL,
  filename VARCHAR(2000) NOT NULL,
  url VARCHAR(2000) NOT NULL,
  image_url VARCHAR(2000),
  title VARCHAR(255) NOT NULL,
  title_page VARCHAR(255) NOT NULL,
  title_rss VARCHAR(255),
  maintext TEXT NOT NULL,
  description TEXT,
  date_publish TIMESTAMP(0),
  language VARCHAR(255),
  ancestor INTEGER NOT NULL DEFAULT 0,
  descendant INTEGER NOT NULL DEFAULT 0,
  version INTEGER NOT NULL DEFAULT 1
);

CREATE TABLE nfrd.AuthorArticle (
  author_id INTEGER,
  article_id INTEGER,
  PRIMARY KEY (author_id, article_id),
  FOREIGN KEY (author_id) REFERENCES nfrd.Authors(id),
  FOREIGN KEY (article_id) REFERENCES nfrd.Articles(id)
);
