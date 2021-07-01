# NLP100ノックをするためのdocker-compose

workspaceがjupyter上のカレントディレクトリとなる

## 起動方法

```shell
$ docker compose up
# バックグランドで起動するなら
$ docker compose up -d
```

起動後、`localhost:8900`でjupyter labにアクセス可能

## 停止方法

```shell
docker compose stop
```
