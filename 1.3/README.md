### Задание 1. Создать Deployment и обеспечить доступ к репликам приложения из другого Pod

1. Создать Deployment приложения, состоящего из двух контейнеров — nginx и multitool. Решить возникшую ошибку.

[nginx-multitool-deployment.yaml](nginx-multitool-deployment.yaml)

2. После запуска увеличить количество реплик работающего приложения до 2.
```
kubectl scale deployment nginx-multitool-app --replicas=2
```
3. Продемонстрировать количество подов до и после масштабирования.

![](2.png)

4. Создать Service, который обеспечит доступ до реплик приложений из п.1.

[nginx-multitool-service.yaml](nginx-multitool-service.yaml)

5. Создать отдельный Pod с приложением multitool и убедиться с помощью `curl`, что из пода есть доступ до приложений из п.1.

[test-multitool-pod.yaml](test-multitool-pod.yaml)

![](3.png)
------

### Задание 2. Создать Deployment и обеспечить старт основного контейнера при выполнении условий

1. Создать Deployment приложения nginx и обеспечить старт контейнера только после того, как будет запущен сервис этого приложения.

[nginx-init-deployment.yaml](nginx-init-deployment.yaml)

2. Убедиться, что nginx не стартует. В качестве Init-контейнера взять busybox.

![](4.png)

3. Создать и запустить Service. Убедиться, что Init запустился.

[nginx-init-service.yaml](nginx-init-service.yaml)

4. Продемонстрировать состояние пода до и после запуска сервиса.
![](4.png)
![](5.png)
