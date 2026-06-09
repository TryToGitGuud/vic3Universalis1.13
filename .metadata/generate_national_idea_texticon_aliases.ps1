$ErrorActionPreference = "Stop"

$sets = [ordered]@{
	Dutch = @{
		Tags = @("NET", "BEL", "UNL")
		Icons = [ordered]@{
			"1_trad" = "trade_efficiency"
			"2_trad" = "urbanization"
			"bonus" = "trade_route"
			"1" = "timer_ab_allow_feudal_de_jure_law"
			"2" = "mechanized_workshops"
			"3" = "trade_center"
			"4" = "field_hospitals"
			"5" = "authority_icon"
			"6" = "bureaucracy"
			"7" = "diplomatic_upkeep"
		}
	}
	Italian = @{
		Tags = @("SAR", "ITA")
		Icons = [ordered]@{
			"1_trad" = "morale_damage"
			"2_trad" = "prestige"
			"bonus" = "local_production_efficiency"
			"1" = "engineering_university"
			"2" = "legitimacy"
			"3" = "aggresive_exp_icon"
			"4" = "land_morale_opposite"
			"5" = "railways"
			"6" = "can_colony_boost_development"
			"7" = "global_manpower_modifier"
		}
	}
	Spanish = @{
		Tags = @("SPA", "IBE")
		Icons = [ordered]@{
			"1_trad" = "privilege_gold_mint"
			"2_trad" = "authority_icon"
			"bonus" = "naval_morale"
			"1" = "mechanized_workshops"
			"2" = "engineering_university"
			"3" = "local_production_efficiency"
			"4" = "trade_efficiency"
			"5" = "take_loan_button"
			"6" = "global_manpower_modifier"
			"7" = "land_morale_opposite"
		}
	}
	Swedish = @{
		Tags = @("SWE", "DEN", "SCA")
		Icons = [ordered]@{
			"1_trad" = "capitalists_15"
			"2_trad" = "local_production_efficiency"
			"bonus" = "approval_icon"
			"1" = "authority_icon"
			"2" = "can_colony_boost_development"
			"3" = "technology_cost"
			"4" = "mechanized_workshops"
			"5" = "no_migration_controls"
			"6" = "global_manpower_modifier"
			"7" = "railways"
		}
	}
}

$sets.GetEnumerator() | ForEach-Object {
	$duplicates = $_.Value.Icons.Values | Group-Object | Where-Object Count -gt 1
	if ($duplicates) {
		throw "Duplicate textures in $($_.Key) idea set: $(($duplicates.Name) -join ', ')"
	}
}

$lines = [System.Collections.Generic.List[string]]::new()
$lines.Add("# Text icon aliases for country tags that share national idea sets.")
$lines.Add("# Textures mirror the meaning of the associated static modifiers.")

foreach ($setName in $sets.Keys) {
	$set = $sets[$setName]
	foreach ($tag in $set.Tags) {
		$lines.Add("")
		$lines.Add("# $tag - $setName ideas")
		foreach ($suffix in $set.Icons.Keys) {
			$texture = $set.Icons[$suffix]
			$fontSize = if ($texture -in @("authority_icon", "professional_bureaucrats", "railways")) { 65 } else { 50 }

			$lines.Add("texticon = {")
			$lines.Add("  icon = ${tag}_idea_icon_$suffix")
			$lines.Add("  iconsize = {")
			$lines.Add("    offset = { 0 15 }")
			$lines.Add("    texture = `"gfx/interface/ve_national_ideas/$texture.dds`"")
			$lines.Add("    fontsize = $fontSize")
			$lines.Add("  }")
			$lines.Add("}")

			if ($suffix -notmatch "_trad$") {
				$lines.Add("texticon = {")
				$lines.Add("  icon = ${tag}_idea_icon_${suffix}_black")
				$lines.Add("  iconsize = {")
				$lines.Add("    offset = { 0 15 }")
				$lines.Add("    texture = `"gfx/interface/ve_national_ideas/${texture}_black.dds`"")
				$lines.Add("    fontsize = $fontSize")
				$lines.Add("  }")
				$lines.Add("}")
			}
		}
	}
}

$outputPath = Join-Path $PSScriptRoot "..\gui\ve_national_idea_texticon_aliases.gui"
$content = ($lines -join "`r`n") + "`r`n"
[IO.File]::WriteAllText($outputPath, $content, [Text.UTF8Encoding]::new($false))
