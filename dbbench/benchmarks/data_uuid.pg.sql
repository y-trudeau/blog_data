CREATE TABLE data_uuid (
  id serial NOT NULL PRIMARY KEY,
  a char(36) NOT NULL,
  b char(36) NOT NULL,
  c char(36) NOT NULL,
  status INT NOT NULL DEFAULT '0'
);
CREATE INDEX idx_ab ON data_uuid (a,b);
CREATE INDEX idx_ba ON data_uuid (b,a);
CREATE INDEX idx_ca ON data_uuid (c,a);
CREATE INDEX idx_cb ON data_uuid (c,b);
CREATE INDEX idx_acb ON data_uuid (a,c,b);
CREATE INDEX idx_bca ON data_uuid (b,c,a);
