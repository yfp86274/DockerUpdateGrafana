# !/bin/bash
oldGrafanaName=832;
newGrafanaName=901;
newVersion=9.0.1;
mkdir Grafana$newGrafanaName

# 導出當前 db 資料
docker cp grafana$oldGrafanaName:/var/lib/grafana/grafana.db Grafana$newGrafanaName/grafana.db
# 導出當前設定檔
docker cp grafana$oldGrafanaName:/etc/grafana/grafana.ini Grafana$newGrafanaName/grafana.ini

# 停止舊容器
docker stop grafana$oldGrafanaName
# 下載與執行新容器
docker run -d -p 127.0.0.1:3000:3000 --name grafana$newGrafanaName grafana/grafana:$newVersion
# 將 db 資料導入新容器
docker cp Grafana$newGrafanaName/grafana.db grafana$newGrafanaName:/var/lib/grafana/
# 將設定檔導入容器
docker cp Grafana$newGrafanaName/grafana.ini grafana$newGrafanaName:/etc/grafana/grafana.ini

# 進入容器更改權限
docker exec -u 0 -it grafana$newGrafanaName /bin/bash -c "chown grafana:root /var/lib/grafana/grafana.db"
# 重啟容器
docker restart grafana$newGrafanaName
