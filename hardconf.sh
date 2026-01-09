#!/bin/bash
# -*- coding: utf-8 -*-

# 1. INSTALLATION DES ARMURES
sudo apt update
sudo apt install -y apparmor apparmor-utils apparmor-profiles apparmor-profiles-extra
sudo apt install -y rkhunter clamav clamav-daemon aide crowdsec crowdsec-firewall-bouncer ufw

# Configuration ClamAV
sudo systemctl start clamav-daemon
sudo systemctl enable clamav-daemon

# 2. CONFIGURATION DU PARE-FEU (UFW)
# Correction des fautes de frappe "defaulft" -> "default"
sudo ufw --force reset
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw default deny routed

# Blocage des ports dangereux
sudo ufw deny 21
sudo ufw limit 22/tcp
sudo ufw deny 23
sudo ufw deny 3389
sudo ufw deny 20
sudo ufw deny 137:139/udp
sudo ufw deny 445
sudo ufw limit 80/tcp
sudo ufw limit 443/tcp
sudo ufw deny 161:162
sudo ufw deny 631

sudo ufw --force enable

# 3. HARDENING KERNEL (Sysctl)
echo "--- Hardening Kernel pour RedBlackNet ---"
echo "1) Hardening Strict (Maximum de sécurité)"
echo "2) Hardening Standard (Équilibre)"
read -p "Choisissez le niveau de durcissement (1/2) : " kernel_choice

CONF_FILE="/etc/sysctl.d/99-hardening.conf"

case $kernel_choice in
    1)
        echo "[+] Application du Hardening STRICT..."
        sudo cat <<EOF > $CONF_FILE
net.ipv4.conf.all.rp_filter = 1
net.ipv4.conf.default.rp_filter = 1
net.ipv4.conf.all.accept_redirects = 0
net.ipv4.conf.default.accept_redirects = 0
net.ipv4.conf.all.secure_redirects = 0
net.ipv4.conf.default.secure_redirects = 0
net.ipv6.conf.all.accept_redirects = 0
net.ipv6.conf.default.accept_redirects = 0
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_rfc1337 = 1
net.ipv4.icmp_echo_ignore_broadcasts = 1
net.ipv4.icmp_ignore_bogus_error_responses = 1
kernel.randomize_va_space = 2
kernel.kptr_restrict = 2
kernel.perf_event_paranoid = 3
kernel.yama.ptrace_scope = 2
dev.tty.ldisc_autoload = 0
fs.protected_fifos = 2
fs.protected_regular = 2
net.ipv4.conf.all.accept_source_route = 0
EOF
        ;;
    2)
        echo "[+] Application du Hardening STANDARD..."
        sudo cat <<EOF > $CONF_FILE
net.ipv4.conf.all.rp_filter = 1
net.ipv4.tcp_syncookies = 1
net.ipv4.conf.all.accept_redirects = 0
kernel.randomize_va_space = 2
EOF
        ;;
    *) echo "[X] Choix annulé." ;;
esac

sudo sysctl -p $CONF_FILE

# 4. CONFIGURATION APPARMOR
echo "--- Configuration AppArmor ---"
echo "1) Full Enforce"
echo "2) Complain Mode"
read -p "Choisissez votre mode (1/2) : " aa_choice

case $aa_choice in
    1) sudo aa-enforce /etc/apparmor.d/* ;;
    2) sudo aa-complain /etc/apparmor.d/* ;;
    *) echo "[X] Ignoré." ;;
esac

sudo aa-status

sudo apt update
sudo apt upgrade
echo "--- Hardening terminé avec succès ---"
