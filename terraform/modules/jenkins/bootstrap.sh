#!/bin/bash
set -euo pipefail

exec > >(tee -a /var/log/jenkins-bootstrap.log) 2>&1

echo "Starting Jenkins bootstrap"

# Base packages
dnf install -y \
  java-21-amazon-corretto \
  fontconfig \
  git \
  docker \
  curl \
  wget \
  unzip \
  tar

# Jenkins LTS repository
curl -fsSL \
  https://pkg.jenkins.io/rpm-stable/jenkins.repo \
  -o /etc/yum.repos.d/jenkins.repo

rpm --import https://pkg.jenkins.io/rpm-stable/jenkins.io-2026.key

dnf install -y jenkins

# Trivy security scanner
curl -fsSL \
  https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh \
  -o /tmp/install-trivy.sh

sh /tmp/install-trivy.sh -b /usr/local/bin v0.76.2

# AWS CLI v2
curl -fsSL https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip \
  -o /tmp/awscliv2.zip
unzip -q /tmp/awscliv2.zip -d /tmp
/tmp/aws/install

# GitHub CLI
dnf install -y 'dnf-command(config-manager)'
dnf config-manager --add-repo https://cli.github.com/packages/rpm/gh-cli.repo
dnf install -y gh

# Enable services
systemctl enable --now docker
usermod -aG docker jenkins

systemctl daemon-reload
systemctl enable --now jenkins

echo "Jenkins bootstrap completed"
