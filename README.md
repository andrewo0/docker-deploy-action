# Docker Deploy Action

## Example

Authenticate using private key:

```yaml
- name: Deploy to remote with private key
  uses: sagebind/docker-swarm-deploy-action@v2
  with:
    remote_host: ssh://user@myswarm.com
    ssh_username: ${{ secrets.DOCKER_SSH_PRIVATE_KEY }}
    ssh_private_key: ${{ secrets.DOCKER_SSH_PRIVATE_KEY }}
```

Authenticate using username and password:

```yaml
- name: Deploy to remote with username and password
  uses: sagebind/docker-swarm-deploy-action@v2
  with:
    remote_host: ssh://user@myswarm.com
    ssh_username: ${{ secrets.DOCKER_SSH_PRIVATE_KEY }}
    ssh_private_key: ${{ secrets.DOCKER_SSH_PRIVATE_KEY }}
```

## License

This project is licensed under the MIT license. See the [LICENSE](LICENSE) file for details.