# Victoria Universalis IV Workspace Handoff

Date: 2026-05-11

Workspace on the linux computer:

```txt
/home/thibault/Desktop/Delivery/HUB_INN/Victoria3/vic3Universalis1.13
```

This is a handoff to this now windows computer.

## Context

This workspace is a Victoria 3 mod. The `ve_` files belong to the `Victoria Universalis IV` subsystem, which adds Europa Universalis IV-style systems to Victoria 3:

- national ideas
- group ideas
- age bonuses and golden ages
- religion aspects and holy sites
- missionaries
- culture reforms and cultural missionaries/bureaucrats
- custom GUI panels and alerts

The main working assumption established in this session: files whose basename starts with `ve_` are the core Victoria Universalis IV files, but several required integration points are not named `ve_`.

## Skill Created

A local Codex skill was created for this subsystem:

```txt
/home/thibault/.codex/skills/vic3-victoria-universalis/SKILL.md
```

It also has a reference file:

```txt
/home/thibault/.codex/skills/vic3-victoria-universalis/references/architecture.md
```

The skill should be used when creating, editing, reviewing, balancing, or localizing Victoria Universalis IV content, especially `ve_` files for national ideas, group ideas, ages, religion, culture, scripted GUIs, GUI panels, point systems, and related hooks.

Important note for another computer: this skill lives outside the repo in `~/.codex/skills`, so it will not travel with the repository unless manually installed or recreated there. This handoff file contains the essential contents needed to reconstruct the working context.

## VE Architecture Notes

High-value files:

- `common/static_modifiers/ve_national_ideas.txt`: country national idea modifiers.
- `common/static_modifiers/ve_group_ideas.txt`: EU4-style group idea modifiers.
- `common/static_modifiers/ve_religion_aspects.txt`: religion passive/aspect modifiers.
- `common/static_modifiers/ve_holy_sites.txt`: holy site modifiers.
- `common/static_modifiers/ve_age.txt`: age and golden age bonuses.
- `common/static_modifiers/ve_culture.txt`: culture reform modifiers.
- `common/scripted_guis/ve_national_ideas.txt`: click actions for national ideas, traditions, and bonus.
- `common/scripted_guis/ve_idea.txt`: group idea GUI actions.
- `common/scripted_guis/ve_religion.txt`: religion aspect and missionary GUI actions.
- `common/scripted_guis/ve_culture.txt`: culture reform GUI actions.
- `common/scripted_guis/ve_ages.txt`: age objective and age bonus GUI actions.
- `common/scripted_effects/ve_set.txt`: startup setup, generic-country classification, traditions.
- `common/scripted_effects/ve_national_ideas.txt`: automatic national idea application and cancellation.
- `common/scripted_effects/ve_scripted_effects.txt`: dispatches country idea families.
- `common/script_values/ve_script_values.txt`: point display and monthly income formulas.
- `gui/ve_gui_panel.gui`: Victoria Universalis fullscreen panel shell.
- `gui/ve_panel_ideas.gui`: national/group ideas panel.
- `gui/ve_texticons.gui`: texticon definitions used by the idea UI.
- `localization/english/ve_*_l_english.yml`: canonical English localization.

Important non-`ve_` integration files:

- `events/developer_events.txt`: `dev.*` maintenance, monthly/yearly pulse effects, difficulty setup, and AI usage.
- `gui/ingame_hud.gui`: mounts `ve_temptlate_gui_panel`.
- `gui/states_panel.gui`: state-level missionary and cultural missionary buttons.

National idea unlock pattern:

```txt
national_idea_pool >= 3, 6, 9, 12, 15, 18, 21
```

Each country family generally has:

- two traditions
- seven ideas
- one completion bonus

## Work Done: Persia National Ideas

Persia was added as a national idea family using the `per_idea_*` key prefix.

Tags covered:

- `PER`
- `ki_ANS`, an alternate possible Persia tag

### Modifiers Added

File:

```txt
common/static_modifiers/ve_national_ideas.txt
```

Added keys:

```txt
per_idea_tradition_1
per_idea_tradition_2
per_idea_1
per_idea_2
per_idea_3
per_idea_4
per_idea_5
per_idea_6
per_idea_7
per_idea_bonus
```

Effects:

```txt
per_idea_tradition_1 = {
    building_group_bg_plantations_employee_mult = -0.3
}

per_idea_tradition_2 = {
    state_construction_mult = 0.15
}

per_idea_1 = {
    country_law_enactment_time_mult = -0.10
}

per_idea_2 = {
    state_infrastructure_from_population_add = 2
    state_infrastructure_from_population_max_add = 50
}

per_idea_3 = {
    country_bureaucracy_investment_cost_factor_mult = -0.2
}

per_idea_4 = {
    state_mortality_mult = -0.15
}

per_idea_5 = {
    state_trade_advantage_mult = 0.15
}

per_idea_6 = {
    unit_army_offense_mult = 0.1
}

per_idea_7 = {
    building_group_bg_plantations_throughput_add = 0.15
}

per_idea_bonus = {
    building_oil_rig_throughput_add = 0.2
}
```

Correction made during implementation: the original requested key was `building_group_bg_plantation_employee_mult`, but the repo consistently uses the plural valid key `building_group_bg_plantations_employee_mult`.

### Scripted Effects Added

File:

```txt
common/scripted_effects/ve_national_ideas.txt
```

Added:

- `persian_ideas`
- `cancel_persian_ideas`

These follow the existing national idea threshold pattern and remove modifiers when `national_idea_pool` drops below the matching threshold.

