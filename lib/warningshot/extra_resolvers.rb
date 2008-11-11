%w{warningshot 
   highline 
   pp}.each do |lib|
  begin
    require lib
  rescue LoadError
    warn "There was a problem loading '#{lib}'"
  end
end

Dir[File.dirname(__FILE__) + "/../resolvers/*.rb"].each {|f| require f}

module WarningShot
end
