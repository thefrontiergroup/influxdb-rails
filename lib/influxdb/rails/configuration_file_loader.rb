module InfluxDB
  module Rails
    class ConfigurationFileLoader
      MAPPINGS = { 
        hosts: "influxdb_hosts", port: "influxdb_port", 
        username: "influxdb_username", password: "influxdb_password",
        database: "influxdb_database", async: true, use_ssl: true,
        series_name_for_db_runtimes: true, series_name_for_view_runtimes: true,
        series_name_for_controller_runtimes: true, debug: true, 
        instrumentation_enabled: true
      }.freeze

      def self.set_configuration_values(object, file = "#{::Rails.root}/config/influxdb.yml")
        return unless File.exists?(file)
        configs = YAML.load_file(file)
        return unless configs.present? && configs.has_key?(::Rails.env)
        values = configs[::Rails.env]

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

