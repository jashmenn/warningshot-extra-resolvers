require 'warningshot'
$:.unshift File.dirname(__FILE__) + "/../../lib"
require 'warningshot/extra_resolvers'

$test_data  = "." / "test" / "data"
$log_root   = "." / "test" / "log"
$log_file   = $log_root / 'warningshot.log'

FileUtils.mkdir_p $log_root

$logger = Logger.new $log_file
$logger.formatter = WarningShot::LoggerFormatter.new
$logger.level     = Logger::DEBUG
