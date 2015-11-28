require "json"
require "yaml"

namespace :bento do
  desc "Clone bento repo"
  task :clone do
    if File.exists?("bento")
      puts "Already cloned. Nothing to do."
    else
      system "git clone https://github.com/chef/bento.git bento"
    end
  end

  desc "Pull latest bento"
  task :pull => :clone do
    puts "Pulling latest changes from bento repo."

    Dir.chdir("bento") do
      system "git pull"
    end
  end

  desc "Prepare bento for working"
  task :prepare => :pull do
    puts "Copy required bento files into root"

    %w(scripts http floppy).each do |dep|
      rm_rf(dep)
      cp_r("bento/#{dep}", dep)
    end

    # This should be replaced as soon as Bento fixes this problem
    puts "[FIXME] Replacing --force-install with --default"
    vmtools_script = File.read("scripts/common/vmtools.sh")
    File.open("scripts/common/vmtools.sh", "w") do |file|
      file.puts vmtools_script.gsub("--force-install", "--default")
    end
  end
end

DEFAULT_BASE_OS = "ubuntu-15.10"
DEFAULT_VIRT = "vmware"

base_os = ENV.fetch("BASE_OS", DEFAULT_BASE_OS)
virt    = ENV.fetch("VIRT", DEFAULT_VIRT)

packer_variables = YAML.load_file('data/packer_variables.yaml')
packer_push = YAML.load_file('data/packer_push.yaml')
packer_atlas = YAML.load_file('data/packer_atlas.yaml')

namespace :base do
  desc "Assemble base box JSON"
  task :assemble => "bento:prepare" do
    bento_json = JSON.parse(File.read("bento/#{base_os}-amd64.json"))

    bento_json["builders"]        = bento_json["builders"].select { |builder| builder["type"] == "#{virt}-iso" }
    bento_json["variables"]       = bento_json["variables"].merge(packer_variables)
    bento_json["push"]            = packer_push
    bento_json["post-processors"] = [packer_atlas]

    File.write("base.json", JSON.pretty_generate(bento_json))
  end

  desc "Build base box"
  task :build => :assemble do
    system "packer build base.json"
  end
end
