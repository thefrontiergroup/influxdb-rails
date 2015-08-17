module InfluxDB
  module Rails
    class ConfigurationFileLoader
      MAPPINGS = { 
        hosts: "influxdb_hosts", port: "influxdb_port", 
        username: "influxdb_username", password: "influxdb_password",
        database: "influxdb_database", async: true, use_ssl: true,
        series_name_for_db_runtimes: true, series_name_for_view_runtimes: true,
        series_name_for_controller_runtimes: true, ignored_exceptions: true,
        ignored_exception_messages: true, ignored_reports: true, 
        backtrace_filters: true, environment_variable_filters: true,
        aggregated_exception_classes: true, debug: true, rescue_global_exceptions: true,
        instrumentation_enabled: true
      }.freeze

      def self.set_configuration_values(object)
        return unless File.exists?("#{::Rails.root}/config/influxdb.yml")
        values = YAML.load_file("#{::Rails.root}/config/influxdb.yml")[::Rails.env]

        MAPPINGS.each do |config_name, method_name|
          if values.has_key? config_name.to_s
            if method_name.is_a? TrueClass
              normalised_method_name = config_name
            else
              normalised_method_name = method_name
            end
            object.send("#{normalised_method_name}=", values[config_name.to_s])
          end
        end
      end

    end
  end
end

