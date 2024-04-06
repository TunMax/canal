# canal

一个开箱即用的http代理 ( 基于 Cloudflare WARP )
Setting Up an Out of Box HTTP Proxy with Warp Docker


## 部署

```
docker run -d -p 127.0.0.1:1080:1080 --name canal ghcr.io/tunmax/canal:latest
```

## 测试

```
curl -x http://127.0.0.1:1080 ipinfo.io
```

## License

MIT License