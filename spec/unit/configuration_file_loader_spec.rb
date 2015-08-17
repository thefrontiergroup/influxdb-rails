require 'spec_helper'

describe InfluxDB::Rails::ConfigurationFileLoader do
  before do
    @configuration = InfluxDB::Rails::Configuration.new
  end

  describe "#set_configuration_values" do
    subject { InfluxDB::Rails::ConfigurationFileLoader.set_configuration_values(@configuration, filename) }

    context "No configuration file exists" do
      let(:filename) { "junk.yml" }

      specify "No Yaml should be loaded" do
        expect(YAML).to_not receive(:load_file)
        subject
      end
    end

    context "configuration file with all directives" do
      let(:filename) { "spec/support/complete_config_file.yml" }

      specify "Yaml should be loaded" do
        expect(YAML).to receive(:load_file).with(filename)
        subject
      end

      specify "the configuration should be set" do
        subject
        expect(@configuration.influxdb_hosts).to eq(["localhost", "otherhost"])
        expect(@configuration.influxdb_port).to eq(8056)
        expect(@configuration.influxdb_username).to eq("username")
        expect(@configuration.influxdb_password).to eq("password")
        expect(@configuration.influxdb_database).to eq("thedatabase")
        expect(@configuration.async).to eq(false)
        expect(@configuration.use_ssl).to eq(true)
        expect(@configuration.series_name_for_db_runtimes).to eq("series_for_db")
        expect(@configuration.series_name_for_view_runtimes).to eq("series_for_view")
        expect(@configuration.series_name_for_controller_runtimes).to eq("series_for_controller")
        expect(@configuration.debug).to eq(false)
        expect(@configuration.instrumentation_enabled).to eq(false)
      end
    end

    context "configuration file with some directives" do
      let(:filename) { "spec/support/config_file.yml" }

      specify "Yaml should be loaded" do
        expect(YAML).to receive(:load_file).with(filename)
        subject
      end

      specify "the configuration should be set" do
        defaults = InfluxDB::Rails::Configuration::DEFAULTS
        subject
        expect(@configuration.influxdb_hosts).to eq(["localhost", "otherhost"])
        expect(@configuration.influxdb_port).to eq(8056)
        expect(@configuration.influxdb_username).to eq("username")
        expect(@configuration.influxdb_password).to eq("password")
        expect(@configuration.influxdb_database).to eq("thedatabase")
        expect(@configuration.async).to eq(defaults[:async])
        expect(@configuration.use_ssl).to eq(defaults[:use_ssl])
        expect(@configuration.series_name_for_db_runtimes).to eq(defaults[:series_name_for_db_runtimes])
        expect(@configuration.series_name_for_view_runtimes).to eq(defaults[:series_name_for_view_runtimes])
        expect(@configuration.series_name_for_controller_runtimes).to eq(defaults[:series_name_for_controller_runtimes])
        expect(@configuration.debug).to eq(false)
        expect(@configuration.instrumentation_enabled).to eq(true)
      end
    end    
  end
end
