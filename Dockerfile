FROM drupal:9.2.8



COPY init_container.sh /bin/
RUN chmod 777 /bin/init_container.sh

RUN apt update && apt install  openssh-server sudo -y

RUN echo "root:Docker!" | chpasswd
# Copy the sshd_config file to the /etc/ssh/ directory
COPY sshd_config /etc/ssh/

# Copy and configure the ssh_setup file
RUN mkdir -p /tmp
COPY ssh_setup.sh /tmp
RUN chmod +x /tmp/ssh_setup.sh \
    && (sleep 1;/tmp/ssh_setup.sh 2>&1 > /dev/null)
# Open port 2222 for SSH access
EXPOSE 80 2222
#CMD service ssh start && while true; do sleep 3000; done
#CMD ["/usr/sbin/sshd", "-D", "-o", "ListenAddress=0.0.0.0"]
#ENTRYPOINT service ssh restart && bash
#CMD service ssh start && tail -F /var/log/ssh/error.log
#CMD /usr/sbin/sshd
ENTRYPOINT ["/bin/init_container.sh"]
