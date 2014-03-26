node.override["nginx"]["default_site_enabled"] = false

include_recipe "nginx"

template "/etc/init/#{node["nodejs_project"]["project_name"]}.conf" do
  source "upstart.conf.erb"
end

link "/lib/init/upstart-job" do
  to "/etc/init.d/#{node["nodejs_project"]["project_name"]}"
end

service node["nodejs_project"]["project_name"] do
  provider Chef::Provider::Service::Upstart
  action [:enable, :start]
end

template "/etc/nginx/sites-available/#{node["nodejs_project"]["project_name"]}" do
  source "nginx_site.erb"
end

nginx_site node["nodejs_project"]["project_name"]
