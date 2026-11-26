---
title: "Merging Pull Requests: Rules, Auto-Merge, Merge Queues, and Agent Merge"
date: 2026-11-26
lastmod: 2026-11-26
weight: 65
draft: true
description: "Merge rules for small teams on GitHub: required review, linked issues that close on merge, auto-deleted branches, auto-merge, merge queues, and Agent Merge."
tags: ["Pull Requests", "GitHub", "Code Review", "AI Agents", "Software Engineering"]
categories: ["Software Engineering"]
summary: "The rules a team should enforce at merge time on GitHub, the settings that enforce them, and how auto-merge, merge queues, and Copilot's Agent Merge change who does the work and who makes the decision."
---

## For leads

The merge is the moment a change becomes part of the product. Make these
five rules settings, not habits:

1. **No merge without a person's review.** The deploy branch requires an
   approving review from someone other than the author, and only a
   person's approval counts. A change to the code after approval needs a
   new approval.
2. **Pull requests and issues link both ways.** The description names
   each issue the pull request addresses and says which ones it finishes.
   GitHub adds the link back on the issue.
3. **Merging closes the loop.** When the pull request merges, GitHub closes
   the issues it finished. Nobody tidies up by hand.
4. **Merged branches are deleted automatically.** The branch list shows
   work in progress, not history.
5. **Automation waits and fixes; a person decides.** Auto-merge, merge
   queues and agents can do the waiting, rebasing and repairing. The
   approval is the decision, and a person gives it.

What doesn't change: a merge is a decision someone is accountable for.
Automation moves the click; it doesn't move the accountability.

## What this page covers

[Version control](/software/version-control-systems/) covers branches and
history, and [peer review](/software/peer-review/) covers what a reviewer
should look for. This page covers what happens between "approved" and
"merged": the rules the repository enforces, the links between issues and
pull requests, and the GitHub features that automate the merge itself. The
[release process](/software/release-process/) picks up after the merge.

The examples use GitHub, and the feature details change often, so each
section links to GitHub's documentation. GitLab and Bitbucket have
equivalents for most of it under different names.

## Rule 1: A person reviews before anything merges

A rule that relies on people remembering it will be broken the first busy
afternoon. Put it in a branch ruleset (Settings → Rules → Rulesets) on the
deploy branch, or in classic branch protection if that's what the
repository already uses. The full list is in GitHub's
[available rules for rulesets](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets/available-rules-for-rulesets).
Rulesets on private repositories need a paid plan (Pro, Team or Enterprise
Cloud); on GitHub Free they cover public repositories only.

The settings that matter:

- **Require a pull request before merging.** No direct pushes, for people
  or agents.
- **Required approvals: 1 or more.** Someone other than the author has
  looked.
- **Dismiss stale pull request approvals when new commits are pushed.**
  GitHub dismisses an approval when the pull request's diff changes after
  the review, whether from a new commit or an update from the base branch.
- **Require approval of the most recent reviewable push.** A separate rule
  with a different job: whoever pushed last can't be the one whose approval
  satisfies the requirement. It stops someone from pushing a last-minute
  change and then approving it themselves.
- **Require conversation resolution before merging.** Review comments
  can't be silently left behind.
- **Require status checks to pass.** The required checks ran on this
  change and passed. That shows the checks agree with the code, not that
  the checks are any good; reviewing the tests is still part of review.
- **Block force pushes.** History on the deploy branch stays put.

The stale-approval rule is the one teams skip, and it matters more once
agents are involved. An agent can push a fix commit minutes after a person
approves. Without the rule, that commit merges on an approval given to
different code.

### Make sure the approval is a person's

Two settings can quietly turn "a person approved this" into something
else:

