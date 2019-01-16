FROM bk203/docker-kaldi-gstreamer-server:latest

# Get the Dutch models and yaml on the docker and 'install' them
# COPY mod.tar.gz /opt/kaldi-gstreamer-server/
RUN chmod +x /opt/start.sh && \
    chmod +x /opt/stop.sh && \
    cd /opt/kaldi-gstreamer-server && \
    wget -nv http://nlspraak.ewi.utwente.nl/open-source-spraakherkenning-NL/mod.tar.gz && \
    tar -xvzf mod.tar.gz && rm mod.tar.gz 

# The following bit gives you the scripts for offline transcription.
# It requires Java and some other things, so if you don't need it you
# may want to skip this section.

RUN apt-get install -y \
    time \
    sox \
    libsox-fmt-mp3 \
    default-jre

COPY Kaldi_NL.tar.gz /opt/
RUN  cd /opt && tar -xvzf Kaldi_NL.tar.gz && rm Kaldi_NL.tar.gz && \
     cd /opt/Kaldi_NL && ln -s /opt/kaldi/egs/wsj/s5/utils utils && ln -s /opt/kaldi/egs/wsj/s5/steps steps

COPY worker.py master_server.py /opt/kaldi-gstreamer-server/kaldigstserver/