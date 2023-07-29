#!/bin/sh

set -eu

if [ -z "$INPUT_REMOTE_HOST" ]; then
    echo "Input host is required!"
    exit 1
fi

if [ -z "$INPUT_SSH_USERNAME" ]; then
    echo "Input username is required!"
    exit 1
fi

login_with_password() {
  echo "Logging in with password..."
  sshpass -p "$INPUT_SSH_PASSWORD" ssh -o StrictHostKeyChecking=no "$INPUT_SSH_USERNAME"@"$INPUT_REMOTE_HOST" "$@"
}

login_with_key() {
  echo "Logging in with SSH key..."
  mkdir -p ~/.ssh
  echo "$INPUT_SSH_PRIVATE_KEY" > ~/.ssh/id_rsa.pub
  chmod 700 ~/.ssh
  chmod 644 ~/.ssh/id_rsa.pub
  eval "$(ssh-agent -s)"
  ssh-add ~/.ssh/id_rsa.pub
  ssh -o StrictHostKeyChecking=no "$INPUT_SSH_USERNAME"@"$INPUT_REMOTE_HOST" "$@"
}

if [ -n "$INPUT_SSH_PRIVATE_KEY" ]; then
  if [ -z "$INPUT_SSH_PRIVATE_KEY" ]; then
      echo "Input key is required!"
      exit 1
  fi

  if [ -n "$INPUT_COMMANDS" ]; then
    login_with_key "$INPUT_COMMANDS"
  else
    login_with_key
  fi
elif [ -n "$INPUT_SSH_PASSWORD" ]; then

  if [ -z "$INPUT_SSH_PASSWORD" ]; then
      echo "Input password is required!"
      exit 1
  fi

  if [ -n "$INPUT_COMMANDS" ]; then
    login_with_password "$INPUT_COMMANDS"
  else
    login_with_password
  fi
else
  echo "Error: Neither SSH public key nor password is provided. Please provide one of them."
  exit 1
fi