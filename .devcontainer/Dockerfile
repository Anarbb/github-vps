FROM kalilinux/kali-rolling

ENV DEBIAN_FRONTEND=noninteractive

# Update package lists and install system utilities + full Kali XFCE desktop
RUN apt-get update && apt-get install -y --no-install-recommends \
    sudo \
    curl \
    wget \
    git \
    ca-certificates \
    gnupg \
    lsb-release \
    net-tools \
    iproute2 \
    procps \
    nano \
    vim \
    htop \
    zsh \
    tmux \
    fastfetch \
    openvpn \
    iptables \
    pciutils \
    usbutils \
    locales \
    xfce4 \
    xfce4-terminal \
    xfce4-appfinder \
    kali-themes \
    kali-menu \
    dbus-x11 \
    thunar \
    mousepad \
    firefox-esr \
    && ln -s /usr/bin/fastfetch /usr/local/bin/neofetch 2>/dev/null || true \
    && sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
    && dpkg-reconfigure --frontend=noninteractive locales \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

# Create default non-root 'kali' user with passwordless sudo access
RUN useradd -m -s /bin/bash -u 1000 -U kali \
    && echo "kali:kali" | chpasswd \
    && usermod -aG sudo kali \
    && echo "kali ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/kali \
    && chmod 0440 /etc/sudoers.d/kali

# Configure XFCE as default desktop session for VNC
RUN mkdir -p /home/kali/.vnc /root/.vnc /etc/skel/.vnc \
    && printf '#!/bin/sh\nunset SESSION_MANAGER\nunset DBUS_SESSION_BUS_ADDRESS\n[ -r "$HOME/.Xresources" ] && xrdb "$HOME/.Xresources"\nexec dbus-launch --exit-with-session startxfce4\n' > /home/kali/.vnc/xstartup \
    && cp /home/kali/.vnc/xstartup /root/.vnc/xstartup \
    && cp /home/kali/.vnc/xstartup /etc/skel/.vnc/xstartup \
    && chmod +x /home/kali/.vnc/xstartup /root/.vnc/xstartup /etc/skel/.vnc/xstartup \
    && chown -R kali:kali /home/kali/.vnc

USER kali
WORKDIR /home/kali
