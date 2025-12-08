FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        sudo \
        passwd \
        login \
        adduser \
        && apt-get clean && rm -rf /var/lib/apt/lists/*

COPY user_mgmt.sh /usr/local/bin/user_mgmt.sh
RUN chmod +x /usr/local/bin/user_mgmt.sh

CMD ["/bin/bash"]


