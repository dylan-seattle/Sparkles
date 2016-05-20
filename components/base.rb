SparkleFormation.build do
  set!('AWSTemplateFormatVersion', '2010-09-09')
  description 'Default stack description'

  mappings.platform('us-west-2'._no_hump) do 
  	_camel_keys_set(:auto_disable)
  	set!('ubuntu1204', 'ami-ad42009d')
  	set!('ubuntu1404', 'ami-a94e0c99')
  end 

  
 resources do
    stack_iam_user do
      type 'AWS::IAM::User'
      properties do
        path '/'
        policies array!(
          -> {
            policy_name 'stack_description_access'
            policy_document.statement array!(
              -> {
                effect 'Allow'
                action 'cloudformation:DescribeStackResource'
                resource '*'
              }
            )
          }
        )
      end
    end

    stack_iam_access_key do
      type 'AWS::IAM::AccessKey'
      properties do
        user_name ref!(:stack_iam_user)
        status 'Active'
      end
    end

  end
  

end