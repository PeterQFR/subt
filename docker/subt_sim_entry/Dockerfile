# Ubuntu 18.04 with nvidia-docker2 beta opengl support
FROM subt_models:latest

# Tools I find useful during development
RUN sudo apt-get update -qq \
 && sudo apt-get install --no-install-recommends -y -qq \
        build-essential \
        bwm-ng \
        atop \
        cmake \
        cppcheck \
        gdb \
        git \
        gnutls-bin \
        libbluetooth-dev \
        libccd-dev \
        libcwiid-dev \
        libfcl-dev \
        libgoogle-glog-dev \
        libspnav-dev \
        libusb-dev \
        lsb-release \
        python3-dbg \
        python3-empy \
        python3-numpy \
        python3-setuptools \
        python3-pip \
        python3-venv \
        ruby2.7 \
        ruby2.7-dev \
        software-properties-common \
        vim \
        net-tools \
        iputils-ping \
        libyaml-cpp-dev \
        xvfb \
        g++-8 \
 && sudo apt-get clean -qq

RUN sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-8 800 --slave /usr/bin/g++ g++ /usr/bin/g++-8 --slave /usr/bin/gcov gcov /usr/bin/gcov-8

RUN gcc --version

# Install AWS CLI. This is needed by cloudsim to capture ROS logs.
RUN pip3 install --upgrade awscli=="1.16.220"
VOLUME /root/.aws

ARG DEBIAN_FRONTEND=noninteractive
RUN sudo apt-get update -qq && sudo DEBIAN_FRONTEND=noninteractive apt-get install keyboard-configuration -y
# install ROS and required packages
RUN sudo /bin/sh -c 'echo "deb [trusted=yes] http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list' \
 && sudo apt-get update -qq \
<<<<<<< HEAD
 && sudo DEBIAN_FRONTEND=noninteractive apt-get install -y -qq  \
    python3-catkin-tools \
    python3-rosdep \
    python3-rosinstall \
    ros-noetic-desktop \
    ros-noetic-joy \
    ros-noetic-pointcloud-to-laserscan \
    ros-noetic-robot-localization \
    ros-noetic-spacenav-node \
    ros-noetic-tf2-sensor-msgs \
    ros-noetic-twist-mux \
    ros-noetic-rviz-imu-plugin \
#    ros-noetic-rotors-control \
    ros-noetic-theora-image-transport 
RUN DEBIAN_FRONTEND=noninteractive sudo rosdep init \
=======
 && sudo apt-get install -y -qq \
    libpcl-dev \
    libpcl-conversions-dev \
    python-catkin-tools \
    python-rosdep \
    python-rosinstall \
    ros-melodic-desktop \
    ros-melodic-joystick-drivers \
    ros-melodic-pcl-ros \
    ros-melodic-pointcloud-to-laserscan \
    ros-melodic-robot-localization \
    ros-melodic-spacenav-node \
    ros-melodic-tf2-sensor-msgs \
    ros-melodic-twist-mux \
    ros-melodic-rviz-imu-plugin \
    ros-melodic-rotors-control \
    ros-melodic-theora-image-transport \
 && sudo rosdep init \
>>>>>>> master
 && sudo apt-get clean

# sdformat8-sdf conflicts with sdformat-sdf installed from gazebo
# so we need to workaround this using a force overwrite
# Do this before installing ign-gazebo
RUN sudo /bin/sh -c 'echo "deb [trusted=yes] http://packages.osrfoundation.org/gazebo/ubuntu-stable `lsb_release -cs` main" > /etc/apt/sources.list.d/gazebo-stable.list' \
 && sudo /bin/sh -c 'wget http://packages.osrfoundation.org/gazebo.key -O - | apt-key add -' \
 && sudo /bin/sh -c 'apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654'

# install ign-dome
RUN sudo apt-get update \
&&  DEBIAN_FRONTEND=noninteractive sudo apt-get install -y -qq \
    ignition-dome \
 && sudo apt-get clean

# install the ros to ign bridge
RUN sudo apt-get update \
 && DEBIAN_FRONTEND=noninteractive sudo apt-get install -y -qq \
    ros-noetic-ros-ign \
    ros-noetic-perception-pcl \
 && sudo apt-get clean -qq

# Make a couple folders for organizing docker volumes
RUN mkdir ~/workspaces ~/other

# When running a container start in the developer's home folder
WORKDIR /home/$USERNAME

# Install subt sim
RUN mkdir -p subt_ws/src/subt 
# && git config --global http.postBuffer 1048576000 \
# && git clone https://github.com/osrf/subt
COPY subt_sim_entry/src subt_ws/src/subt/
# Install dependencies
RUN . /opt/ros/noetic/setup.sh \
 && rosdep update \
 && sudo apt-get update \
 && DEBIAN_FRONTEND=noninteractive rosdep install -y --from-paths . --ignore-src -r \
    --skip-keys=ignition-transport9 \
    --skip-keys=ignition-math6 \
    --skip-keys=ignition-msgs6 \
    --skip-keys=ignition-plugin1 \
    --skip-keys=ignition-common3 \
    --skip-keys=ignition-launch2 \
 && sudo apt-get clean -qq


RUN mkdir -p /home/$USERNAME/other_ws/src 
WORKDIR /home/$USERNAME/other_ws
RUN cd src && git clone https://github.com/ethz-asl/rotors_simulator.git \
        && git clone https://github.com/ethz-asl/mav_comm.git \
        && cd rotors_simulator && rm -rf \
        rotors_comm \
        rotors_gazebo \
        rotors_simulator \
        rotors_description \
        rotors_evaluation \
        rotors_gazebo_plugins \
        rotors_hil_interface \
        rotors_joy_interface \
        rqt_rotors
RUN /bin/bash -c 'source /opt/ros/noetic/setup.bash && catkin_make clean && catkin_make -DCMAKE_BUILD_TYPE=Release install'
WORKDIR /home/$USERNAME/subt_ws
RUN /bin/bash -c 'source /home/$USERNAME/other_ws/install/setup.bash && catkin_make clean && catkin_make  -DCMAKE_BUILD_TYPE=Release install'
RUN /bin/sh -c 'echo ". /opt/ros/noetic/setup.bash" >> ~/.bashrc' \
 && /bin/sh -c 'echo ". ~/subt_ws/install/setup.sh" >> ~/.bashrc'

# Create a directory required by cloudsim
RUN mkdir -p /tmp/ign

# Copy entry point script, and set the entrypoint
COPY subt_sim_entry/run_sim.bash ./
ENTRYPOINT ["./run_sim.bash"]

# Customize your image here.
# E.g.:
# ENV PATH="/opt/sublime_text:$PATH"
