# Repository Management Notes

Use GitHub Actions API calls to trigger dependent workflows instead of relying on `gh workflow run`.
This avoids interactive CLI issues in CI environments.

Example: trigger `update-vendors.yml` from another workflow.

```yaml
- name: Trigger update-vendors via API
  run: |
    curl -X POST \
      -H "Accept: application/vnd.github+json" \
      -H "Authorization: Bearer ${{ secrets.GITHUB_TOKEN }}" \
  https://api.github.com/repos/${{ github.repository }}/actions/workflows/update-vendors.yml/dispatches \
      -d '{"ref":"${{ github.ref_name }}"}'
```

After dispatching a workflow you may need to wait for it to finish before
continuing. Query the workflow run ID with `gh run list` and then watch it
with a longer refresh interval to avoid noisy logs:

```bash
RUN_ID=""
until [ -n "$RUN_ID" ]; do
  sleep 5
  RUN_ID=$(gh run list --workflow update-vendors.yml --branch "$GITHUB_REF_NAME" \
    --json databaseId,status -q 'map(select(.status=="queued" or .status=="in_progress"))[0].databaseId')
done
gh run watch "$RUN_ID" --interval 30
gh run view "$RUN_ID" --exit-status
```

This approach keeps CI logs compact by refreshing at most every 30 seconds while
still following the triggered job to completion.

Update existing workflows accordingly so that nested workflows start reliably on GitHub.
