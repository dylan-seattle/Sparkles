SparkleFormation.new(:compute, :provider => :aws).load(:base).overrides do
  dynamic!(:node, :web)
  dynamic!(:node, :app)
end