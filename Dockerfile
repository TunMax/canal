FROM ubuntu:22.04

WORKDIR /app/

RUN apt update && apt install -y curl gpg lsb-release wget

RUN curl -fsSL https://pkg.cloudflareclient.com/pubkey.gpg | gpg --yes --dearmor --output /usr/share/keyrings/cloudflare-warp-archive-keyring.gpg
RUN echo "deb [signed-by=/usr/share/keyrings/cloudflare-warp-archive-keyring.gpg] https://pkg.cloudflareclient.com/ $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/cloudflare-client.list
RUN apt update && apt install -y cloudflare-warp

RUN wget -O gost.gz "https://github.com/ginuerzh/gost/releases/download/v2.11.5/gost-linux-amd64-2.11.5.gz" && gzip -d /app/gost.gz && chmod +x /app/gost

COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

EXPOSE 1080

CMD [ "/bin/bash", "/app/start.sh" ]
