FROM ubuntu

# Install dependencies
RUN dpkg --add-architecture i386 \
 && apt-get update \
 && apt-get install -yq apt-utils file build-essential git gnupg2 sudo bash curl zip software-properties-common libncurses5:i386 libstdc++6:i386 zlib1g:i386 \
 && apt-get install -yq locales \
 && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists /var/cache/apt

# Set up environment variables
ENV ANDROID_HOME="/home/user/android-sdk-linux" \
  SDK_URL="https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip"
ENV DEBIAN_FRONTEND noninteractive
ENV LANG="en_US.UTF-8" \
  LC_ALL="en_US.UTF-8"

# Install jdk
RUN add-apt-repository ppa:openjdk-r/ppa \
  && yes | apt-get install openjdk-8-jdk

# Install ruby
RUN yes | apt-get install ruby-full

# Install nodejs
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash \
  && apt-get install -yq nodejs

# Create a non-root user
RUN useradd -m user
RUN chown -R user:user /var/lib/gems /usr/local/bin
USER user
WORKDIR /home/user

# Install gems
RUN gem install bundler \
  && gem install fastlane

# Download Android SDK
RUN mkdir "$ANDROID_HOME" .android \
 && cd "$ANDROID_HOME" \
 && curl -o android_sdk.zip $SDK_URL \
 && unzip android_sdk.zip \
 && rm android_sdk.zip \
 && yes | $ANDROID_HOME/tools/bin/sdkmanager --licenses