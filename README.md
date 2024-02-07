# TaskManagement
## Добро пожаловать в репозиторий!

![Xcode](https://img.shields.io/badge/Xcode-007ACC?style=for-the-badge&logo=Xcode&logoColor=white)
![Swift](https://img.shields.io/badge/swift-F54A2A?style=for-the-badge&logo=swift&logoColor=white)
![iOS](https://img.shields.io/badge/iOS-000000?style=for-the-badge&logo=ios&logoColor=white)

### Описание
Наше приложение написано на SwiftUI и предназначено для устройств с операционной системой iOS 15 и выше. Оно предоставляет пользователям удобный и интуитивно понятный интерфейс для контроля выполнения задач и создания полезных привычек  

### Управление проектом: [GitHub Projects](https://github.com/users/kupriyanovNik/projects/1/views/1)

### Особенности
- Простой и понятный интерфейс
- Использование SwiftUI
- Поддержка iOS 15 и выше
- Локализация на 2 языка (ru / en)
- Нейронная сеть, помогающая выспаться
- [Лента новостей](https://api.spaceflightnewsapi.net/v3/articles), доступная 30 минут в сутки
- Возможность выбрать тему приложения (🖤 / 💚 / 💜 / 🧡)

### Техническая информация 
- Архитектура: MVVM+S
- Локальное сохранение данных: CoreData
- Уведомления: UserNotifications
- Сетевой слой на async/await
- Конфетти: [SPConfetti](https://github.com/ivanvorobei/SPConfetti)
- Загрузка изображений из сети: [Kingfisher](https://github.com/onevcat/Kingfisher)
- Unit-тестирование: XCTest

### Установка
Для установки приложения необходимо выполнить следующие шаги:

<details><summary>1. Скачивание репозитория на локальный компьютер</summary>
  
  - Открыть терминал
  - Ввести следующие команды:
    + cd путь_к_папке_в_которую_нужно_скопировать
    + git clone https://github.com/kupriyanovNik/TaskManagement
  - Закрыть терминал (опционально)
</details>

<details><summary>2. Открытие проекта</summary>
  
 - Запустить [Xcode](https://developer.apple.com/xcode/)
  - Одновременно нажать cmd + shift + 1
  - Нажать "Open Existing Project..."
  - Найти в файловой системе скопированную папку
  - В папке выделить файл "TaskManagement.xcodeproj"
  - Нажать кнопку "Open" / нажать "return" или "Enter" на клавиатуре (зависит от раскладки)
  - Следующие шаги раздела необходимы **только** для запуска на физическом устройстве
  - Перейти в Project Navigator (одновременно нажать cmd + 1)
  - Нажать на корневой элемент в файловой системе проекта (иконка Xcode, справа от которой будет написано BikeStat)
  - В появившемся окне выбрать вкладку "Signing & Capabilities"
  - Поменять [BundleID](https://developer.apple.com/documentation/appstoreconnectapi/bundle_ids) на собственный
</details>

<details><summary>3. <a href="https://developer.apple.com/documentation/xcode/running-your-app-in-simulator-or-on-a-device">Запуск проекта на физическом устройстве или в симуляторе</a></summary>

  - Одновременно нажать cmd + shift + 2
  - Выбрать симулятор или физическое устройство в качестве Run Destination
  - Закрыть окно выбора Run Destination (красная кнопка слева сверху / одновременно нажать cmd + w)
  - Запустить (в верхнем меню Product -> Run / одновременно нажать cmd + r)
</details>

### Вклад
Если у вас есть предложения по улучшению приложения, пожалуйста, ознакомьтесь с [CONTRIBUTING.md](CONTRIBUTING.md) для получения дополнительной информации о том, как внести свой вклад.

### Лицензия
Проект лицензирован в соответствии с условиями лицензии [LICENSE.md](https://github.com/kupriyanovNik/TaskManagement/blob/main/LICENSE).

### Контакты
Если у вас есть вопросы или предложения, пожалуйста, свяжитесь с нами:
- Почта [cucuprianov@gmail.com](mailto:cucuprianov@gmail.com)
- Telegram @idontknowktoya
- Добавить [issue](https://github.com/kupriyanovNik/TaskManagement/issues/new)
- [GitHub Discussions](https://github.com/kupriyanovNik/TaskManagement/discussions/new?category=general)
