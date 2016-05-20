SparkleFormation.dynamic(:cpu_alarm) do |_name,_config={}| 

  #dynamic!(:instance_common,:sparkle, _name)


resources do 
  set!("#{_name}_cpu_alarm".to_sym) do 
    type 'AWS::CloudWatch::Alarm'
    properties do 
      evaluation_periods '6'
      dimensions ["Name" => "AutoScalingGroup" , "Value" => ref!("#{_name}_autoscaling_group".to_sym)]
      alarm_actions [ref!("#{_name}_notification_topic")]
      alarm_description ['Notify if Cpu high for > 6m']
      namespace 'AWS/EC2'
      period '60'
      comparison_operator 'GreaterThanThreshold'
      statistic 'Average'
      threshold '50'
      metric_name 'CPUUtilization'
    end
    end 
    end   



end