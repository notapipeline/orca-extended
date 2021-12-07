FROM bcgsc/orca

ENV RSTUDIO_VERSION=1.4.1106-amd64

# Rename the linuxbrew user - we don't need this inside the container, we'll let upstream manage that
RUN usermod -l orca linuxbrew && groupmod -n orca linuxbrew

# Install a few missing python packages
RUN pip3 install jupyter macs2 deeptools htseq

# Install R packages
COPY install.R .
RUN R -f install.R

# install Homer and the mm10 genome
RUN mkdir /opt/homer && cd /opt/homer && wget http://homer.ucsd.edu/homer/configureHomer.pl && \
    echo "export PATH=$PATH:/opt/homer/bin" > /etc/profile.d/homer.sh && \
    perl /opt/homer/configureHomer.pl -install && perl /opt/homer/configureHomer.pl -install mm10

# Install R Studio server
# Uses gdebi as per instructions on rstudio - restricts package dependencies
RUN apt update && apt install gdebi-core net-tools bc -y && \
    if [ -d /etc/rstudio ]; then rm -rf /etc/rstudio; fi && \
    wget https://download2.rstudio.org/server/xenial/amd64/rstudio-server-1.4.1106-amd64.deb && \
    gdebi -n ./rstudio-server-${RSTUDIO_VERSION}.deb && \
    echo "rsession-which-r=/home/linuxbrew/.linuxbrew/bin/R" > /etc/rstudio/rserver.conf

# clean down cache
RUN apt-get clean autoclean && \
    apt-get autoremove --yes && \
    rm -rf rstudio-server /var/lib/{apt,dpkg,cache,log}

RUN echo "orca ALL = (ALL) NOPASSWD: ALL" >> /etc/sudoers

RUN echo "orcauser\\norcauser" | passwd orca
# Primary commands - use cd /home allows working directory to be set correctly....
CMD /usr/bin/script -qc "cd /home && sudo rstudio-server start" && /usr/bin/script -qc \
    "sudo -iu orca cd /home && /home/linuxbrew/.linuxbrew/bin/jupyter notebook --NotebookApp.token='orcauser' --NotebookApp.ip='*'"

# Access is as orca user
USER orca
