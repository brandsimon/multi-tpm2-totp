#!/bin/sh
print_totp() {
	name="${1}"
	label="${2}"
	gap="${3}"
	index="$(cat "${label}")"
	if totp="$(tpm2-totp calculate --nvindex "${index}" 2>&1)"; then
		printf '%s%s %s\n' "${gap}" "${totp}" "${name}"
	else
		err="$(printf "%s" "${totp}" | tail -n 1)"
		printf '%s ERROR %s: %s\n' "${gap}" "${name}" "${err}"
	fi
}
print_dir() {
	dir="${1}"
	gap="${2}"
	for label in "${dir}"/*; do
		if [ -f "${label}" ]; then
			name="${label#"${dir}/"}"
			print_totp "${name}" "${label}" "${gap}"
		fi
	done
}
cd "${1}" || exit 1
while true; do
	printf '\n'
	before="$(date +%s)"
	date +"%Y-%m-%d %H:%M:%S:"
	print_dir "." " "
	for dir in *; do
		if [ -d "${dir}" ]; then
			printf ' %s:\n' "${dir}"
			print_dir "${dir}" "  "
		fi
	done
	printf 'Press CTRL+C to continue\n'
	curr="$(date +%s)"
	if  [ "$((before % 60 / 30))" != "$((curr % 60 / 30))" ]; then
		# this round started before the current 30s interval, but
		# ended afterwards. Some TOTP might be out of date, so
		# calculate them again.
		continue
	fi
	wait="$((30 - curr % 30))"
	if [ "${wait}" = "0" ]; then
		sleep 30
	else
		sleep "${wait}"
	fi
done
