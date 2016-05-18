SparkleFormation.new(:computes) do 

	paramters do 
		ssh_key_name.type 'String'
		network_vpc.id.type 'String'
		network_subnet_id.type 'String'
		image_id_name do 
			type 'String'
			default 'AMI-NAME'
		end 
	end 

	dynamic!(:ec2_security_group, :compute) do 
		properties do
			group_description 'SSH Access'
			security_group_ingress do
				cidr ip '0.0.0.0/0'
				from_port 22
				to_port 22
				ip_protocol 'tcp'
			end 
			vpc_id ref!(:network_vpc_id)
		end 
	end 

	dynamic!(:ec2_instance, :micro) do 
		properties do 
			image_id ref!(:image_id_name)
			instance_type 't2.micro'
			key_name ref!(:ssh_key_name)
			network_interfaces array!(
				->{
					device_index 0
					associate_public_ip_address 'true'
					subnet_id ref!(:network_subnet_id)
					group_set [ref!(:compute_ec2_security_group)]
					})
		end 
	end 
	dynamic!(:ec2_instance, :micro) do 
		properties do 
			image_id ref!(:image_id_name)
			instance_type 't2.micro'
			key_name ref!(:ssh_key_name)
			network_interfaces array!(
				->{
					device_index 0
					associate_public_ip_address 'true'
					subnet_id ref!(:network_subnet_id)
					group_set [ref!(:compute_ec2_security_group)]
					})
		end 
	end 

	outputs do 
		micro_address.value attr!(:micro_ec2_instance, :public_ip)
		micro_address.value attr!(:micro_ec2_instance, :public_ip)
	end 
	
end