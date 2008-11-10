%w{warningshot 
   highline 
   pp}.each do |lib|
  begin
    require lib
  rescue LoadError
    warn "There was a problem loading '#{lib}'"
  end
end

module WarningShot
end
