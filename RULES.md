# Development Rules

## 1. Always Update CHANGES.md

**Before any commit, you MUST update `phase1/CHANGES.md`** (or the relevant phase folder).

Include:
- Date of change
- Files modified/added/removed
- Reason for change
- Any breaking changes

Example:
```markdown
### 2026-02-24: Description
- Changed: file.lua - modified function X
- Added: new.lua - new feature
- Removed: old.lua - not needed
```

## 2. Phase Structure

Each phase (phase1/phase2/phase3) must have:
- `plan/tasks.md` - What to do
- `build/` - Commands to run
- `test/checklist.md` - Test cases
- `review/decision.md` - Approval
- `CHANGES.md` - Change log

## 3. Commit Message Format

Use clear, descriptive commit messages:
- `Phase1: Description`
- `Fix: Issue description`
- `Docs: What was added`

## 4. Test Before Push

Always test changes locally before pushing to repo.

## 5. No Breaking Changes

- Don't remove features without discussion
- Document any config changes
- Update Config.lua if adding new settings

## 6. Keep API Reference Updated

If you discover new WoW Classic APIs, add to `docs/API_REFERENCE.md`

---

**Last Updated:** 2026-02-24
