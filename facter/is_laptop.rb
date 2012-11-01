#
require "facter"
Facter.add(:is_laptop) do
  setcode do

    acpidirname = "/proc/acpi/battery"    
    sysdirname  = "/sys/class/power_supply/"

    is_laptop = "false"

    # check in /proc (old fashion)
    if File.exists?(acpidirname) && File.directory?(acpidirname)
      Dir.open(acpidirname) do |battery|
        battery.each do |file|
          # do something with dirname/file
          if File.exists?("#{sysdirname}/#{file}/info")
            if File.readlines("#{sysdirname}/#{file}/info").grep(/^present:.*yes/).size > 0
              is_laptop = "true"
            end
          end
        end
      end
    end

    # check in /sys (new fashion) only if no information found in /proc
    if is_laptop == "false"
      if File.exists?(sysdirname) && File.directory?(sysdirname)
        Dir.open(sysdirname) do |battery|
          battery.each do |file|
            if File.exists?("#{sysdirname}/#{file}/present")
              if File.readlines("#{sysdirname}/#{file}/present").grep(/^1$/).size > 0
                is_laptop = "true"
              end
            end
          end
        end
      end
    end
    is_laptop
  end
end
