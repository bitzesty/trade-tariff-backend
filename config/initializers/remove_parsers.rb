# Disable parts of Rails that we don't need and offer potential attack vectors.
ActionDispatch::ParamsParser::DEFAULT_PARSERS.delete(Mime::XML) 
ActionDispatch::ParamsParser::DEFAULT_PARSERS.delete(Mime::JSON) 
