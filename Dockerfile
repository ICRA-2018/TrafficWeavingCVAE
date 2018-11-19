FROM roslab/roslab:kinetic

USER root


RUN apt-get update \
 && apt-get install -yq --no-install-recommends \
    software-properties-common \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*
RUN apt-add-repository ppa:chronitis/jupyter
RUN apt-get update \
 && apt-get install -yq --no-install-recommends \
    ijulia \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*
RUN pip install tensorflow==1.3 pandas numpy matplotlib sympy h5py 

RUN mkdir -p ${HOME}/catkin_ws/src/traffic-weaving-cvae
COPY . ${HOME}/catkin_ws/src/traffic-weaving-cvae/.
RUN cd ${HOME}/catkin_ws \
 && mv src/traffic-weaving-cvae/README.ipynb .. \
 && apt-get update \
 && /bin/bash -c "source /opt/ros/kinetic/setup.bash && rosdep update && rosdep install --as-root apt:false --from-paths src --ignore-src -r -y" \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* \
 && /bin/bash -c "source /opt/ros/kinetic/setup.bash && catkin build"

RUN echo "source ~/catkin_ws/devel/setup.bash" >> ${HOME}/.bashrc

RUN chown -R ${NB_UID} ${HOME}

USER ${NB_USER}
WORKDIR ${HOME}
