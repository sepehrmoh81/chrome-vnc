#!/bin/bash

# Add Chrome repository
wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo tee /etc/apt/trusted.gpg.d/google.asc >/dev/null
sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'

# Update system
sudo apt update && sudo apt upgrade -y

# Install VNC server, basic window manager, Chrome, basic X11 fonts, GNOME-Terminal
sudo apt install -y tightvncserver fluxbox google-chrome-stable xfonts-base xfonts-75dpi xfonts-100dpi gnome-terminal

# Update font cache
sudo fc-cache -fv

# Start VNC server for initial setup (will prompt for password)
vncserver :1 -geometry 1600x900 -depth 24

# Stop the server to configure it
vncserver -kill :1

# Setup machine_id
systemd-machine-id-setup
dbus-uuidgen --ensure=/etc/machine-id

# Create launcher script
cat > /root/launch-chrome.sh << 'EOF'
#!/bin/bash
google-chrome --no-sandbox --disable-dev-shm-usage &
EOF

# Set executable permissions
chmod +x /root/launch-chrome.sh

sed -i '2i\[exec] (Google Chrome) {/root/launch-chrome.sh} </opt/google/chrome/product_logo_32.xpm>' /root/.fluxbox/menu

reboot
