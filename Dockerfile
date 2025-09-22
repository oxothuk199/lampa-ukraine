FROM immisterio/lampac:northflank

COPY init.conf /app/init.conf

EXPOSE 9118
CMD ["/app/lampac", "--init", "/app/init.conf"]
