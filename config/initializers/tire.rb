Tire.configure do
  logger 'log/elasticsearch.log', level: "warn"
  logger STDERR, level: "warn"
end
