#!/usr/bin/env bash
set -euo pipefail

shopt -s nullglob

SYS_CLASS_DRM="${GPU_TEMPERATURE_DRM_ROOT:-/sys/class/drm}"
SYS_CLASS_HWMON="${GPU_TEMPERATURE_HWMON_ROOT:-/sys/class/hwmon}"

declare -A SEEN_HWMON=()
declare -a TEMP_LINES=()

max_temp=-9999

json_escape() {
	local value="${1//\\/\\\\}"
	value="${value//\"/\\\"}"
	value="${value//$'\n'/\\n}"
	value="${value//$'\t'/\\t}"
	printf '%s' "$value"
}

hwmon_name() {
	local hwmon="$1"

	if [[ -r "$hwmon/name" ]]; then
		<"$hwmon/name"
	else
		basename "$hwmon"
	fi
}

scan_hwmon() {
	local hwmon="$1"
	local source="$2"
	local real_hwmon

	real_hwmon="$(readlink -f "$hwmon" 2>/dev/null || printf '%s' "$hwmon")"
	if [[ -n "${SEEN_HWMON[$real_hwmon]:-}" ]]; then
		return 0
	fi
	SEEN_HWMON["$real_hwmon"]=1

	local input raw temp_c label label_path label_name
	for input in "$hwmon"/temp*_input; do
		if ! raw="$(<"$input")"; then
			continue
		fi
		[[ "$raw" =~ ^-?[0-9]+$ ]] || continue

		temp_c=$(((raw + 500) / 1000))
		label="${input##*/}"
		label="${label%_input}"
		label_path="${input%_input}_label"

		if [[ -r "$label_path" ]]; then
			label_name="$(<"$label_path")"
			if [[ -n "$label_name" ]]; then
				label="$label_name"
			fi
		fi

		TEMP_LINES+=("${source} ${label}: ${temp_c}°C")

		if ((temp_c > max_temp)); then
			max_temp="$temp_c"
		fi
	done
}

for card in "$SYS_CLASS_DRM"/card[0-9]*; do
	[[ -e "$card/device" ]] || continue

	driver=""
	if [[ -e "$card/device/driver" ]]; then
		driver="$(basename "$(readlink -f "$card/device/driver")")"
	fi
	[[ "$driver" == "simpledrm" ]] && continue

	source="$(basename "$card")"
	if [[ -n "$driver" ]]; then
		source="${source} (${driver})"
	fi

	for hwmon in "$card/device"/hwmon/hwmon*; do
		scan_hwmon "$hwmon" "$source"
	done
done

for hwmon in "$SYS_CLASS_HWMON"/hwmon*; do
	name="$(hwmon_name "$hwmon")"
	case "${name,,}" in
		amdgpu|radeon|nouveau|nvidia|i915|xe|intel_gpu)
			scan_hwmon "$hwmon" "$name"
			;;
	esac
done

if ((${#TEMP_LINES[@]} == 0)); then
	echo '{"text":"","tooltip":"No GPU temperature sensor found","class":"unavailable"}'
	exit 0
fi

class="normal"
if ((max_temp >= 85)); then
	class="critical"
elif ((max_temp >= 75)); then
	class="warning"
fi

tooltip="$(printf '%s\n' "${TEMP_LINES[@]}")"
tooltip="${tooltip%$'\n'}"

printf '{"text":"GPU%s°C","tooltip":"%s","class":"%s"}\n' \
	"$max_temp" \
	"$(json_escape "$tooltip")" \
	"$class"
