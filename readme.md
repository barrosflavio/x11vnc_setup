 # 💡 Sobre este Repositório:
 O objetivo deste repositório é ceder acesso gráfico a computadores linux usando o protocolo VNC junto a uma VPN simples como o TAILSCALE. Eu usava bastante isso quando eu trabalhava no Novo Atacarejo, onde o servidor onde eu rodava meus serviços e containers também era onde eu codava. Então ela tinha uma interface KDE rodando sobre Xorg. Que é na minha opnião o melhor cenário para X11vnc.

 Inicalmente tinha feito um .sh apenas para OpenSuse pois era oque eu usava na época. Porém como este projeto pode ser de utilidade geral e estou organizando meus repositórios. Criei um install.sh que detecta automaticamente que distribuição linux você está utilizando e executa os procedimentos necessários.

 ## Instalação:
Bem, para instalar não poderia ser mais simples, se você usa CURL copie a linha de comando abaixo, se usa WGET copie a que está abaixo dela, cole no terminal e seja feliz. 🚀

install.sh funciona para:
- OpenSuse
- Debian/Ubuntu
- Arch/Manjaro
- Fedora

### Usando CURL
``` sh
bash -c "$(curl -sSL https://raw.githubusercontent.com/barrosflavio/x11vnc_setup/main/install.sh)"
```

### Usando WGET
``` sh
bash -c "$(wget -qO- https://raw.githubusercontent.com/barrosflavio/x11vnc_setup/main/install.sh)"
```
