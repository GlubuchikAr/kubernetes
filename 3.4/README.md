# Домашнее задание к занятию «Обновление приложений»

### Цель задания

Выбрать и настроить стратегию обновления приложения.

### Чеклист готовности к домашнему заданию

1. Кластер K8s.

### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. [Документация Updating a Deployment](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#updating-a-deployment).
2. [Статья про стратегии обновлений](https://habr.com/ru/companies/flant/articles/471620/).

-----

### Задание 1. Выбрать стратегию обновления приложения и описать ваш выбор

1. Имеется приложение, состоящее из нескольких реплик, которое требуется обновить.
2. Ресурсы, выделенные для приложения, ограничены, и нет возможности их увеличить.
3. Запас по ресурсам в менее загруженный момент времени составляет 20%.
4. Обновление мажорное, новые версии приложения не умеют работать со старыми.
5. Вам нужно объяснить свой выбор стратегии обновления приложения.

#### Ответ: 
Стратегия Recreate. 
- Нет ресурсов для того чтобы поднимать новые поды или для того чтобы сделать копию приложения.
- Так как новые версии не умеют работать со старыми могут быть проблемы если будут одновременно работать и старые и новые поды

### Задание 2. Обновить приложение

1. Создать deployment приложения с контейнерами nginx и multitool. Версию nginx взять 1.19. Количество реплик — 5.

[nginx-multitool-deployment.yaml](nginx-multitool-deployment.yaml)

```
glubuchik@glubuchik-X15-AT-22:~/обучение/Netology/kubernetes/3.4$ kubectl apply -f nginx-multitool-deployment.yaml 
deployment.apps/nginx-multitool-app created
service/nginx-init-service created

glubuchik@glubuchik-X15-AT-22:~/обучение/Netology/kubernetes/3.4$ kubectl get pods -n default -o wide
NAME                                   READY   STATUS    RESTARTS   AGE   IP               NODE   NOMINATED NODE   READINESS GATES
nginx-multitool-app-657c4fd6df-9clzh   2/2     Running   0          54s   10.244.81.194    vm-5   <none>           <none>
nginx-multitool-app-657c4fd6df-gd4gx   2/2     Running   0          54s   10.244.227.1     vm-4   <none>           <none>
nginx-multitool-app-657c4fd6df-lr8f7   2/2     Running   0          54s   10.244.13.193    vm-3   <none>           <none>
nginx-multitool-app-657c4fd6df-s66cd   2/2     Running   0          54s   10.244.81.193    vm-5   <none>           <none>
nginx-multitool-app-657c4fd6df-zqlnp   2/2     Running   0          54s   10.244.217.129   vm-2   <none>           <none>
```
2. Обновить версию nginx в приложении до версии 1.20, сократив время обновления до минимума. Приложение должно быть доступно.

изменяем 
      maxSurge: 5
      maxUnavailable: 0
Для максимально быстрого обновления без потери доступности
И версию nginx
```
glubuchik@glubuchik-X15-AT-22:~/обучение/Netology/kubernetes/3.4$ kubectl apply -f nginx-multitool-deployment.yaml 
deployment.apps/nginx-multitool-app configured
service/nginx-init-service unchanged

glubuchik@glubuchik-X15-AT-22:~/обучение/Netology/kubernetes/3.4$ kubectl get pods -n default -o wide
NAME                                   READY   STATUS              RESTARTS   AGE     IP               NODE   NOMINATED NODE   READINESS GATES
nginx-multitool-app-657c4fd6df-9clzh   2/2     Running             0          5m19s   10.244.81.194    vm-5   <none>           <none>
nginx-multitool-app-657c4fd6df-gd4gx   2/2     Running             0          5m19s   10.244.227.1     vm-4   <none>           <none>
nginx-multitool-app-657c4fd6df-lr8f7   2/2     Running             0          5m19s   10.244.13.193    vm-3   <none>           <none>
nginx-multitool-app-657c4fd6df-s66cd   2/2     Running             0          5m19s   10.244.81.193    vm-5   <none>           <none>
nginx-multitool-app-657c4fd6df-zqlnp   2/2     Running             0          5m19s   10.244.217.129   vm-2   <none>           <none>
nginx-multitool-app-85d549b477-k626t   0/2     ContainerCreating   0          4s      <none>           vm-2   <none>           <none>
nginx-multitool-app-85d549b477-kdmzs   0/2     ContainerCreating   0          4s      <none>           vm-3   <none>           <none>
nginx-multitool-app-85d549b477-mqn9q   0/2     ContainerCreating   0          4s      <none>           vm-5   <none>           <none>
nginx-multitool-app-85d549b477-prplt   0/2     ContainerCreating   0          4s      <none>           vm-4   <none>           <none>
nginx-multitool-app-85d549b477-z6r7t   0/2     ContainerCreating   0          4s      <none>           vm-2   <none>           <none>

kubectl get pods -n default -o wide

NAME                                   READY   STATUS    RESTARTS   AGE   IP               NODE   NOMINATED NODE   READINESS GATES
nginx-multitool-app-85d549b477-k626t   2/2     Running   0          42s   10.244.217.131   vm-2   <none>           <none>
nginx-multitool-app-85d549b477-kdmzs   2/2     Running   0          42s   10.244.13.194    vm-3   <none>           <none>
nginx-multitool-app-85d549b477-mqn9q   2/2     Running   0          42s   10.244.81.195    vm-5   <none>           <none>
nginx-multitool-app-85d549b477-prplt   2/2     Running   0          42s   10.244.227.2     vm-4   <none>           <none>
nginx-multitool-app-85d549b477-z6r7t   2/2     Running   0          42s   10.244.217.130   vm-2   <none>           <none>
```

3. Попытаться обновить nginx до версии 1.28, приложение должно оставаться доступным.

Меняем версию, применяем `kubectl apply -f nginx-multitool-deployment.yaml` и все удачно стартует, как и в прошлый раз. Так как задание для домашней работы менялось последний раз 2 года назад, когда еще не было версии 1.28, все должно было упасть. Наверное стоит поправить задачу.
Меняю версию на 1.30 (сейчас последняя 1.29.1)
Получаем ошибки:
```
glubuchik@glubuchik-X15-AT-22:~/обучение/Netology/kubernetes/3.4$ kubectl get pods -n default -o wide
NAME                                   READY   STATUS             RESTARTS   AGE     IP               NODE   NOMINATED NODE   READINESS GATES
nginx-multitool-app-68b96cfc65-4r87r   2/2     Running            0          5m53s   10.244.227.3     vm-4   <none>           <none>
nginx-multitool-app-68b96cfc65-c9dk6   2/2     Running            0          5m53s   10.244.81.197    vm-5   <none>           <none>
nginx-multitool-app-68b96cfc65-gzp7h   2/2     Running            0          5m53s   10.244.81.196    vm-5   <none>           <none>
nginx-multitool-app-68b96cfc65-v5z5h   2/2     Running            0          5m53s   10.244.13.195    vm-3   <none>           <none>
nginx-multitool-app-68b96cfc65-x565c   2/2     Running            0          5m53s   10.244.217.132   vm-2   <none>           <none>
nginx-multitool-app-6cc885c978-5m4dv   1/2     ImagePullBackOff   0          19s     10.244.81.198    vm-5   <none>           <none>
nginx-multitool-app-6cc885c978-782ws   1/2     ImagePullBackOff   0          19s     10.244.217.133   vm-2   <none>           <none>
nginx-multitool-app-6cc885c978-gwfgd   1/2     ImagePullBackOff   0          19s     10.244.227.4     vm-4   <none>           <none>
nginx-multitool-app-6cc885c978-kgwdt   1/2     ImagePullBackOff   0          19s     10.244.13.196    vm-3   <none>           <none>
nginx-multitool-app-6cc885c978-nr7bj   1/2     ImagePullBackOff   0          19s     10.244.13.197    vm-3   <none>           <none>
```

4. Откатиться после неудачного обновления.
```
glubuchik@glubuchik-X15-AT-22:~/обучение/Netology/kubernetes/3.4$ kubectl  rollout undo deployment nginx-multitool-app 
deployment.apps/nginx-multitool-app rolled back

glubuchik@glubuchik-X15-AT-22:~/обучение/Netology/kubernetes/3.4$ kubectl get pods -n default -o wide
NAME                                   READY   STATUS    RESTARTS   AGE     IP               NODE   NOMINATED NODE   READINESS GATES
nginx-multitool-app-68b96cfc65-4r87r   2/2     Running   0          7m47s   10.244.227.3     vm-4   <none>           <none>
nginx-multitool-app-68b96cfc65-c9dk6   2/2     Running   0          7m47s   10.244.81.197    vm-5   <none>           <none>
nginx-multitool-app-68b96cfc65-gzp7h   2/2     Running   0          7m47s   10.244.81.196    vm-5   <none>           <none>
nginx-multitool-app-68b96cfc65-v5z5h   2/2     Running   0          7m47s   10.244.13.195    vm-3   <none>           <none>
nginx-multitool-app-68b96cfc65-x565c   2/2     Running   0          7m47s   10.244.217.132   vm-2   <none>           <none>
```

## Дополнительные задания — со звёздочкой*

Задания дополнительные, необязательные к выполнению, они не повлияют на получение зачёта по домашнему заданию. **Но мы настоятельно рекомендуем вам выполнять все задания со звёздочкой.** Это поможет лучше разобраться в материале.   

### Задание 3*. Создать Canary deployment

1. Создать два deployment'а приложения nginx.
2. При помощи разных ConfigMap сделать две версии приложения — веб-страницы.
3. С помощью ingress создать канареечный деплоймент, чтобы можно было часть трафика перебросить на разные версии приложения.

### Правила приёма работы

1. Домашняя работа оформляется в своем Git-репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода необходимых команд, а также скриншоты результатов.
3. Репозиторий должен содержать тексты манифестов или ссылки на них в файле README.md.
