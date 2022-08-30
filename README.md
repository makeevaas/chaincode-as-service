#Тестовый стенд для работы с внешними чейнкод-серверами
#Директория chaincode-external - программа чейнкода
#Директория fabric-samples - настройки для развертывания сети hyperledger fabric

1. Собрать образ с чейнкодом:
   - cd chaincode-external
   - ./build.sh

2. Зпустить сеть hyperledger fabric и чейнкоды в Podman
   - cd fabric-samples
   - ./podman-network.sh
   - ./run.sh
   # далее скопировать все cc-package-id и вызвать ./set.sh с передачей всех cc-package-id ...
   - ./set.sh cc-package-id
    
3. Тестирование запросов
   - ./query.sh cc-name (указать имя чейнкода)
    
4. Погасить стек
   - cd fabric-samples
   - ./podman-reset.sh 