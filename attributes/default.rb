default["nodejs_project"]["project_name"] = "nodejs_project"
default["nodejs_project"]["repository"] = nil

default["nodejs_project"]["dir"] = nil
default["nodejs_project"]["user"] = "www-data"
default["nodejs_project"]["group"] = "www-data"

default["nodejs_project"]["packages"] = []

default["nodejs_project"]["deploy_key"]["key"] = nil
default["nodejs_project"]["deploy_key"]["data_bag"] = "nodejs_project"
default["nodejs_project"]["deploy_key"]["data_bag_item"] = "settings"
default["nodejs_project"]["deploy_key"]["data_bag_item_key"] = "deploy_key"

default["nodejs_project"]["build_system"] = "gulp"
default["nodejs_project"]["build_dir"] = ""
default["nodejs_project"]["env"] = "production"
