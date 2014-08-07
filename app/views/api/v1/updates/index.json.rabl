collection @updates
attributes :update_type, :state, :created_at, :updated_at, :filename, :applied_at, :filesize, :exception_backtrace, :exception_queries, :exception_class

child :conformance_errors => :conformance_errors do
  attributes :model_name, :model_primary_key, :model_values, :model_conformance_errors
end
