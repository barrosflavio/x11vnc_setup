#!/bin/bash

# Atualiza os repositórios
sudo zypper refresh

# Instala o x11vnc
sudo zypper install -y x11vnc

# Obtém o nome do usuário atual
read -p "Digite seu nome de usuário: " USERNAME

# Solicita a senha do VNC
sudo x11vnc -storepasswd /home/$USERNAME/.vnc/passwd

# Caminho do arquivo
FILE_NAME="startvnc.sh"

# Define o conteúdo do script
cat << EOF > "$FILE_NAME"
#!/bin/bash

# Iniciar o servidor VNC (x11vnc)
x11vnc -display :0 -noxrecord -noxfixes -noxdamage -forever -bg -rfbauth /home/$USERNAME/.vnc/passwd
EOF

# Move o arquivo para /usr/local/bin
sudo mv startvnc.sh /usr/local/bin/

echo "Arquivo /usr/local/bin/startvnc.sh criado com sucesso!"
