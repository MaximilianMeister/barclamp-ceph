resource = "ceph"
main_role = "mon"
role_name = "#{resource}-#{main_role}"

unless node["roles"].include?(role_name)
  ceph_mon_service = []
  node[resource]["services"][main_role].each do |name|
    ceph_mon_service << name
  end

  barclamp_role role_name do
    service_name node[resource]["services"][main_role]
    action :remove
  end

  node[resource]["services"].delete(main_role)
  node.delete(resource) if node[resource]["services"].empty?

  node.save
end
