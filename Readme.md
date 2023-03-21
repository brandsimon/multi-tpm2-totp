multi-tpm2-totp
---------------

Attest the trustworthiness of a device against a human using multiple
time-based one-time passwords at boot.

## Configuration

Currently only mkinitcpio is supported. To enable it, add `multi-tpm2-totp`
to the `HOOKS` in `/etc/mkinitcpio.conf`.

## Add totp key

To add multiple keys, change the nvindex per key.

```bash
nvindex="0x018094B0"
tpm2-totp --nvindex "${nvindex}" --pcrs 7 init
echo "${nvindex}" > /etc/multi-tpm2-totp/LABEL
```

Now rebuild your initramfs.
