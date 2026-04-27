#!/bin/bash

# Detecta usuário automaticamente
USERNAME=$(whoami)

echo "Usuário detectado: $USERNAME"

# Detecta gerenciador de pacotes e instala x11vnc
if command -v zypper >/dev/null; then
    echo "Detectado: openSUSE"
    sudo zypper refresh
    sudo zypper install -y x11vnc

elif command -v apt >/dev/null; then
    echo "Detectado: Ubuntu/Debian"
    sudo apt update
    sudo apt install -y x11vnc

elif command -v pacman >/dev/null; then
    echo "Detectado: Arch/Manjaro"
    sudo pacman -Syu --noconfirm x11vnc

elif command -v dnf >/dev/null; then
    echo "Detectado: Fedora"
    sudo dnf check-update
    sudo dnf install -y x11vnc

else
    echo "Gerenciador de pacotes não suportado."
    exit 1
fi

# Cria diretório .vnc se não existir
mkdir -p /home/$USERNAME/.vnc

# Solicita a senha do VNC (mantendo tua lógica com sudo)
sudo x11vnc -storepasswd /home/$USERNAME/.vnc/passwd

# Nome do script final
FILE_NAME="startvnc.sh"

# Cria o script de inicialização
cat << EOF > "$FILE_NAME"
#!/bin/bash

# Iniciar o servidor VNC (x11vnc)
x11vnc -display :0 -noxrecord -noxfixes -noxdamage -forever -bg -rfbauth /home/$USERNAME/.vnc/passwd
EOF

# Move e dá permissão
sudo mv "$FILE_NAME" /usr/local/bin/
sudo chmod +x /usr/local/bin/startvnc.sh

echo "Arquivo /usr/local/bin/startvnc.sh criado com sucesso!"
