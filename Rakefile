require "json"
require "fileutils"

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
      FileUtils.rm_rf(dep)
      FileUtils.cp_r("bento/#{dep}", dep)
    end
  end
end

DEFAULT_BASE_OS = "ubuntu-15.10"

base_os = ENV.fetch("BASE_OS", DEFAULT_BASE_OS)
virt    = ENV.fetch("VIRT", "vmware")

packer_variables = {
  atlas_username: "{{env `ATLAS_USERNAME`}}",
  atlas_name: "{{env `ATLAS_NAME`}}",
  atlas_token: "{{env `ATLAS_TOKEN`}}",
  build_version: "0.1.{{env `ATLAS_BUILD_NUMBER`}}"
}
packer_push = {
  name: "{{user `atlas_username`}}/{{user `atlas_name`}}",
  vcs: true
}
packer_atlas = {
  type: "atlas",
  artifact: "{{user `atlas_username`}}/{{user `atlas_name`}}",
  artifact_type: "base-vm.box",
  metadata: {
    provider: "vmvware",
    version: "{{user `build_version`}}"
  }
}

namespace :base do
  desc "Assemble base box JSON"
  task :assemble => "bento:prepare" do
    bento_json = JSON.parse(File.read("bento/#{base_os}-amd64.json"))

    bento_json["builders"]        = bento_json["builders"].select { |builder| builder["type"] == "#{virt}-iso" }
    bento_json["variables"]       = bento_json["variables"].merge(packer_variables)
    bento_json["push"]            = packer_push
    bento_json["post-processors"] = [[packer_atlas]]

    File.open("base.json", "w+") { |f| f.puts JSON.pretty_generate(bento_json) }
  end

  desc "Build base box"
  task :build => :assemble do
    system "packer build base.json"
  end
end
