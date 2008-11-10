#
# example: 
# 
# - :branch: ssh_key_pair
#   :environments:
#     :production:
#       - {key_type: "rsa", passphrase: '', comment: '', output_keyfile: "~/.ssh/id_rsa"}
#
class WarningShot::SshKeyPairResolver
  include WarningShot::Resolver
  order  100

  branch :ssh_key_pair
  description 'Validates the current user has an ssh public/private key pair'

  SshKeygenInstructions = Struct.new(:key_type, 
                                     :passphrase, 
                                     :comment, 
                                     :output_keyfile, 
                                     :ask)

  cast Hash do |opts|
    SshKeygenInstructions.new  opts[:key_type]       || "rsa", 
                               opts[:passphrase]     || "", 
                               opts[:comment]        || "", 
                               opts[:output_keyfile] || "~/.ssh/id_rsa",
                               opts[:ask]            || false            # ask if you want to create this
  end
  
  register :test, {:name => :check_ssh_key_pair_exists} do |inst|
    private_key = File.expand_path(inst.output_keyfile)
    File.exists?(private_key) && File.exists?(private_key + ".pub") # public key
  end
  
  register :resolution, {:name => :generate_ssh_key_pair} do |inst|
    h = HighLine.new
    wants_to = inst.ask ? (h.ask("Do you want me to generate #{inst.output_keyfile} and #{inst.output_keyfile}.pub?: [Y/n]") =~ /^y/i) : true

    if wants_to
      keygen_bin  = `which ssh-keygen`.strip
      kg_opts  = []
      kg_opts <<   "-t #{inst.key_type}"
      kg_opts << %Q{-N "#{inst.passphrase}"}
      kg_opts << %Q{-C "#{inst.comment}"}
      kg_opts <<   "-f #{inst.output_keyfile}"

      cmd = "#{keygen_bin} #{kg_opts.join(' ')}"
      h.say cmd
      %x{#{cmd}}

      private_key     = File.expand_path(inst.output_keyfile)
      both_keys_exist = File.exists?(private_key) && File.exists?(private_key + ".pub") 

      if ($? == 0 && both_keys_exist) # true or false on if it passed
        true
      else
        h.say("I'm sorry, it didn't appear I was successful in generating ssh key pairs")
        false
      end
    else
      h.say("Will not resolve this issue, goodbye.")
      false # ergh, can't return... TODO
    end

  end
end
