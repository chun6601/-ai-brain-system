# ═══════════════════════════════════════════════════════════════════
#  AI Brain System - Dockerfile
#  支援離線優先：內建規則引擎，不依賴外部 API 也可運作
# ═══════════════════════════════════════════════════════════════════
FROM python:3.12-slim

LABEL maintainer="AI Brain Competition Team"
LABEL description="AI Agent Multi-Company Brain System v2.0"

WORKDIR /app

# 安裝系統依賴
RUN apt-get update && apt-get install -y \
    curl sqlite3 \
    && rm -rf /var/lib/apt/lists/*

# 安裝 Python 依賴
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 複製源碼
COPY . .

# 建立必要目錄
RUN mkdir -p /app/audit /app/knowledge /app/logs

# 設定環境變數
ENV PYTHONPATH=/app
ENV DB_PATH=/app/audit/brain.db
ENV PORT=5000
ENV OFFLINE_MODE=false

# 健康檢查
HEALTHCHECK --interval=30s --timeout=10s --retries=3 \
    CMD curl -f http://localhost:5000/health || exit 1

EXPOSE 5000

CMD ["python", "api/server.py"]
