# Учебный проект Q&A онлайн школы Thinknetica

# Цель проекта
Создать ресурс, где пользователи могут задавать вопросы и получать ответы на вопросы.

# Аутентификация
Протокол OAuth, пользователи могут зарегистрироваться или войти через соцсети.

# Авторизация
Авторизация пользователей реализована через гем cancancan

# Рейтинг и рассылка уведомлений
Зарегистрированный пользователь может проголосовать за чужой понравившийся вопрос.
Автор вопроса может выбрать лучший ответ.
Пользователь может подписаться на рассылку почтовых уведомлений о новых ответах на вопрос.

# Автоматическое обновление ответов
Ответы на вопросы обновляются автоматически, через websocket. Реализовано через ActionCable.

# Реализация API
API реализован через гем doorkeeper.

# Полнотекстовый поиск
Реализован полнотекстовый поиск на Sphinx

# Деплой и мониторинг
Финальный деплой проекта через Capistrano на тестовый виртуальный сервер.
Мониторинг работающих сервисов в monit.
