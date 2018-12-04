FROM busybox
RUN date | tee timestamp1
# This is the slow build step that you'd want cached
RUN sleep 60
RUN date | tee timestamp2
