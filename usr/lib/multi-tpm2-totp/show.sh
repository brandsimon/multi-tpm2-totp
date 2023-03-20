#!/bin/sh
cd "${1}" || exit 1
while true; do
	for label in *; do
		index="$(cat "${label}")"
		totp="$(tpm2-totp calculate --time --nvindex "${index}")" || continue
		printf '%s %s\n' "${totp}" "${label}"
	done
	printf 'Press CTRL+C to continue\n'
	curr="$(date +%s)"
	wait="$((30 - curr % 30))"
	if [ "${wait}" = "0" ]; then
		sleep 30
	else
		sleep "${wait}"
	fi
done
