package "nfs-kernel-server"

template "/etc/exports"

service "nfs-kernel-server" do
  action [:restart]
end
