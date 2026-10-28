FROM python:3.12-slim

# Создаем непривилегированного пользователя
RUN groupadd -r appgroup && useradd -r -g appgroup -s /usr/sbin/nologin appuser

WORKDIR /app

# Кэширование слоя зависимостей
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Копируем остальной код проекта
COPY . .

# Назначаем права на каталог
RUN chown -R appuser:appgroup /app

USER appuser

EXPOSE 8003

# Exec-форма для корректной передачи Unix-сигналов (SIGTERM)
CMD ["gunicorn", "-b", "0.0.0.0:8003", "app:app"]
