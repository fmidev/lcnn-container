FROM continuumio/miniconda3

ARG conda_env=lcnn

WORKDIR .
RUN mkdir input output log
# Copy lcnn directory
COPY lcnn /lcnn

# To get opencv?
RUN apt-get update && apt-get install -y libgtk2.0-dev libgl1-mesa-glx && \
    rm -rf /var/lib/apt/lists/*

# Create the environment:
COPY environment.yml .
RUN conda install -c conda-forge mamba
RUN mamba env create -f environment.yml -n $conda_env
RUN mamba clean --all -f -y

# Allow environment to be activated
RUN echo "conda activate lcnn" >> ~/.profile
ENV PATH /opt/conda/envs/$conda_env/bin:$PATH
ENV CONDA_DEFAULT_ENV $conda_env

WORKDIR /lcnn
# COPY lcnn/create_nowcast.py .
ENV CONFIG lcnn-predict-realtime
ENV TIMESTAMP 201908230500

ENTRYPOINT conda run -n lcnn python create_nowcast.py $TIMESTAMP $CONFIG
