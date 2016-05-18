SparkleFormation.dynamic(:node) do |name, opts={}|

  parameters do
    set!("#{name}_image_id".to_sym).type 'String'
    set!("#{name}_ssh_key_name".to_sym).type 'String'
    set!("#{name}_size".to_sym) do
      type 'String'
      default 't2.small'
      allowed_values registry!(:instance_size)
    end
  end
 dynamic!(:ec2_instance, name) do
    properties do
      image_id ref!("#{name}_image_id".to_sym)
      instance_type ref!("#{name}_size".to_sym)
      key_name ref!("#{name}_ssh_key_name".to_sym)
    end
  end
  
  outputs.set!("#{name}_public_address".to_sym) do
    description "Compute instance public address - #{name}"
    value attr!("#{name}_ec2_instance".to_sym, :public_ip)
  end

 

end