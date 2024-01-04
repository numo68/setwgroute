FROM alpine:latest
COPY setwgroute.sh /bin
RUN chmod 0755 /bin/setwgroute.sh
CMD /bin/setwgroute.sh
