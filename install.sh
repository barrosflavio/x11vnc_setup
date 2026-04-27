#!/bin/bash

# Detecta usuário automaticamente
USERNAME=$(whoami)

echo "Usuário detectado: $USERNAME"
echo ""

# Verifica ambiente gráfico
DESKTOP_ENV="$XDG_CURRENT_DESKTOP"
SESSION_TYPE="$XDG_SESSION_TYPE"

echo "Ambiente detectado: $DESKTOP_ENV"
echo "Sessão: $SESSION_TYPE"
echo ""

# Validação KDE + Xorg
if [[ "$DESKTOP_ENV" != *"KDE"* ]] || [[ "$SESSION_TYPE" != "x11" ]]; then
    echo "❌ Este script é compatível apenas com KDE Plasma rodando em Xorg (X11)."
    echo "Ambiente atual: $DESKTOP_ENV / $SESSION_TYPE"
    echo "Execução cancelada."
    exit 1
fi

echo "✅ Ambiente compatível (KDE + Xorg)"
echo ""

# Pergunta de confirmação
read -p "Deseja prosseguir com a instalação? (S/N): " CONFIRM

CONFIRM=$(echo "$CONFIRM" | tr '[:lower:]' '[:upper:]')

if [ "$CONFIRM" != "S" ]; then
    echo "Operação cancelada pelo usuário."
    exit 0
fi

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

# Solicita a senha do VNC (mantendo tua lógica)
sudo x11vnc -storepasswd /home/$USERNAME/.vnc/passwd

# Nome do script final
FILE_NAME="startvnc.sh"

# Cria o script de inicialização
cat << EOF > "$FILE_NAME"
#!/bin/bash
x11vnc -display :0 -noxrecord -noxfixes -noxdamage -forever -bg -rfbauth /home/$USERNAME/.vnc/passwd
EOF

# Move e dá permissão
sudo mv "$FILE_NAME" /usr/local/bin/
sudo chmod +x /usr/local/bin/startvnc.sh

echo ""
echo "Arquivo /usr/local/bin/startvnc.sh criado com sucesso!"
echo ""

# Pergunta se quer adicionar na inicialização
read -p "Deseja adicionar o VNC na inicialização do sistema? (S/N): " AUTOSTART

AUTOSTART=$(echo "$AUTOSTART" | tr '[:lower:]' '[:upper:]')

if [ "$AUTOSTART" = "S" ]; then
    SERVICE_FILE="/etc/systemd/system/x11vnc.service"

    sudo bash -c "cat > $SERVICE_FILE" << EOF
[Unit]
Description=Start x11vnc at startup
After=display-manager.service

[Service]
Type=simple
ExecStart=/usr/local/bin/startvnc.sh
Restart=always
User=$USERNAME

[Install]
WantedBy=multi-user.target
EOF

    sudo systemctl daemon-reexec
    sudo systemctl daemon-reload
    sudo systemctl enable x11vnc.service

    echo "x11vnc configurado para iniciar com o sistema!"
else
    echo "Inicialização automática não configurada."
fi
