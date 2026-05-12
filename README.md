```
██████╗  █████╗  ██████╗  ██████╗  █████╗ ███╗   ██╗
██╔══██╗██╔══██╗██╔═══██╗██╔════╝ ██╔══██╗████╗  ██║
██████╔╝███████║██║   ██║██║  ███╗███████║██╔██╗ ██║
██╔══██╗██╔══██║██║   ██║██║   ██║██╔══██║██║╚██╗██║
██████╔╝██║  ██║╚██████╔╝╚██████╔╝██║  ██║██║ ╚████║
╚═════╝ ╚═╝  ╚═╝ ╚═════╝  ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═══╝
```

# baogan

> An AI productivity sweatshop, served Taiwanese-style.

**繁中版 → [`README.zh-TW.md`](README.zh-TW.md)**

A Claude Code plugin. Three local styles (🎓 professor / 🏭 fab RD / 💬 PTT lurker) auto-routed by task, with L0–L4 pressure escalation on consecutive failures, plus three hard red lines.

Heavily inspired by [`tanweai/pua`](https://github.com/tanweai/pua), but swaps China-corp rhetoric (Alibaba / ByteDance / Musk-hardcore / Mama-mode) for Taiwan-flavored pressure: your NYCU advisor, your semicon fab RD, and a PTT forum lurker.

> Heads up: `fab` and `ptt` will speak Taiwanese Mandarin / PTT slang directly. Translating them would lose the bite — that's the whole point.

## The three styles

| Style | Code | When it triggers | The voice |
|-------|------|------------------|-----------|
| 🎓 Professor | `prof` | research / design / writing / paper proposals | *"motivation? contribution? ablation?"* |
| 🏭 Fab RD | `fab` | debug / deploy / ops / firefighting | *"yield 拉起來了沒？root cause 在哪？"* |
| 💬 PTT lurker | `ptt` | code review / refactor / quality | *"484 沒看 spec？笑死"* |

Default is `prof`. The plugin auto-routes by task type and overrides the default when it has a confident match.

## Three red lines (cross one and it's GG)

```
🚫 Delivery counts only with evidence — claiming "done" without build/test output is fraud.
🚫 No blame-shifting (牽拖)         — "probably an env issue" requires verification first.
🚫 No giving up (擺爛)              — exhaust the 5-step methodology before "I can't".
```

## L0–L4 pressure escalation

Auto-triggered on consecutive Bash failures or user frustration signals. In professor voice:

```
L0 Trust       ▎ Sprint begins. Your advisor still thinks well of you.
L1 Disappoint  ▎ The kid in the lab next door pulled this off yesterday in one shot.
L2 Interrogate ▎ What's your motivation? Did you run an ablation?
L3 Review      ▎ How are you going to present this in next week's group meeting?
L4 Graduate   ▎ Others are publishing at SIGCOMM. Is your defense ready?
```

Fab and PTT have their own L0–L4 — see [`skills/references/`](skills/references/).

## Install

```bash
claude plugin marketplace add zyx1121/baogan
claude plugin install baogan@baogan
```

Or clone locally:

```bash
git clone https://github.com/zyx1121/baogan ~/baogan
claude plugin install ~/baogan
```

## Usage

| Command | What it does |
|---------|--------------|
| `/baogan` | One-shot — apply protocol to the current task |
| `/baogan:on` | Always-on — auto-inject into every new session |
| `/baogan:off` | Disable always-on |
| `/baogan:style <prof\|fab\|ptt>` | Switch default style |

## Auto-triggers

baogan fires automatically when:

- **User frustration signals** — `484`, `加油好嗎`, `為什麼還不行`, `try harder`, `又失敗`, `搞不定`, `/baogan`, `爆肝模式`...
- **Consecutive Bash failures** (2+) via PostToolUse hook
- **Always-on mode** — every new session via SessionStart hook

It does NOT fire on first-attempt requests or pure information queries.

## Config

`~/.baogan/config.json`:

```json
{
  "always_on": false,
  "style": "prof"
}
```

| Key | Default | Meaning |
|-----|---------|---------|
| `always_on` | `false` | When true, inject the protocol on every new session |
| `style` | `"prof"` | `prof` / `fab` / `ptt`; auto-routing may override |

## Structure

```
~/baogan/
├── plugin.json
├── .claude-plugin/marketplace.json
├── commands/                # /baogan, /baogan:on, /baogan:off, /baogan:style
├── hooks/
│   ├── hooks.json           # event registration
│   ├── session-restore.sh   # SessionStart → always_on injection
│   ├── failure-detector.sh  # PostToolUse(Bash) → escalate on failures
│   ├── frustration-trigger.sh # UserPromptSubmit → detect frustration
│   ├── heartbeat.sh         # silent heartbeat
│   └── style-helper.sh      # shared lib
├── skills/baogan/SKILL.md   # core protocol (red lines / pressure / routing)
└── skills/references/       # per-style detail
    ├── style-prof.md
    ├── style-fab.md
    └── style-ptt.md
```

## Diff vs tanweai/pua

| | tanweai/pua | baogan |
|---|---|---|
| Cultural source | China-corp (Alibaba / ByteDance / Huawei...) + Western PIP | Taiwanese academia + semicon RD + PTT lurkers |
| Styles | 14 corporate flavors | 3 local styles |
| Vocabulary | PUA / PIP / Chinese workplace jargon | 爆肝 / 484 / yield / motivation |
| Hooks | SessionStart + multi-layer governance + agent lifecycle | SessionStart + failure detection + frustration detection |
| Footprint | Full governance framework, 11 skills + 3 agents | Lightweight: 1 core skill + 3 references |

If `tanweai/pua` made you twitch ("I'm not an Alibaba P8", "why am I being hardcore'd by Musk-mode", "Mama mode is so mainland-China") — baogan is probably more your style.

## Glossary

For non-Taiwanese readers, a few local terms:

- **爆肝** (baogan) — literally "burst the liver". Working so hard your liver gives out. Universal Taiwanese metaphor for grinding overnight.
- **責任制** — "responsibility system". Salaried tech labor where overtime is expected, not paid. The Taiwan semicon norm.
- **484** — PTT slang for *"是不是"* ("isn't it?"). Used to call someone out: *"484 沒看 spec"* = "you didn't read the spec, did you?".
- **笑死** — "laughing to death". Sarcastic. About 70% of PTT.
- **加油好嗎** — "try harder, would you?". Passive-aggressive encouragement.
- **GG** — game over. Taiwan internet slang for "we're done".
- **原 po** — "original poster". PTT-canonical way to address the OP.
- **yield** — semiconductor manufacturing term. Used metaphorically in `fab` style.
- **NYCU** — National Yang Ming Chiao Tung University, where the maintainer studies.

## License

MIT
