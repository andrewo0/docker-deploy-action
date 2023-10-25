# Docker Deploy Action

## Example

```yaml
- name: Deploy to remote
  uses: andrewo0/docker-deploy-action@master
  with:
    host: ${{ vars.SSH_HOST}}
    user: ${{ secrets.SSH_USERNAME}}
    pass: ${{ secrets.SSH_PASSWORD }}
```

## License

This project is licensed under the MIT license. See the [LICENSE](LICENSE) file for details.