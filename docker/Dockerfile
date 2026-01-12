FROM ubuntu:22.04 AS base

ARG USERNAME=bluerov2
ARG USER_UID=1000
ARG USER_GID=$USER_UID
ARG DEBIAN_FRONTEND=noninteractive

ARG ARDUPILOT_GAZEBO_GIT_COMMIT=4b30a3d8

RUN apt-get update && apt-get upgrade -y

# Install language
RUN apt-get update \
  && apt-get -y --quiet --no-install-recommends install \
    locales \
  && locale-gen en_US.UTF-8 \
  && update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 \
  && rm -rf /var/lib/apt/lists/*
ENV LANG=en_US.UTF-8

# Install timezone
RUN ln -fs /usr/share/zoneinfo/UTC /etc/localtime \
  && apt-get update \
  && apt-get -y --quiet --no-install-recommends install \
     tzdata \
  && dpkg-reconfigure --frontend noninteractive tzdata \
  && rm -rf /var/lib/apt/lists/*

# Install a few handy tools
RUN apt-get update \
  && apt-get -y --quiet --no-install-recommends install \
    bash-completion \
    build-essential \
    git \
    glmark2 \
    gnupg \
    iputils-ping \
    lsb-release \
    mlocate \
    software-properties-common \
    sudo \
    wget \
    vim \
  && rm -rf /var/lib/apt/lists/*

# Install Gazebo Harmonic
RUN wget https://packages.osrfoundation.org/gazebo.gpg -O /usr/share/keyrings/pkgs-osrf-archive-keyring.gpg
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/pkgs-osrf-archive-keyring.gpg] http://packages.osrfoundation.org/gazebo/ubuntu-stable $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/gazebo-stable.list > /dev/null
RUN apt-get update \
  && apt-get -y --quiet --no-install-recommends install \
    gz-harmonic \
  && rm -rf /var/lib/apt/lists/*

# Install NVIDIA software
RUN apt-get update \
 && apt-get -y --quiet --no-install-recommends install \
    libglvnd0 \
    libgl1 \
    libglx0 \
    libegl1 \
    libxext6 \
    libx11-6 \
  && rm -rf /var/lib/apt/lists/*
ENV NVIDIA_VISIBLE_DEVICES=all
ENV NVIDIA_DRIVER_CAPABILITIES=graphics,utility,compute
ENV QT_X11_NO_MITSHM=1

# Install some ardupilot and ardupilot_gazebo prereqs (libgz-sim8-dev is for gz harmonic)
RUN apt-get update \
  && apt-get -y --quiet --no-install-recommends install \
    python3-wxgtk4.0 \
    rapidjson-dev \
    xterm \
    libgz-sim8-dev \
    libopencv-dev \
    libgstreamer1.0-dev \
    libgstreamer-plugins-base1.0-dev \
    gstreamer1.0-plugins-bad \
    gstreamer1.0-libav \
    gstreamer1.0-gl \
  && rm -rf /var/lib/apt/lists/*

# Create a non-root user
# Required for ArduSub install, but generally a good idea
RUN groupadd --gid $USER_GID $USERNAME \
  && useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME \
  && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
  && chmod 0440 /etc/sudoers.d/$USERNAME \
  && echo "\n# Added by bluerov2_gz Dockerfile:" >> /home/$USERNAME/.bashrc \
  && echo "source /usr/share/bash-completion/completions/git" >> /home/$USERNAME/.bashrc

# Switch to our new user
USER $USERNAME
ENV USER=$USERNAME

# Clone ardupilot_gazebo code
WORKDIR /home/$USERNAME
RUN git clone https://github.com/ArduPilot/ardupilot_gazebo.git

# Build for Gazebo Harmonic, define this before building ardupilot_gazebo
ENV GZ_VERSION=harmonic

# Build ardupilot_gazebo
RUN [ "/bin/bash" , "-c" , " \
  cd ardupilot_gazebo \
  && git checkout ${ARDUPILOT_GAZEBO_GIT_COMMIT} \
  && mkdir build \
  && cd build \
  && cmake .. -DCMAKE_BUILD_TYPE=RelWithDebInfo \
  && make -j4" ]

# Copy bluerov2_gz code
WORKDIR /home/$USERNAME/bluerov2_gz
COPY --chown=$USER_UID:$USER_GID . .

# Set up the environment
WORKDIR /home/$USERNAME
RUN echo "export PATH=/home/$USERNAME/.local/bin:\$PATH" >> /home/$USERNAME/.bashrc \
  && echo "export PATH=/home/$USERNAME/.local/lib/python3.10/site-packages:\$PATH" >> /home/$USERNAME/.bashrc \
  && echo "export GZ_SIM_SYSTEM_PLUGIN_PATH=/home/$USERNAME/ardupilot_gazebo/build" >> /home/$USERNAME/.bashrc \
  && echo "export GZ_SIM_RESOURCE_PATH=/home/$USERNAME/bluerov2_gz/models:/home/$USERNAME/bluerov2_gz/worlds" >> /home/$USERNAME/.bashrc

# Required to use the --console option on sim_vehicle.py
# RUN pip3 install matplotlib

# Gazebo discovery messages
EXPOSE 10317/udp
# Gazebo service discovery
EXPOSE 10318/udp

# NOTE: You'll need to make the following ports accessible to the ArduPilot SITL:
# - 9002/udp (Flight Dynamics Model)
#
# The best way to do this is by attaching the Gazebo and SITL containers to the
# same internal Docker network

ENTRYPOINT ["gz"]
CMD ["sim", "-v", "-s", "-r", "bluerov2"]
