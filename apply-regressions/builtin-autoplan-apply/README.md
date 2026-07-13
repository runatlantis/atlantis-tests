# Built-in Autoplan to Apply

Regression fixture for [runatlantis/atlantis#6641](https://github.com/runatlantis/atlantis/issues/6641),
introduced in Atlantis v0.46.0.

The project uses Atlantis's built-in `init`, `plan`, and `apply` lifecycle. The upstream
runner waits for autoplan success and immediately posts:

```text
atlantis apply -p builtin-autoplan-apply
```

No manual plan command occurs between autoplan and apply. A successful apply proves the
autoplan `PullStatus` was persisted before success became externally visible.
