# Installation of consul

Download :
    
    wget https://releases.hashicorp.com/consul/0.6.4/consul_0.6.4_linux_arm.zip
    wget https://releases.hashicorp.com/consul/0.6.4/consul_0.6.4_web_ui.zip

Extract it. Then copy `consul` to /usr/local/bin/ and `consul-ui` in `/home/pi/consul/ui`.

Run consul interface :

    consul agent -dev -ui -ui-dir /home/pi/consul/ui -bind piensg010 -client piensg010
