# Repository Management Notes

Use GitHub Actions API calls to trigger dependent workflows instead of relying on `gh workflow run`.
This avoids interactive CLI issues in CI environments.

Example: trigger `clone-vendors.yml` from another workflow.

```yaml
- name: Trigger clone-vendors via API
  run: |
    curl -X POST \
      -H "Accept: application/vnd.github+json" \
      -H "Authorization: Bearer ${{ secrets.GITHUB_TOKEN }}" \
      https://api.github.com/repos/${{ github.repository }}/actions/workflows/clone-vendors.yml/dispatches \
      -d '{"ref":"${{ github.ref_name }}"}'
```

Update existing workflows accordingly so that nested workflows start reliably on GitHub.
