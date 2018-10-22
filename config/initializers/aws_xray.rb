
sampling_rules =  {
  "version": 2,
  "rules": [
    {
      "description": "DEBUG",
      "priority": "1",
      "host": "*",
      "http_method": "*",
      "url_path": "/*",
      "fixed_target": 1,
      "reservoir": 1,
      "rate": 1
    }
  ],
  "default": {
    "priority": "1",
    "fixed_target": 1,
    "reservoir": 1,
    "rate": 1
  }
}

Rails.application.config.xray = {
    name: 'imagetrends',
    sampling: false,
    sampling_rules: sampling_rules,
    patch: %I[net_http aws_sdk],
    active_record: true,
    context_missing: 'LOG_ERROR'
  }
