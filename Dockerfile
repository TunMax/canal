FROM ubuntu:22.04

WORKDIR /app/

RUN apt update && apt install -y vim curl gpg lsb-release wget
RUN printf "set ts=4\nsyntax on\nset ruler\nset expandtab\nset autoindent\nset mouse-=a" > ~/.vimrc

RUN curl -fsSL https://pkg.cloudflareclient.com/pubkey.gpg | gpg --yes --dearmor --output /usr/share/keyrings/cloudflare-warp-archive-keyring.gpg
RUN echo "deb [signed-by=/usr/share/keyrings/cloudflare-warp-archive-keyring.gpg] https://pkg.cloudflareclient.com/ $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/cloudflare-client.list
RUN apt update && apt install -y cloudflare-warp

RUN wget -O gost.gz "https://github.com/ginuerzh/gost/releases/download/v2.11.5/gost-linux-amd64-2.11.5.gz" && gzip -d /app/gost.gz && chmod +x /app/gost

EXPOSE 1080

RUN printf "nohup /usr/bin/warp-svc >> /app/warp.log &\nsleep 5\nnohup /app/gost -L http://:1080 -F socks5://127.0.0.1:40000 >> /app/gost.log &\nwarp-cli --accept-tos register\nwarp-cli --accept-tos mode proxy\nwarp-cli --accept-tos connect\nexec tail -f /app/warp.log" > /app/init.sh && chmod +x /app/init.sh
CMD [ "/bin/bash", "/app/init.sh" ]