- **Copilot approvals.** GitHub now lets Copilot code review approvals
  count toward required approvals. In a repository the setting is
  **Allow Copilot approvals to count toward merge requirements** (Settings
  → Copilot → Code review); organizations and enterprises have their own
  versions. Where your policy says a person approves, keep it off. See
  [configuring Copilot code review](https://docs.github.com/en/copilot/how-tos/copilot-on-github/set-up-copilot/configure-code-review).
- **Bypass.** In classic branch protection, admins can bypass the rules
  unless you turn on the option that applies them to administrators too.
  In a ruleset, everyone on the bypass list can skip it. Keep that list
  short, and keep automation identities off it.

### A note for solo maintainers

GitHub doesn't let the author of a pull request approve it. If you are the
only person with write access, a required approval will block you, and the
usual way out is an admin bypass, which removes the gate entirely.

Agents make this worse. If an agent opens pull requests under your
account, you are the author and can't approve its work. Running the agent
under its own identity, a GitHub App or a separate bot account, puts you
back in the reviewer's seat. That doesn't work for Copilot's own agent:
GitHub says that where approvals are required,
[your approval of a Copilot pull request won't count](https://docs.github.com/en/copilot/how-tos/copilot-on-github/use-copilot-agents/review-copilot-output),
so someone else has to approve it. A solo maintainer can't meet a required
approval on a Copilot pull request at all. Decide which of these you are
choosing before you turn the requirement on.

## Rule 2: Pull requests and issues link both ways

The issue says why the work exists; the pull request says what changed.
Link them, and either one leads to the other.

In the pull request description, use a closing keyword for each issue the
pull request finishes:

```text
Closes #142
Fixes #150
Refs #138
```

`Closes`, `Fixes` and `Resolves` (and their other tenses) tell GitHub to
close the issue on merge. `Refs` is a plain reference: it links the issue
without closing it. Use it when the pull request is one of several that
make up the work, so the issue stays open until the last one lands. Each
issue needs its own keyword; `Closes #142, #150` closes only #142.

Two limits catch people out:

- Closing keywords only work when the pull request targets the
  repository's default branch. A pull request into a release branch, or
  into another pull request's branch in a stack, closes nothing.
- A keyword in a commit message also closes the issue when the commit
  reaches the default branch, but the pull request that carried the commit
  isn't listed as linked. Put the keywords in the description.

If you forget the keyword, link the issue from the pull request's
Development sidebar instead. It takes up to ten issues per pull request.
GitHub's
[linking a pull request to an issue](https://docs.github.com/en/issues/tracking-your-work-with-issues/using-issues/linking-a-pull-request-to-an-issue)
has the full keyword list and the syntax for issues in other repositories.

The link back is mostly free. When a pull request mentions an issue,
GitHub adds a cross-reference to the issue's timeline, and a pull request
linked with a closing keyword or through the sidebar appears in the
issue's Development section. So the rule is "link from the pull request,"
not "edit the issue too." What does need a person is the record: if the
work ended up different from what the issue described, say so in a comment
before the issue closes.

## Rule 3: Merging closes the loop

When a linked pull request merges into the default branch:

- The pull request is marked merged and closed.
- Every issue it named with a closing keyword or the sidebar is closed,
  with a link to the merge.
- Issues it only referenced with `Refs` stay open.

Issue closing depends on a repository setting, **Auto-close issues with
merged linked pull requests** (Settings → General → Issues). It's on by
default, but someone can turn it off, for example a team whose QA retests
before an issue closes. See
[managing the automatic closing of issues](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/managing-repository-settings/managing-auto-closing-issues).

If an issue that should have closed is still open, the usual causes are:
the setting is off, the pull request targeted a branch other than the
default, the keyword was in a comment rather than the description, or the
issue is in a repository the person merging can't close issues in.

## Rule 4: Merged branches are deleted automatically

Turn on **Automatically delete head branches** under Settings → General →
Pull Requests. After a merge, GitHub deletes the branch the pull request
came from, with some exceptions:

- Branch protection rules and rulesets can prevent a branch from being
  deleted.
- For a pull request from a fork, the fork's setting applies, and the
  person merging needs write access to the fork. Otherwise the branch
  stays.

Two details make the deletion safe. A deleted branch can be restored from
the merged pull request's page. And if another open pull request used the
deleted branch as its base, GitHub retargets it to the merged pull
request's base branch, so stacked pull requests keep working. See
[managing the automatic deletion of branches](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/configuring-pull-request-merges/managing-the-automatic-deletion-of-branches).

Locally, `git fetch --prune` removes the stale remote-tracking branches, and
`gh pr merge --delete-branch` does the same cleanup when you merge from the
command line.

## Rule 5: Automation waits and fixes; a person decides

GitHub offers three levels of merge automation. Each one is safe exactly
to the extent that Rule 1 holds: a person's approval is required, and it
expires when the code changes.

### Auto-merge: merge when the requirements are met

Without auto-merge, someone approves a pull request and then waits for CI
to finish before clicking Merge. Often they forget, and the approved change
sits for a day.

Auto-merge removes the wait. Enable it once under Settings → General →
Pull Requests (**Allow auto-merge**). Then, on a pull request that isn't
mergeable yet, click **Enable auto-merge** and choose the merge method, or
from the command line:

```bash
gh pr merge 142 --auto --squash --delete-branch
```

GitHub merges the pull request when every requirement on the branch is
met: approvals, status checks, resolved conversations. If a check fails or
a reviewer requests changes, nothing merges. On GitHub Free, auto-merge
works only in public repositories. See
[automatically merging a pull request](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/incorporating-changes-from-a-pull-request/automatically-merging-a-pull-request).

Auto-merge is only as good as the rules behind it. With a person's
approval required and stale approvals dismissed, the person who approves
is making the merge decision in advance, and any later change has to be
approved again. Take away either condition and the decision moves
somewhere else. With no required review, auto-merge means "merge whatever
passes CI." With Copilot approvals counting, it can mean "merge whatever
an agent approved." Most teams think they have neither policy.

### Merge queues: merge in order, tested together

Two pull requests can each pass CI against the main branch and still break
it when both merge, because neither was tested with the other. The usual
workaround, "Require branches to be up to date before merging," turns a
busy repository into a race: every merge forces every other open pull
request to update and rerun CI.

A merge queue solves this. Approved pull requests join a queue instead of
merging directly. The queue tests each one against the latest target branch plus
every pull request ahead of it, and merges only when the required checks pass on
that combination. If a queued pull request fails, it is removed from the queue
and its author is notified; the rest of the queue carries on.

To set one up:

1. In the branch ruleset, add **Require merge queue** and choose the merge
   method, how many groups can build at once, and the group size limits.
2. Make the CI workflows that report required checks run on queue groups.
   Add the `merge_group` trigger alongside `pull_request`:

   ```yaml
   on:
     pull_request:
     merge_group:
   ```

   Without it, the required checks never run on the queue group, never report,
   and the merge fails.
3. On an approved pull request, click **Merge when ready**, or run
   `gh pr merge --auto`. The pull request joins the queue once its own
   requirements are met.

Check availability before planning around it. Merge queues are available in
public repositories owned by an organization, and in private repositories owned
by organizations on GitHub Enterprise Cloud. Repositories owned by a personal
account, and private repositories on the Team plan, don't have them. See
[merging a pull request with a merge queue](https://docs.github.com/en/pull-requests/how-tos/merge-and-close-pull-requests/merging-a-pull-request-with-a-merge-queue).

**Do you need one?** Probably not until merges collide. A small team
merging a few pull requests a day is fine with auto-merge and up-to-date
branches. A queue earns its setup when the main branch breaks from changes
that each passed alone, or when people spend real time updating branches
to keep up. Agents producing many small pull requests get you there
sooner.

### Agent Merge: an agent clears the blockers

Agent Merge is Copilot's feature for the last mile. Copilot watches a pull
request and fixes what blocks it from merging: failing GitHub Actions workflows,
merge conflicts, or both.

To use it on GitHub, click **Watch and fix** in the pull request's merge box and
pick which blockers Copilot should handle. Copilot does the work in a cloud
environment and records what it did on the pull request's timeline. You can turn
it on for every pull request you open from your Copilot settings. In the GitHub
Copilot desktop app it goes further: there it can also address review comments,
and it reads the pull request, fixes what blocks it, and merges as soon as
GitHub allows. The cloud version needs a paid Copilot plan, and organization or
enterprise policy can turn it off. See
[managing issues and pull requests with the GitHub Copilot app](https://docs.github.com/en/copilot/how-tos/github-copilot-app/managing-issues-and-pull-requests)
and the
[Agent Merge announcement](https://github.blog/changelog/2026-10-28-agent-merge-watches-and-fixes-pull-requests-in-the-cloud).

It is designed to pair with auto-merge: Copilot keeps the pull request
mergeable, and GitHub merges it when the requirements are met. That pairing
is where the review gate either holds or quietly disappears.

GitHub's documentation doesn't describe a separate approval path for Agent
Merge, so your branch rules decide. Consider the sequence: a person
approves, auto-merge is on, `main` moves, and a conflict appears. Copilot
resolves it and pushes. If stale approvals are dismissed, the pull request
waits for someone to review the resolution. If they aren't, the
resolution, which nobody has read, merges on the earlier approval. And if
Copilot approvals count toward the requirement, an agent can fix the code,
approve it, and merge it with no person involved at all.

A conflict resolution is new code. It decides which side of a conflict
wins, and an agent fixing a failing workflow may change the test rather
than the code. Treat Agent Merge commits like any other agent commits:

- Before turning on Agent Merge, turn on **Dismiss stale pull request
  approvals** and **Require approval of the most recent reviewable push**,
  and make sure Copilot approvals don't count toward merge requirements.
- Read changes under `.github/workflows/` and changes to tests with extra
  care. A fix that makes a check pass by weakening it is the failure to
  look for.
- Use Agent Merge to save a person the mechanical work, not to skip the
  re-review.

Set up that way, Agent Merge removes toil without removing the gate: the
agent does the rebase and the fix, and a person still approves what merges.

## Common pitfalls

**Closing keywords on the wrong branch.** A pull request into anything but
the default branch closes no issues, and nobody notices until the issues
pile up open.

**`Closes` on partial work.** The first of three pull requests closes the
issue, and the remaining work loses its home. Use `Refs` until the last
one.

**Approvals that survive new commits.** The most common way an unreviewed
change reaches `main`, and the easiest to prevent.

**Auto-merge without required review.** It turns "merge when ready" into
"merge when green."

**Admin bypass as the normal path.** If the maintainer bypasses the rules
on every merge, the repository has no rules. Classic branch protection
lets admins bypass by default.

**Counting Copilot approvals by accident.** One toggle turns "a reviewer
approved" into "a model approved." Check it at the repository and
organization level.

**Merge queue without `merge_group`.** Pull requests sit in the queue until
the status check timeout, then fail.

## Merge settings checklist

- [ ] Branch ruleset on the deploy branch: pull request required, 1+
      approvals, stale approvals dismissed, most recent push approved by
      someone else, conversations resolved, status checks required, force
      pushes blocked.
- [ ] Bypass list is short, and admins don't bypass by default.
- [ ] Copilot approvals don't count toward merge requirements, unless you
      have decided they should.
- [ ] **Auto-close issues with merged linked pull requests** is set the
      way the team expects.
- [ ] Pull request template prompts for `Closes #` / `Refs #` lines.
- [ ] **Automatically delete head branches** is on.
- [ ] **Allow auto-merge** is on, and the team agrees what an approval
      means when auto-merge is enabled.
- [ ] If using a merge queue: required-check workflows run on
      `merge_group`.
- [ ] If using Agent Merge: the two approval settings are on, and Copilot
      approvals don't count, before it is.
- [ ] Agents other than Copilot push under their own identity, so a person
      can approve their work. Copilot pull requests need a second human
      reviewer.

## Where this fits

- Previous: [Peer Review When AI Agents Write Some of the
  Code](/software/peer-review/) covers what the reviewer checks before
  approving.
- Next: [Software Release Process](/software/release-process/) covers how
  merged changes become a tagged, deployed release.
- See also: [Version Control Practices for Teams Working with AI
  Agents](/software/version-control-systems/) for branching and one writer per
  branch.
