FROM matsengrp/cpp

# Java bit copied from https://github.com/jplock/docker-oracle-java7
RUN sed 's/main$/main universe/' -i /etc/apt/sources.list
RUN apt-get update && apt-get install -y software-properties-common python-software-properties
RUN add-apt-repository ppa:webupd8team/java -y
RUN apt-get update
RUN echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
RUN apt-get install -y \
    oracle-java7-installer \
    libncurses5-dev \
    libroot-bindings-python-dev \
    libroot-graf2d-postscript5.34 \
    libxml2-dev \
    libxslt1-dev \
    python-scipy \
    r-base \
    zlib1g-dev
RUN pip install \
    beautifulsoup4 \
    biopython \
    cython \
    decorator \
    dendropy==3.12.3 \
    lxml \
    networkx \
    pysam \
    pyyaml \
    utils
RUN R --vanilla --slave -e 'install.packages("TreeSim", repos="http://cran.rstudio.com/")'

COPY . /partis
WORKDIR /partis
CMD ./bin/build-and-test.sh

#ENV PATH ${PATH}:/bbx/

ENV CONVERT https://github.com/bronze1man/yaml2json/raw/master/builds/linux_386/yaml2json
# download yaml2json and make it executable
RUN cd /usr/local/bin && wget --quiet ${CONVERT} && chmod 700 yaml2json

ENV JQ http://stedolan.github.io/jq/download/linux64/jq
# download jq and make it executable
RUN cd /usr/local/bin && wget --quiet ${JQ} && chmod 700 jq

# Add Taskfile to /
ADD Taskfile /

# Add assemble script to the directory /usr/local/bin inside the container.
# /usr/local/bin is appended to the $PATH variable what means that every script
# in that directory will be executed in the shell  without providing the path.
ADD assemble.sh /usr/local/bin/ 
RUN cd /usr/local/bin && chmod 700 assemble.sh

#RUN echo $PATH
#RUN ls /usr/local/bin/

ENTRYPOINT ["assemble.sh"]
