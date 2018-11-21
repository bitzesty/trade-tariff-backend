# Using elasticsearch paas service
ENV["ELASTICSEARCH_URL"] = PaasResolver.get_elasticsearch_config[:url]
