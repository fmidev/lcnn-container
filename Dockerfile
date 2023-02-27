FROM ubuntu:20.04

# Install conda
RUN apt-get -qq update && apt-get -qq -y install curl bzip2 \
    && curl -sSL https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -o /tmp/miniconda.sh \
    && bash /tmp/miniconda.sh -bfp /usr/local \
    && rm -rf /tmp/miniconda.sh \
    && apt-get -qq -y remove curl bzip2 \
    && apt-get -qq -y autoremove \
    && apt-get autoclean \
    && rm -rf /var/lib/apt/lists/* /var/log/dpkg.log

# Install GL libraries
RUN apt-get -qq update && apt-get -qq -y install libgl1-mesa-glx \
    && rm -rf /var/lib/apt/lists/* /var/log/dpkg.log

# Create the environment:
ARG conda_env=lcnn
COPY environment.yml .
ENV PYTHONDONTWRITEBYTECODE=true
RUN conda install -c conda-forge mamba && \
    mamba env create -f environment.yml -n $conda_env && \
    mamba clean --all -f -y

# Allow environment to be activated
RUN echo "conda activate lcnn" >> ~/.profile
ENV PATH /opt/conda/envs/$conda_env/bin:$PATH
ENV CONDA_DEFAULT_ENV $conda_env

WORKDIR .
RUN mkdir input output checkpoints log
# Copy lcnn directory
COPY lcnn /lcnn

WORKDIR /lcnn
ENV CONFIG lcnn-predict-realtime
ENV TIMESTAMP 201908230500

ENTRYPOINT conda run -n lcnn python create_data.py $TIMESTAMP $CONFIG \
    && conda run -n lcnn python create_nowcast.py $TIMESTAMP $CONFIG
