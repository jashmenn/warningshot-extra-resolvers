#
# example: 
# 
# - :branch: mysql_database
#   :environments:
#     :production:
#       - {host: "localhost", database: "applesauce"}
#       - {host: "localhost", database: "applesauce", user: "jerrys", password: "kids", user_host: "localhost", permissions: "ALL"}
#
begin
  require("highline")
  require("mysql")
rescue LoadError
  # uses TOMITA Masahiro's MySQL library (http://tmtm.org)
  warn "warning: There was a problem loading highline. You will not be able to use an MysqlDatabaseResolver until those gems are installed."
end

class WarningShot::MysqlDatabaseResolver
  include WarningShot::Resolver
  order  500

  branch :mysql_database
  description 'Validates that a specified database exists. Optionally grant permissions to a certain user iff that user does not already have access'

  MysqlSetupResource = Struct.new(:host, :database, :user, :password, :user_host, :permissions)

  cast Hash do |opts|
    MysqlSetupResource.new     opts[:host],
                               opts[:database],
                               opts[:user]        || "root",
                               opts[:password],
                               opts[:user_host]   || "localhost",
                               opts[:permissions] || "ALL"
  end
  
  register :test, {:name => :check_mysql_database_accessable} do |inst|
    # private_key = File.expand_path(inst.output_keyfile)
    # File.exists?(private_key) && File.exists?(private_key + ".pub") # public key
  end
  
  register :resolution, {:name => :create_mysql_database_and_maybe_user} do |inst|
    # h = HighLine.new
    # wants_to = inst.ask ? (h.ask("Do you want me to generate #{inst.output_keyfile} and #{inst.output_keyfile}.pub?: [Y/n]") =~ /^y/i) : true

    # if wants_to
    #   keygen_bin  = `which ssh-keygen`.strip
    #   kg_opts  = []
    #   kg_opts <<   "-t #{inst.key_type}"
    #   kg_opts << %Q{-N "#{inst.passphrase}"}
    #   kg_opts << %Q{-C "#{inst.comment}"}
    #   kg_opts <<   "-f #{inst.output_keyfile}"

    #   cmd = "#{keygen_bin} #{kg_opts.join(' ')}"
    #   h.say cmd
    #   %x{#{cmd}}

    #   private_key     = File.expand_path(inst.output_keyfile)
    #   both_keys_exist = File.exists?(private_key) && File.exists?(private_key + ".pub") 

    #   if ($? == 0 && both_keys_exist) # true or false on if it passed
    #     true
    #   else
    #     h.say("I'm sorry, it didn't appear I was successful in generating ssh key pairs")
    #     false
    #   end
    # else
    #   h.say("Will not resolve this issue, goodbye.")
    #   false # ergh, can't return... TODO
    # end

  end
end
