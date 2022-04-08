return {
  postgres = {
    up = [[
      DO $$
      BEGIN
        ALTER TABLE IF EXISTS ONLY "acme_domain" ADD "target" TEXT;
      EXCEPTION WHEN DUPLICATE_COLUMN THEN
        -- Do nothing, accept existing state
      END;
    $$;
    ]],
  },

  cassandra = {
    up = [[
      ALTER TABLE acme_domain ADD target text;
    ]],
  },
}