File:

```txt
common/scripted_effects/ve_scripted_effects.txt
```

Updated:

- `national_idea_mdf` dispatches both `c:PER` and `c:ki_ANS` to `persian_ideas = yes`.
- `cancel_national_idea_mdf` dispatches both `c:PER` and `c:ki_ANS` to `cancel_persian_ideas = yes`.

File:

```txt
common/scripted_effects/ve_set.txt
```

Updated:

- `set_national_idea` excludes both `c:PER` and `c:ki_ANS` from generic national ideas.
- `national_idea_traditions` gives both tags the Persian traditions.

### Scripted GUI Added

File:

```txt
common/scripted_guis/ve_national_ideas.txt
```

Added Persia branches for:

- `ve_national_idea_1`
- `ve_national_idea_2`
- `ve_national_idea_3`
- `ve_national_idea_4`
- `ve_national_idea_5`
- `ve_national_idea_6`
- `ve_national_idea_7`
- `ve_national_idea_tradition`
- `ve_national_idea_bonus`

Each branch targets either `c:PER` or `c:ki_ANS`.

### Texticons Added

File:

```txt
gui/ve_texticons.gui
```

Added 18 `PER_idea_icon_*` texticons and 18 `ki_ANS_idea_icon_*` aliases using existing assets under:

```txt
gfx/interface/ve_national_ideas/
```

The alternate `ki_ANS` icons mirror the `PER` icon textures.

### Localization Added

File:

```txt
localization/english/ve_modifiers_l_english.yml
```

Added:

```txt
per_idea_tradition_1:0 "Persian Tradition I"
per_idea_tradition_2:0 "Persian Tradition II"
per_idea_bonus:0 "Persian Bonus"
per_idea_1:0 "Persian Idea I"
per_idea_2:0 "Persian Idea II"
per_idea_3:0 "Persian Idea III"
per_idea_4:0 "Persian Idea IV"
per_idea_5:0 "Persian Idea V"
per_idea_6:0 "Persian Idea VI"
per_idea_7:0 "Persian Idea VII"
```

These are straightforward placeholder names. They can be replaced with flavor names later.

## Verification Done

Checks run during the session:

```sh
git diff --check
```

Brace-balance checks were run on touched `.txt`, `.gui`, and `.yml` files.

Reference/count checks confirmed:

- 10 Persian static modifier blocks.
- 9 scripted GUI Persia branches.
- 18 `PER_idea_icon_*` texticons.
- 18 `ki_ANS_idea_icon_*` texticons.
- 10 English `per_idea_*` localization keys.
- All new texticon texture paths exist.
- The singular invalid plantation employee modifier key no longer appears.

## Balance Notes

No repeatable birth-rate effect was added.

Strong but acceptable permanent national idea effects:

- `state_construction_mult = 0.15`
- `unit_army_offense_mult = 0.1`
- `building_oil_rig_throughput_add = 0.2`
- `building_group_bg_plantations_throughput_add = 0.15`

These were treated as acceptable because they are permanent national idea rewards, not repeatable event rewards.

## Current Working Habits for Future VE Work

When adding a new national idea country family:

1. Add static modifier blocks in `common/static_modifiers/ve_national_ideas.txt`.
2. Add apply/cancel effects in `common/scripted_effects/ve_national_ideas.txt`.
3. Add dispatcher branches in `common/scripted_effects/ve_scripted_effects.txt`.
4. Exclude the tag from generic ideas and add traditions in `common/scripted_effects/ve_set.txt`.
5. Add scripted GUI button branches in `common/scripted_guis/ve_national_ideas.txt`.
6. Add texticons in `gui/ve_texticons.gui` if the tag needs visible national idea icons.
7. Add localization in `localization/english/ve_modifiers_l_english.yml`.
8. Run reference and brace checks.

If a country has alternate tags, mirror every tag-sensitive branch:

- dispatcher
- cancel dispatcher
- generic exclusion
- traditions
- scripted GUI idea buttons
- texticon aliases if the GUI composes icons from the active country tag

## Useful Commands

Search for Persia idea wiring:

```sh
rg -n "per_idea_|persian_ideas|cancel_persian_ideas|c:PER|c:ki_ANS|PER_idea_icon|ki_ANS_idea_icon" common gui localization/english
```

Check touched files for simple brace balance:

```sh
python3 - <<'PY'
from pathlib import Path
files = [
    'common/static_modifiers/ve_national_ideas.txt',
    'common/scripted_effects/ve_national_ideas.txt',
    'common/scripted_effects/ve_scripted_effects.txt',
    'common/scripted_effects/ve_set.txt',
    'common/scripted_guis/ve_national_ideas.txt',
    'gui/ve_texticons.gui',
    'localization/english/ve_modifiers_l_english.yml',
]
for f in files:
    text = Path(f).read_text(encoding='utf-8-sig')
    balance = 0
    min_balance = 0
    for ch in text:
        if ch == '{':
            balance += 1
        elif ch == '}':
            balance -= 1
            min_balance = min(min_balance, balance)
    print(('OK' if balance == 0 and min_balance >= 0 else f'BAD {balance} {min_balance}'), f)
PY
```

Check whitespace errors:

```sh
git diff --check
```

## Open Follow-Ups

- Replace placeholder Persian idea names with proper flavor names if desired.
- Consider adding translations for non-English `ve_modifiers_l_*.yml` files if the project expects them to stay in sync.
- If more alternate Persian tags exist, apply the same alias pattern used for `ki_ANS`.