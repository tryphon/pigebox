# -*- coding: utf-8 -*-

require "net/telnet"

class Box

  def boot
    disks = []

    Dir["dist/{disk,storage*}"].each_with_index do |file, index|
      disks << "-drive file=#{file},if=ide,index=#{index},media=disk"
    end
    # -nographic
    qemu_command = "qemu -daemonize -pidfile qemu.pid -enable-kvm -snapshot -serial telnet::4444,server,nowait -monitor telnet::4445,server,nowait -net nic,vlan=0 -net user,hostfwd=tcp:127.0.0.1:8000-:80 #{disks.join(' ')} -m 384m -soundhw es1370"

    puts qemu_command
    system qemu_command
  end

  def start
    puts "* start box"

    boot
    wait_for_console
  end

  def save
    monitor "savevm test"
  end

  def rollback
    monitor "loadvm test"
  end


  def stop
    puts "* stop box"

    open_monitor do |monitor|
      monitor.cmd("quit") 
    end
  rescue Errno::ECONNRESET
    # normal
  end

  def kill
    system "kill -9 `cat qemu.pid`"
  end

  def wait_for_console
    sleep 10
    open_console do |console|
      # ready
    end
  end

  def open_monitor
    Net::Telnet::new("Host" => "localhost", "Port" => 4445, "Output_log" => "monitor.log", "Prompt" => /^\(qemu\) \z/n).tap do |monitor|
      yield monitor
      monitor.close
    end
  end

  def open_console
    Net::Telnet::new("Host" => "localhost", "Port" => 4444, "Output_log" => "console.log").tap do |console|
      console.write("\x04")
      console.login("root")
      yield console
      console.close
    end
  end

  def monitor(command)
    open_monitor { |m| m.cmd(command) }
  end

end

box = Box.new
box.start

box.save

at_exit do
  box.stop
end

After do
  box.rollback
end

# monitor = Net::Telnet::new("Host" => "localhost", "Port" => 4445, "Output_log" => "monitor.log", "Prompt" => /^\(qemu\) \z/n)

# puts "* save vm state"
# monitor.cmd("savevm test")

# console = Net::Telnet::new("Host" => "localhost", "Port" => 4444, "Output_log" => "console.log")

# puts "* create a file"

# console.write("\x04")
# console.login("root")

# console.cmd("touch /tmp/test")
# console.puts("exit")

# console.close

# puts "* rollback vm"
# monitor.cmd("loadvm test")

# puts "* check if file exists"

# console = Net::Telnet::new("Host" => "localhost", "Port" => 4444, "Output_log" => "console-after.log")

# console.write("\x04")
# console.login("root")

# console.cmd("ls /tmp/test") { |output| puts output }
# console.puts("exit")

# console.close
