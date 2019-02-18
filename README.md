# One-WSAP

Данный образ предназначен для публикации веб-сервисов 1С (SOAP, HTTP REST, веб-клиента).

Контейнер включает в себя
- Бибилиотеки сервера 1C:Предприятия
- Apache 2.4 в качестве веб-сервера с установленным расширением 1С:Предприятия
- Скрипт конфигурации дескрипторов

Для публикации веб-сервисов 1С используются файлы-дескрипторы с раширением .vrd, контейнер предполагает их размещение в каталоге, подключенном к образу как /descriptors.

# Сборка

Для сборки требуется поместить в директорию packages deb-пакеты server, common и ws соответствующие вашей версии предприятия, например, [отсюда](https://users.v8.1c.ru/distribution/version_files?nick=Platform83&ver=8.3.3.641).

Собираем образ:
```
docker build -t one-wsap ./
```

Также есть возможноcть указать при сборке требуемую версию:
```
docker build -t one-wsap-1790 --build-arg ver=8.3.12-1790 ./
```


# Использование

Запуск контейнера:
```
docker run -p 8080:80 -v /our_vrd:/descriptors one-ws
```
где /our_vrd - директория в которой лежат дескрипторы публикации.

Должно работать:
```
curl http://user:password@localhost:8080/devel/ws/TestWS?wsdl
<?xml version="1.0" encoding="UTF-8"?>
<definitions xmlns="http://schemas.xmlsoap.oыrg/wsdl/"
                xmlns:soap12bind="http://schemas.xmlsoap.org/wsdl/soap12/"
                xmlns:soapbind="http://schemas.xmlsoap.org/wsdl/soap/"
                xmlns:tns="trade"
                xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                xmlns:xsd1="trade"
                name="TestWS"
...
```

Обновить дескрипторы, не перезапуская контейнер:
```
docker exec one-wsap /bin/bash /config/configure.sh
```

# Scaling

Запуск нескольких экземпляров вместе с HAProxy:

```
docker-compose up
docker-compose scale one-wsap=10
```
