SparkleFormation.dynamic(:instance_common) do |_name, _config|
  

  parameters do
    set!("#{_name}_image_id".to_sym) do
      #need default instances - here 
      default 'ami-ad42009d'
      allowed_values ['ami-ad42009d', 'ami-c7d092f7']
      description 'AMI Image ID'
      type 'String'
    end

    set!("#{_name}_instance_type".to_sym) do
      default 't2.micro'
      description 'Size of instance'
      type 'String'
    end

    set!("#{_name}_key_name".to_sym) do
      default 'worpress-labs'
      description 'EC2 SSH key name'
      type 'String'
    end
  end
end