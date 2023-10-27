FROM python:3.12-slim-bookworm
RUN PYTHONUNBUFFERED=1

WORKDIR /src

# poetryをインストール
RUN apt update \
    && pip install --upgrade pip \
    && pip install poetry

COPY pyproject.toml* poetry.lock* ./

# Create the virtualenv inside the project’s root directory.
RUN poetry config virtualenvs.in-project true
# ライブラリをインストール (pyproject.tomlが既にある場合)
RUN if [ -f pyproject.toml ]; then poetry install --no-root; fi

# uvicornのサーバーを立ち上げる
ENTRYPOINT ["poetry", "run", "uvicorn", "api.main:app", "--host", "0.0.0.0", "--reload"]