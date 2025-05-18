FROM python:3.10-slim-buster

RUN apt-get update && apt-get install -y \
    ffmpeg \
    libmariadb3 \
    libmagic1 \
    v4l-utils \
    git \
    && rm -rf /var/lib/apt/lists/*

# Installer motioneye depuis git (version stable) pour éviter le problème de module manquant
RUN git clone https://github.com/ccrisan/motioneye.git /motioneye && \
    pip install /motioneye && \
    mkdir -p /etc/motioneye /var/lib/motioneye && \
    cp /motioneye/motioneye/settings.py /etc/motioneye/settings.py

EXPOSE 8765

VOLUME ["/etc/motioneye", "/var/lib/motioneye", "/var/log/motioneye", "/etc/localtime:/etc/localtime:ro"]

CMD ["meyectl", "startserver", "-b", "-c", "/etc/motioneye", "-l", "/var/log/motioneye/motioneye.log", "-w", "/var/lib/motioneye"]