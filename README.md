# databases-homeworks

# HW 1

- Установка MongoDB: Я установил mongodb с помощью docker, используя сайт, указанный в слайдах (https://phoenixnap.com/kb/docker-mongodb). Я примонтировал папку на своем компьютере к папке в докер-контейнере и загрузил туда датасет Fake News.
- Загрузка данных: данные я загружал с помощью утилиты mongoimport внутри докер-контейнера

```
root@9bd9e288a8fc:/# mongoimport -d Fake_News -c fake_news --type csv --file /data/db/test.csv --headerline
2024-04-04T19:48:16.595+0000	connected to: mongodb://localhost/
2024-04-04T19:48:17.038+0000	5200 document(s) imported successfully. 0 document(s) failed to import.
```
