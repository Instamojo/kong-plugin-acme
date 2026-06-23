local acme_schema = require "kong.plugins.acme.schema"
local v = require("spec.helpers").validate_plugin_config_schema

describe("Plugin: acme (schema)", function()

  local tests = {
    {
      name = "accepts valid config",
      input = {
        account_email = "example@example.com",
        api_uri = "https://api.acme.org",
        stale_cert_cleanup_days = 180,
      },
      error = nil
    },
    ----------------------------------------
    {
      name = "accepts stale cleanup disabled",
      input = {
        account_email = "example@example.com",
        api_uri = "https://api.acme.org",
        stale_cert_cleanup_days = 0,
      },
      error = nil
    },
    ----------------------------------------
    {
      name = "rejects negative stale cleanup days",
      input = {
        account_email = "example@example.com",
        api_uri = "https://api.acme.org",
        stale_cert_cleanup_days = -1,
      },
      error = {
        config = {
          stale_cert_cleanup_days = "custom validation failed"
        }
      }
    },
    ----------------------------------------
    {
      name = "rejects invalid email",
      input = {
        account_email = "notaemail",
        api_uri = "https://api.acme.org",
      },
      error = {
        config = {
            account_email = "invalid value: notaemail"
        }
      }
    },
    ----------------------------------------
    {
        name = "must accpet ToS for Let's Encrypt (unaccpeted,staging)",
        input = {
          account_email = "example@example.com",
          api_uri = "https://acme-staging-v02.api.letsencrypt.org",
        },
        error = {
            ["@entity"] = {
                'terms of service must be accepted, see https://letsencrypt.org/repository/'
            },
            config = {
                tos_accepted = "value must be true",
            },
        },
      },
    ----------------------------------------
    {
        name = "must accpet ToS for Let's Encrypt (unaccpeted)",
        input = {
          account_email = "example@example.com",
          api_uri = "https://acme-v02.api.letsencrypt.org",
        },
        error = {
            ["@entity"] = {
                'terms of service must be accepted, see https://letsencrypt.org/repository/'
            },
            config = {
                tos_accepted = "value must be true",
            },
        },
      },
    ----------------------------------------
    {
        name = "must accpet ToS for Let's Encrypt (accepted)",
        input = {
          account_email = "example@example.com",
          api_uri = "https://acme-v02.api.letsencrypt.org",
          tos_accepted = true,
        },
      },
    ----------------------------------------
  }

  for _, t in ipairs(tests) do
    it(t.name, function()
      local output, err = v(t.input, acme_schema)
      assert.same(t.error, err)
      if t.error then
        assert.is_falsy(output)
      else
        assert.is_truthy(output)
      end
    end)
  end
end)
