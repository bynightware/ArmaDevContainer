FROM mcr.microsoft.com/devcontainers/cpp:1-ubuntu24.04

ARG REINSTALL_CMAKE_VERSION_FROM_SOURCE="3.22.2"

# Install Wine for running the Windows-based Arma tools in the Linux container.
RUN dpkg --add-architecture i386 \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        curl \
        wine \
        wine32 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install HEMTT for the devcontainer user during image build rather than on
# every container creation.
RUN su -s /bin/bash vscode -c 'export HOME=/home/vscode; curl -sSf https://hemtt.dev/install.sh | sh'
ENV PATH="/home/vscode/.local/bin:${PATH}"

# Optionally install the cmake for vcpkg
COPY .docker/scripts/reinstall-cmake.sh /tmp/install/

RUN if [ "${REINSTALL_CMAKE_VERSION_FROM_SOURCE}" != "none" ]; then \
        chmod +x /tmp/install/reinstall-cmake.sh && /tmp/install/reinstall-cmake.sh ${REINSTALL_CMAKE_VERSION_FROM_SOURCE}; \
    fi \
    && rm -f /tmp/install/reinstall-cmake.sh

# [Optional] Uncomment this section to install additional vcpkg ports.
# RUN su vscode -c "${VCPKG_ROOT}/vcpkg install <your-port-name-here>"

# [Optional] Uncomment this section to install additional packages.
# RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
#     && apt-get -y install --no-install-recommends <your-package-list-here>
