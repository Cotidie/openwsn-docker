FROM ubuntu:18.10

# enable apt-get repository sources
RUN cp /etc/apt/sources.list /etc/apt/sources.list.bak && \
    sed -i -re 's/([a-z]{2}\.)?archive.ubuntu.com|security.ubuntu.com/old-releases.ubuntu.com/g' \
    /etc/apt/sources.list
RUN apt -y update
RUN apt -y install git

# install python
RUN apt -y install python2 python-dev python-pip

# install zsh and plugins
RUN apt -y install vim wget zsh fonts-font-awesome
RUN sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
COPY zsh/zsh-autosuggestions        ${ZSH_CUSTOM:-/root/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
COPY zsh/zsh-syntax-highlighting    ${ZSH_CUSTOM:-/root/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
RUN sed -i '/plugins=(git)/c\plugins=(git zsh-autosuggestions zsh-syntax-highlighting)' ~/.zshrc

#####################################

# install openwsn
RUN mkdir /root/openwsn
WORKDIR /root/openwsn

RUN apt -y install gcc gcc-arm-none-eabi gcc-msp430 
RUN apt -y install scons net-tools iproute2 iputils-ping usbutils
COPY openwsn-fw         openwsn-fw
COPY openvisualizer     openvisualizer
COPY coap               coap
COPY requirements.txt   requirements.txt
RUN pip install -r requirements.txt

# openvisualizer -> localhost:8080
EXPOSE 8080
CMD ["/bin/zsh"]