include_recipe "git"
include_recipe "nodejs"

if node["nodejs_project"]["repository"].nil?
  node.set["nodejs_project"]["repository"] = "git@github.com:vslinko/#{node["nodejs_project"]["project_name"]}.git"
end

if node["nodejs_project"]["dir"].nil?
  node.set["nodejs_project"]["dir"] = "/srv/#{node["nodejs_project"]["project_name"]}"
end

if node["nodejs_project"]["deploy_key"]["key"].nil?
  deploy_key = data_bag_item(node["nodejs_project"]["deploy_key"]["data_bag"], node["nodejs_project"]["deploy_key"]["data_bag_item"])[node["nodejs_project"]["deploy_key"]["data_bag_item_key"]]
else
  deploy_key = node["nodejs_project"]["deploy_key"]["key"]
end

if node["nodejs_project"]["build_system"] == "grunt"
  build_system_package = "grunt-cli"
  build_system_binary = "/usr/local/bin/grunt"
else
  build_system_package = node["nodejs_project"]["build_system"]
  build_system_binary = "/usr/local/bin/#{node["nodejs_project"]["build_system"]}"
end

node["nodejs_project"]["packages"].each do |package_name|
  package package_name
end

directory node["nodejs_project"]["dir"] do
  owner node["nodejs_project"]["user"]
  group node["nodejs_project"]["group"]
end

file "#{node["nodejs_project"]["dir"]}/id_deploy" do
  mode 0600
  owner node["nodejs_project"]["user"]
  group node["nodejs_project"]["group"]
  content deploy_key
end

template "#{node["nodejs_project"]["dir"]}/deploy-ssh-wrapper" do
  mode 0755
  owner node["nodejs_project"]["user"]
  group node["nodejs_project"]["group"]
end

git "#{node["nodejs_project"]["dir"]}/project" do
  repository node["nodejs_project"]["repository"]
  user node["nodejs_project"]["user"]
  group node["nodejs_project"]["group"]
  revision "master"
  ssh_wrapper "#{node["nodejs_project"]["dir"]}/deploy-ssh-wrapper"
end

execute "npm install" do
  cwd "#{node["nodejs_project"]["dir"]}/project/#{node["nodejs_project"]["build_dir"]}"
  user node["nodejs_project"]["user"]
  group node["nodejs_project"]["group"]
  env "HOME" => node["nodejs_project"]["dir"]
end

execute "npm install -g #{build_system_package}" do
  not_if { ::File.exists?("/usr/local/bin/#{build_system_binary}") }
end

include_recipe "nodejs_project::#{node["nodejs_project"]["env"]}"
