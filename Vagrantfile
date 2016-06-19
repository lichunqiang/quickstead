require 'json'
require 'yaml'

VAGRANTFILE_API_VERSION = "2"

confDir = File.expand_path(File.dirname(__FILE__) + "/config");

configPath = confDir + "/config.yaml"
aliasesPath = confDir + "/aliases"
afterScriptPath = confDir + "/after.sh"

require File.expand_path(File.dirname(__FILE__) + '/scripts/quickstead.rb')

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  Quickstead.configure(config, YAML::load(File.read(configPath)))

  if File.exists? afterScriptPath then
    config.vm.provision "shell", path: afterScriptPath, privileged: false
  end

  if File.exists? afterScriptPath then
    config.vm.provision "shell", path: afterScriptPath, privileged: false
  end

end