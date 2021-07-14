FROM python:3.9.5-slim

# ライブラリのインストール
RUN apt update 
RUN apt install -y zip unzip wget build-essential tar curl

# mecab関連
RUN apt install -y mecab libmecab-dev mecab-ipadic-utf8

# cabocha用
# Install CRF++
RUN wget -O /tmp/CRF++-0.58.tar.gz "https://drive.google.com/uc?export=download&id=0B4y35FiV1wh7QVR6VXJ5dWExSTQ" \
  && cd /tmp \
  && tar zxf CRF++-0.58.tar.gz \
  && cd CRF++-0.58 \
  && ./configure \
  && make \
  && make install \
  && cd / \
  && rm /tmp/CRF++-0.58.tar.gz \
  && rm -rf /tmp/CRF++-0.58 \
  && ldconfig

# cabochaのインストール
RUN cd /tmp \
  && curl -c cabocha-0.69.tar.bz2 -s -L "https://drive.google.com/uc?export=download&id=0B4y35FiV1wh7SDd1Q1dUQkZQaUU" \
    | grep confirm | sed -e "s/^.*confirm=\(.*\)&amp;id=.*$/\1/" \
    | xargs -I{} curl -b  cabocha-0.69.tar.bz2 -L -o cabocha-0.69.tar.bz2 \
      "https://drive.google.com/uc?confirm={}&export=download&id=0B4y35FiV1wh7SDd1Q1dUQkZQaUU" \
  && tar jxf cabocha-0.69.tar.bz2 \
  && cd cabocha-0.69 \
  && export CPPFLAGS=-I/usr/local/include \
  && ./configure --with-mecab-config=`which mecab-config` --with-charset=utf8 \
  && make \
  && make install \
  && cd python \
  && python setup.py build \
  && python setup.py install \
  && cd / \
  && rm /tmp/cabocha-0.69.tar.bz2 \
  && rm -rf /tmp/cabocha-0.69 \
  && ldconfig

# 日本語用
RUN apt-get update && apt-get install -y fonts-ipafont

# 変数定義
ARG workspace_dir=/workspace/

RUN mkdir $workspace_dir
ADD workspace/requirements.txt $workspace_dir
WORKDIR $workspace_dir

# Pythonライブラリのインストール
RUN pip install --upgrade pip
RUN pip install -r requirements.txt
RUN pip install bhtsne==0.1.9
RUN pip install torch==1.9.0+cpu torchvision==0.10.0+cpu torchaudio==0.9.0 -f https://download.pytorch.org/whl/torch_stable.html
