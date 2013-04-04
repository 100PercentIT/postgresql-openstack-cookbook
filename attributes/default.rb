default["postgresql"]["services"]["db"]["scheme"] = "tcp"        # node_attribute
default["postgresql"]["services"]["db"]["port"] = 5432           # node_attribute
default["postgresql"]["services"]["db"]["network"] = "management"      # node_attribute

case platform
when "fedora", "redhat", "centos", "scientific", "amazon"
  default["mysql"]["platform"] = {                          # node_attribute
    "mysql_service" => "postgresql",
    "service_bin" => "/sbin/service"
  }
when "ubuntu", "debian"
  default["mysql"]["platform"] = {                          # node_attribute
    "mysql_service" => "postgresql",
    "service_bin" => "/usr/sbin/service"
  }
end
