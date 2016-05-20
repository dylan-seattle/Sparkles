SparkleFormation.dynamic(:autoscaling) do |_name, _config={}|

  dynamic!(:instance_common, :sparkle, _name)
  dynamic!(:cpu_alarm,:sparkle, _name)
  asg_resource = nil

  parameters do
    set!("#{_name}_asg_min_size") do
      description 'Minimum size for ASG'
      type 'Number'
      default 2
    end
    set!("#{_name}_asg_max_size") do
      description 'Maximum size for ASG'
      type 'Number'
      default 2
    end

      set!("#{_name}_email") do 
        type 'String'
        allowed_values registry!(:sns_subscription)
        default registry!(:sns_endpoint)
      end 

  

  end

  resources do

    set!("#{_name}_notification_topic".to_sym) do 
      type 'AWS::SNS::Topic'
      properties do 
        subscription [{"Endpoint" => ref!("#{_name}_email".to_sym), "Protocol" => "email"}] 
      end 
    end 
  
    set!("#{_name}_launch_configuration".to_sym) do
      type 'AWS::AutoScaling::LaunchConfiguration'
      properties do
        image_id ref!("#{_name}_image_id".to_sym)
        instance_type ref!("#{_name}_instance_type".to_sym)
        key_name ref!("#{_name}_key_name".to_sym)
        instance_monitoring 'true'

        if(_config[:user_data])
          user_data registry!(_config[:user_data], "#{_name}_launch_configuration".to_sym)
        end
      end
    end

    set!("#{_name}_autoscaling_group".to_sym) do
      type 'AWS::AutoScaling::AutoScalingGroup'
      properties do
        availability_zones azs!
        launch_configuration_name ref!("#{_name}_launch_configuration".to_sym)
        min_size ref!("#{_name}_asg_min_size".to_sym)
        max_size ref!("#{_name}_asg_max_size".to_sym)
        notification_configuration "TopicARN" => ref!("#{_name}_notification_topic".to_sym), "NotificationTypes" => registry!(:notification_type) 
      end
    end

    set!("#{_name}_cpu_alarm".to_sym) do 
      type 'AWS::CloudWatch::Alarm'
      properties do 
      evaluation_periods '6'
      dimensions ["Name" => "AutoScalingGroup" , "Value" => ref!("#{_name}_autoscaling_group".to_sym)]
      alarm_actions [ref!("#{_name}_notification_topic")]
      alarm_description 'Notify if Cpu high for > 6m'
      namespace 'AWS/EC2'
      period '60'
      comparison_operator 'GreaterThanThreshold'
      statistic 'Average'
      threshold '50'
      metric_name 'CPUUtilization'
    end
    end 
    

  end

  asg_resource
end